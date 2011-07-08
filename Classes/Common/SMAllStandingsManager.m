//
//  SMAllStandingsManager.m
//  SuperMetric
//
//  Created by Amey Tavkar on 12/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMAllStandingsManager.h"
#import "XMLUtil.h"
#import "XMLNode.h"
#import "SMUserData.h"
#import "ConfigureApp.h"

@interface SMAllStandingsManager()
//-(void)downloadAllStandingsData;
- (NSMutableDictionary *) createTeamsWithDataReceived:(NSData *)receivedData;
- (NSMutableDictionary *) createTeamsWithStoredData;
@end

@implementation SMAllStandingsManager
//@synthesize allKeys;
@synthesize allGroups;


#define STORED_TEAMS	@"STORED_TEAMS"

static SMAllStandingsManager * sharedInstance = nil;
BOOL isConnectionProgress1 = NO;

+(SMAllStandingsManager *)sharedInstance {
	@synchronized( self ) {
		if( sharedInstance == nil ) {
			sharedInstance = [[SMAllStandingsManager alloc] init];
		}
	}
	return sharedInstance;
}

- (id) init {
	if( self = [super init] ) {
		allGroups = nil;
		//allKeys = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION1"],[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION2"] ,nil];	
		appDelegate = (APP_DELEGATE *)[[UIApplication sharedApplication] delegate];
		
	}
	return self;
}

#pragma mark -
#pragma mark Public Functions

- (NSDictionary *) getTeamsStandingsAccordingToConference{
	if(allGroups == NULL && isConnectionProgress1 == NO){
		[self downloadAllStandingsData];
	}
	return allGroups;
}

- (NSArray *) allKeys{
	allKeys = [[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION1"],[[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_SUBDIVISION2"] ,nil];	
	NSLog(@"ALL KEYS :: %@ ",allKeys);
	return allKeys;
}

#pragma mark -
#pragma mark Private
-(void)downloadAllStandingsData{
	[self allKeys];
	NSString *confID = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_CONFERENCE"];
	NSLog(@"TEST :: STANDINGS_PER_CONFERENCE :: %@", confID);
	NSString * allConferenceTeamsURL = [NSString stringWithFormat:STANDINGS_PER_CONFERENCE,confID];	
	NSLog(@"TEST :: downloadAllStandingsData :: %@", allConferenceTeamsURL);	
	
	NSURLRequest * theRequest = [NSURLRequest requestWithURL:[ NSURL URLWithString: allConferenceTeamsURL]];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLODING_TEAMS_DATA_STARTED" object:nil];
	isConnectionProgress1 = YES;
	dataReceived = [[NSMutableData alloc] init];
	teamsConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (NSMutableDictionary *) createTeamsWithDataReceived:(NSData *)receivedData {
	NSMutableDictionary * createdGroups = [[NSMutableDictionary alloc] init];
	NSString * allTeamsXML = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
	[[NSUserDefaults standardUserDefaults] setObject:allTeamsXML forKey:@"STORED_CONFERENCE_DATA"];
	NSLog(@"DEV TEST :: ALL TEAMS XML %@::", allTeamsXML);
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
		[teamInfo setWonconf:[[node childNamed:@"wonconf"] value]];
		[teamInfo setLostconf:[[node childNamed:@"lostconf"] value]];
		[teamInfo setWonall:[[node childNamed:@"wonall"] value]];
		[teamInfo setLostall:[[node childNamed:@"lostall"] value]];
		[teamInfo setTeamFlag:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[teamInfo abr]]]];
	//	[teamInfo setDelegate:self];
		
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
- (NSMutableDictionary *) createTeamsWithStoredData {
	NSMutableDictionary * createdGroups = [[NSMutableDictionary alloc] init];
	NSString * allTeamsXML = [[NSUserDefaults standardUserDefaults] objectForKey:@"STORED_CONFERENCE_DATA"];
	//NSLog(@"stored xml**:%@",allTeamsXML);
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
		[teamInfo setWonconf:[[node childNamed:@"wonconf"] value]];
		[teamInfo setLostconf:[[node childNamed:@"lostconf"] value]];
		[teamInfo setWonall:[[node childNamed:@"wonall"] value]];
		[teamInfo setLostall:[[node childNamed:@"lostall"] value]];
		[teamInfo setTeamFlag:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[teamInfo abr]]]];
			
		//	[teamInfo setDelegate:self];
		
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

#pragma mark -
#pragma mark SMTeamsInfoDelegate
//- (void) smTeamInfo:(SMTeamsInfo *)smTeam changedStatusTo:(TeamStatus)newStatus {
	//	[self registerTagsTeam:smTeam];
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
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLODING_TEAMS_DATA_ENDED" object:nil];
	allGroups = [[NSDictionary alloc] initWithDictionary:[self createTeamsWithStoredData]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOADED_TEAMS_DATA" object:nil];

	isConnectionProgress1 = NO;
	UIAlertView * alert = [[UIAlertView alloc] 
						   initWithTitle:NSLocalizedString(@"Could not connect to the internet",@"Could not connect to the internet") 
						   message:NSLocalizedString(@"You must connect to Wi-Fi or cellular data network to access this feature.",@"You must connect to Wi-Fi or cellular data network to access this feature.")
						   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLODING_TEAMS_DATA_ENDED" object:nil];
	isConnectionProgress1 = NO;
	if ( connection == teamsConnection ){
		allGroups = [[NSDictionary alloc] initWithDictionary:[self createTeamsWithDataReceived:dataReceived]];
		NSLog(@" Create data with teams :: all Groups :: %@ ",allGroups );
		
		if( dataReceived != NULL ) {
			[dataReceived release];
			dataReceived = NULL;
		}
		if( teamsConnection != NULL ) {
			[teamsConnection release]; 
			teamsConnection = NULL;
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOADED_TEAMS_DATA" object:nil];
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
	
	isConnectionProgress1 = NO;
}

- (void) dealloc {
	[self clearData];
	[super dealloc];
}

@end

