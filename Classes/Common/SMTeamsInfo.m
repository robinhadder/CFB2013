//
//  SMTeamsInfo.m
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "SMTeamsInfo.h"
#import "SMUserData.h"

@interface SMTeamsInfo() 
-( void) dislikeTeam;
@end

@implementation SMTeamsInfo

@synthesize teamID;
@synthesize teamFlag;
@synthesize group;
@synthesize subDivisions;
@synthesize nameEN;
@synthesize abr;
@synthesize isLike;
@synthesize delegate;
@synthesize wonconf;
@synthesize lostconf;
@synthesize wonall;
@synthesize lostall;
@synthesize teamStatus;

TeamStatus oldStatus;

- (id) init {
	if( self = [super init] ) {
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)dict {
	if( self = [super init] ) {
		[self setTeamID:[[dict objectForKey:TEAM_ID] intValue]];
		[self setGroup:[dict objectForKey:GROUP]];
		[self setSubDivisions:[dict objectForKey:SUBDIVISIONS]];
		[self setNameEN:[dict objectForKey:NAME_EN]];
		[self setAbr:[dict objectForKey:NAME_ABR]];
		//[self setRank:[[dict objectForKey:RANK] intValue]];
		//[self setIseliminated:[[dict objectForKey:IS_ELIMINATED] boolValue]];
		//[self setTeamStatus:[[dict objectForKey:TEAM_STATUS] intValue]];
		
		[self setTeamFlag:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",abr]]];
	}
	return self;
}
- (void) followTeam{ 
	
	if([[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"] != 0 ){
		[self dislikeTeam];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_TABLE" object:nil];
	}
	
	[[NSUserDefaults standardUserDefaults] setInteger:teamID forKey:@"prevTeamID"];
	LoginType loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
	NSString * loginID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
	
	NSString * followStatusURLString = nil;
	switch ( loginType ) {
		case kFacebookLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_FB];
			break;
			
		case kScoretoneLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_EMAIL];
			break;
	}
	followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,teamID,@"1"];
	NSLog(@"followStatusURLString LIKE::%@",followStatusURLString);
	if( followStatusURLString != nil ) {
		NSURL * statusURL = [NSURL URLWithString:followStatusURLString];
		NSURLRequest * therequest = [NSURLRequest requestWithURL:statusURL];
		dataReceived = [[NSMutableData alloc] init];
		oldStatus = teamStatus;
	//	teamStatus = status;
		teamsConnection = [[NSURLConnection alloc] initWithRequest:therequest delegate:self];
		[teamsConnection start];
	}
	if( delegate != nil ) {
		[delegate smTeamInfo:self changedStatusTo:teamStatus];
	}
	
}

-(void) dislikeTeam {
	LoginType loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
	NSString * loginID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
	
	NSString * followStatusURLString = nil;
	switch ( loginType ) {
		case kFacebookLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_FB];
			break;
			
		case kScoretoneLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_EMAIL];
			break;
	}
	int prevTeam = [[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"];
	followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,prevTeam,@"0"];
	NSLog(@"followStatusURLString DISLIKE::%@",followStatusURLString);
	if( followStatusURLString != nil ) {
		NSURL * statusURL = [NSURL URLWithString:followStatusURLString];
		NSURLRequest * therequest = [NSURLRequest requestWithURL:statusURL];
		dataReceived = [[NSMutableData alloc] init];
		oldStatus = teamStatus;
		//	teamStatus = status;
		teamsConnection = [[NSURLConnection alloc] initWithRequest:therequest delegate:self];
		[teamsConnection start];
	}
}

- (NSDictionary *) getDictionary {
	NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
	
	[dict setObject:[NSNumber numberWithInt:teamID] forKey:TEAM_ID];
	[dict setObject:group forKey:GROUP];
	[dict setObject:subDivisions forKey:SUBDIVISIONS];
	[dict setObject:nameEN forKey:NAME_EN];
	[dict setObject:abr forKey:NAME_ABR];
	return dict;
}

//- (BOOL) changeTeamStatusTo:(TeamStatus)status; {
	/*[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TEAM_REGQUEST_STATUS_CHANGE" object:nil];
	
	BOOL returnValue = NO;
	
	LoginType loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
	NSString * loginID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
	
	NSString * followStatusURLString = nil;
	switch ( loginType ) {
		case kFacebookLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_FB];
			break;
			
		case kScoretoneLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_EMAIL];
			break;
	}
	
	switch ( status ) {
		case kLike:
			followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,teamID,@"like"];
			break;
			
		case kDisLike:
			followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,teamID,@"Dislike"];
			break;
			
		case kNeutral:
			followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,teamID,@"none"];
			break;
	}
	
	if( followStatusURLString != nil ) {
		NSURL * statusURL = [NSURL URLWithString:followStatusURLString];
		NSURLRequest * therequest = [NSURLRequest requestWithURL:statusURL];
		dataReceived = [[NSMutableData alloc] init];
		oldStatus = teamStatus;
		teamStatus = status;
		teamsConnection = [[NSURLConnection alloc] initWithRequest:therequest delegate:self];
		[teamsConnection start];
	}
	return returnValue;*/
//}


- (BOOL) changeTeamStatusTo:(TeamStatus)status; {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"TEAM_REGQUEST_STATUS_CHANGE" object:nil];
	
	BOOL returnValue = NO;
	
	LoginType loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
	NSString * loginID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
	
	NSString * followStatusURLString = nil;
	switch ( loginType ) {
		case kFacebookLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_FB];
			break;
			
		case kScoretoneLogin:
			followStatusURLString = [NSString stringWithString:ADD_FOLLOW_STATUS_EMAIL];
			break;
	}
	
	//switch ( status ) {
//		case kLike:
		followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,teamID,@"like"];
	//		break;
//			
//		case kDisLike:
//			followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,teamID,@"Dislike"];
//			break;
//			
//		case kNeutral:
//			followStatusURLString = [NSString stringWithFormat:followStatusURLString,loginID,teamID,@"none"];
//			break;
//	}
//	
	if( followStatusURLString != nil ) {
		NSURL * statusURL = [NSURL URLWithString:followStatusURLString];
		NSURLRequest * therequest = [NSURLRequest requestWithURL:statusURL];
		//NSURLResponse * theresponse;
		//NSError * error;
		//[NSURLConnection sendSynchronousRequest:therequest returningResponse:&theresponse error:&error];
		dataReceived = [[NSMutableData alloc] init];
		oldStatus = teamStatus;
		teamStatus = status;
		
		teamsConnection = [[NSURLConnection alloc] initWithRequest:therequest delegate:self];
		/*
		 if( error ) {
		 UIAlertView * alert = [[UIAlertView alloc] 
		 initWithTitle:NSLocalizedString(@"Could not connect to the internet",@"Could not connect to the internet") 
		 message:NSLocalizedString(@"You must connect to Wi-Fi or cellular data network to access this feature.",@"You must connect to Wi-Fi or cellular data network to access this feature.")
		 delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];			
		 [alert show];
		 [alert release];
		 }
		 else {
		 
		 }
		 */
		[teamsConnection start];
	}
	return returnValue;
}

-(NSNumber *) overallRatingForConference{
	NSNumber * rating = [NSNumber numberWithInt:0]; 
	int wonConf = [wonconf intValue];
	int lossConf = [lostconf intValue];
	if (wonConf+lossConf > 0) {
		int overallInConf = (wonConf/(wonConf+lossConf))*100;	
		rating = [NSNumber numberWithInt:overallInConf];
	}
	return rating ;
	
}

-(NSNumber *) overallRating{
	NSNumber * ratingAll = [NSNumber numberWithInt:0]; 
	int wonAll = [wonall intValue];
	int lossAll = [lostall intValue];
	if (wonAll+lossAll > 0) {
		int overallInAll = ((float)wonAll/(float)(wonAll+lossAll))*100;	
		ratingAll = [NSNumber numberWithInt:overallInAll];
	}
	return ratingAll;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[dataReceived appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	teamStatus = oldStatus;
	if( delegate != nil ) {
		[delegate smTeamInfo:self changedStatusTo:teamStatus];
	}
	
	[dataReceived release];
	dataReceived = NULL;
	
	[teamsConnection cancel];
	[teamsConnection release];
	teamsConnection = NULL;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
	
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not connect to the internet",@"Could not connect to the internet")
													 message:NSLocalizedString(@"You must connect to Wi-Fi or cellular data network to access this feature.",@"You must connect to Wi-Fi or cellular data network to access this feature.")
													delegate:nil 
										   cancelButtonTitle:@"Ok" 
										   otherButtonTitles:nil];	
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"STOPINDICATOR" object:nil];
	NSLog(@"Data Teams :: %@",[[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding]);
	}

- (void) dealloc {
	NSLog(@"%@ Released",[self class]);
	if( teamFlag != nil ) {
		[teamFlag release];
	}
	if( group != nil ) {
		[group release];
	}
	if (subDivisions!=nil) {
		[subDivisions release];
	}
	if( nameEN != nil ) {
		[nameEN release];
	}
	if( abr != nil ) {
		[abr release];
	}
	[super dealloc];
}

@end
