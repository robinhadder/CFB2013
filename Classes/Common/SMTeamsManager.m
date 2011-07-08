//
//  SMTeamsManager.m
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMTeamsManager.h"
#import "XMLUtil.h"
#import "XMLNode.h"
#import "SMUserData.h"
#import "ConfigureApp.h"

@interface SMTeamsManager()

- (void) downloadTeamsData;
- (NSMutableDictionary *) createTeamsWithDataReceived:(NSData *)receivedData;
- (NSMutableDictionary *) createTeamsWithDataStored;
- (void) registerTagsTeam:(SMTeamsInfo *)team;

@end

@implementation SMTeamsManager

//@synthesize allKeys;
@synthesize allGroups;

#define STORED_TEAMS	@"STORED_TEAMS"

static SMTeamsManager * sharedInstance = nil;
BOOL isConnectionInProgress = NO;

+(SMTeamsManager *)sharedInstance {
	@synchronized( self ) {
		if( sharedInstance == nil ) {
			sharedInstance = [[SMTeamsManager alloc] init];
		}
	}
	return sharedInstance;
}

- (id) init {
	if( self = [super init] ) {
		allGroups = nil;
		allTeamsGroups = nil;
		//allKeys = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION1"],[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION2"] ,nil];	
		appDelegate = (APP_DELEGATE *)[[UIApplication sharedApplication] delegate];
		
	}
	return self;
}

- (NSArray *) allKeys{
	allKeys = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION1"],[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION2"] ,nil];	
	return allKeys;
}

#pragma mark -
#pragma mark Public Functions
- (NSDictionary *) getTeamsAccordingToGroup {
	NSLog(@"STORED_TEAM_DATA -%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"STORED_TEAM_DATA"]);
    if( allGroups == NULL && isConnectionInProgress == NO ) {
		[self downloadTeamsData];
	}
	return allGroups;
}

- (NSArray *) getAllTeams {
	NSMutableArray * allTeams = [[NSMutableArray alloc] init];
	
	NSDictionary * teamsDict = [self getTeamsAccordingToGroup];
	NSArray * allGroupsCode = [teamsDict allKeys];
	
	for( NSString * key in allGroupsCode ){
		NSMutableArray * teamsInGroup = [teamsDict objectForKey:key];
		for( SMTeamsInfo * teamInfo in teamsInGroup )
			[allTeams addObject:teamInfo];
	}
	return allTeams;
}

#pragma mark -
#pragma mark Private
- (void) downloadTeamsData {
	//NSString *confID = [[ConfigureApp sharedConfig]conferenceID];
	NSString *confID = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_CONFERENCE"];
	NSLog(@"TEST :: ALL TEAMS  :: %@", confID);
	NSString * allTeamsURL = [NSString stringWithFormat:ALL_TEAMS_URL,confID];
	NSLog(@"TEST :: allTeamsURL  :: %@", allTeamsURL);
	NSURLRequest * theRequest = [NSURLRequest requestWithURL:[ NSURL URLWithString:allTeamsURL]];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLODING_TEAMS_DATA_STARTED" object:nil];
	isConnectionInProgress = YES;
	dataReceived = [[NSMutableData alloc] init];
	teamsConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (NSMutableDictionary *) createTeamsWithDataReceived:(NSData *)receivedData {
	NSMutableDictionary * createdGroups = [[NSMutableDictionary alloc] init];
	NSString * allTeamsXML = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
	[[NSUserDefaults standardUserDefaults] setObject:allTeamsXML forKey:@"STORED_TEAM_DATA"];
	XMLUtil * xmlUtil = [[XMLUtil alloc] initWithXml:allTeamsXML];
	XMLXpathObject * lc_xpath = [xmlUtil evaluateXpath:[@"/" stringByAppendingString:@"xml"]];
	XMLNode * allTeamsNode = [[lc_xpath nodes] lastObject];
	//NSLog(@"DEV TES T :: ALL TEAM XML :: %@", allTeamsXML);
	NSMutableArray * allTeamsArray = [[NSMutableArray alloc] initWithArray:[allTeamsNode childrenNamed:@"item"]];
	NSLog(@"DEV TEST :: ALL TEAMS %@", allTeamsArray);
	for (XMLNode * node in allTeamsArray ){
		SMTeamsInfo * teamInfo = [[SMTeamsInfo alloc] init];
		[teamInfo setTeamID:[[[node childNamed:@"teamID"] value] intValue]];
		[teamInfo setGroup:[[node childNamed:@"conference"] value]];
		if([[node childNamed:@"subdivision"] value] == nil) {
			[teamInfo setSubDivisions:@"noSubDiv"];
			//[teamInfo setSubDivisions:[[ConfigureApp sharedConfig] subDivision1]];
		}
		else {
			[teamInfo setSubDivisions:[[node childNamed:@"subdivision"] value]];
			//[teamInfo setSubDivisions:[[ConfigureApp sharedConfig] subDivision2]];
		}
		[teamInfo setNameEN:[[node childNamed:@"name"] value]];
		[teamInfo setAbr:[[node childNamed:@"abbr"] value]];
		[teamInfo setTeamFlag:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[teamInfo abr]]]];
		[teamInfo setIsLike:NO];
		if([[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"] == [teamInfo teamID]) {
			[teamInfo setIsLike:YES];
		}
		[teamInfo setDelegate:self];
		
		NSMutableArray * teamInGroup = [createdGroups objectForKey:[teamInfo subDivisions]];
		
		if( teamInGroup == NULL ){
			teamInGroup = [[NSMutableArray alloc] init];
			[createdGroups setObject:teamInGroup forKey:[teamInfo subDivisions]]; 
			[teamInGroup release];
		}
		[teamInGroup addObject:teamInfo];
		[teamInfo release];
	}
	[allTeamsArray release];
	[lc_xpath release];
	[xmlUtil release];
	[allTeamsXML release];
	return createdGroups;
}


- (NSMutableDictionary *) createTeamsWithDataStored {
	NSLog(@"DEV TEST :Stored data"); 
	NSMutableDictionary * createdGroups = [[NSMutableDictionary alloc] init];
	NSString * allTeamsXML = [[NSUserDefaults standardUserDefaults] objectForKey:@"STORED_TEAM_DATA"];
	XMLUtil * xmlUtil = [[XMLUtil alloc] initWithXml:allTeamsXML];
	XMLXpathObject * lc_xpath = [xmlUtil evaluateXpath:[@"/" stringByAppendingString:@"xml"]];
	XMLNode * allTeamsNode = [[lc_xpath nodes] lastObject];
	NSMutableArray * allTeamsArray = [[NSMutableArray alloc] initWithArray:[allTeamsNode childrenNamed:@"item"]];
	for (XMLNode * node in allTeamsArray ){
		SMTeamsInfo * teamInfo = [[SMTeamsInfo alloc] init];
		[teamInfo setTeamID:[[[node childNamed:@"teamID"] value] intValue]];
		[teamInfo setGroup:[[node childNamed:@"conference"] value]];
		if([[node childNamed:@"subdivision"] value] == nil) {
			[teamInfo setSubDivisions:@"noSubDiv"];
		}
		else {
			[teamInfo setSubDivisions:[[node childNamed:@"subdivision"] value]];
		}
		[teamInfo setNameEN:[[node childNamed:@"name"] value]];
		[teamInfo setAbr:[[node childNamed:@"abbr"] value]];
		[teamInfo setTeamFlag:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[teamInfo abr]]]];
		[teamInfo setIsLike:NO];
		if([[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"] == [teamInfo teamID]) {
			[teamInfo setIsLike:YES];
		}
		[teamInfo setDelegate:self];
		
		NSMutableArray * teamInGroup = [createdGroups objectForKey:[teamInfo subDivisions]];
		
		if( teamInGroup == NULL ){
			teamInGroup = [[NSMutableArray alloc] init];
			[createdGroups setObject:teamInGroup forKey:[teamInfo subDivisions]]; 
			[teamInGroup release];
		}
		[teamInGroup addObject:teamInfo];
		[teamInfo release];
	}
	[allTeamsArray release];
	[lc_xpath release];
	[xmlUtil release];
	[allTeamsXML release];
	return createdGroups;
}

- (void) registerTagsTeam:(SMTeamsInfo *)team {
//	NSArray * allTeams = [self getAllTeams];
	NSMutableArray * tags = [[NSMutableArray alloc] init];
	//NSString * tag;
		if( team != NULL ) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"TEAM_STATUS_CHANGED" object:team];
	}
	//if( [tags count] > 0 ) {
	//	}
	//NSString * str = [NSString stringWithFormat:@"%@_%@",[[ConfigureApp sharedConfig] conferenceAbbr],[team abr]];
	NSString * str = [NSString stringWithFormat:@"%@_%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_CONFERENCE_ABBR"],[team abr]];
	NSLog(@"REGISTER TAG %@ ", str);
	[tags addObject:str];
	
	[appDelegate addTagsAction:tags];

	//[tags release];
//	[allTeams release];
}

	
#pragma mark -
#pragma mark SMTeamsInfoDelegate
- (void) smTeamInfo:(SMTeamsInfo *)smTeam changedStatusTo:(TeamStatus)newStatus {
	[self registerTagsTeam:smTeam];

}

//- (void) getTeamObject:(SMTeamsInfo *)teamInfo {
//	teamInfoToChkLike = teamInfo;
//	[tableView reloadData];
//}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[dataReceived appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if( dataReceived != NULL ) {
		[dataReceived release];
		dataReceived = NULL;
	}
	if( teamsConnection != NULL ) {
		[teamsConnection release]; 
		teamsConnection = NULL;
	}
	UIAlertView * alert = [[UIAlertView alloc] 
						   initWithTitle:@"Could not connect to the internet"
						   message:NSLocalizedString(@"You must connect to Wi-Fi or cellular data network to access this feature.",@"You must connect to Wi-Fi or cellular data network to access this feature.")
						   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	allGroups = [self createTeamsWithDataStored];	
	NSLog(@"allGroups:%@",allGroups);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLODING_TEAMS_DATA_ENDED" object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADED_TEAMS_DATA object:nil];

	isConnectionInProgress = NO;
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLODING_TEAMS_DATA_ENDED" object:nil];
	isConnectionInProgress = NO;
	if ( connection == teamsConnection ){
			allGroups = [self createTeamsWithDataReceived:dataReceived];	
			
		if( dataReceived != NULL ) {
			[dataReceived release];
			dataReceived = NULL;
		}
		if( teamsConnection != NULL ) {
			[teamsConnection release]; 
			teamsConnection = NULL;
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADED_TEAMS_DATA object:nil];
	}
}

- (void) clearData {
	if(  teamsConnection != nil ){
		[teamsConnection release];
		teamsConnection = NULL;
	}
	
	if( allGroups != nil ) {
		[allGroups release];
		allGroups = NULL;
	}
	
		if( allKeys != nil ) {
		[allKeys release];
		allKeys = NULL;
	}
	
	if( dataReceived != nil ) {
		[dataReceived release];
		dataReceived = NULL;
	}
	
	isConnectionInProgress = NO;
}

- (void) dealloc {
	[self clearData];
	[super dealloc];
}

@end
