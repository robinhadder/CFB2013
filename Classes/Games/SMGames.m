    //
//  SMGames.m
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMGames.h"
#import "SMUserData.h"
#import "SMGameInfo.h"
#import "XMLUtil.h"
#import "XMLNode.h"
#import "ConfigureApp.h"


@interface SMGames()

- (void) createTeamsWithData:(NSData *)xmlData;
- (void) downloadGamesSchedule;

@end


@implementation SMGames

- (void)viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadScheduleData:) name:@"RELOAD_SCHEDULE_DATA" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppName:) name:@"SET_APP_NAME" object:nil];
	nextGame = [[SMNextGame alloc] initWithNibName:@"SMNextGame" bundle:[NSBundle mainBundle]];
	liveGame = [[SMLiveGame alloc] initWithNibName:@"SMLiveGame" bundle:[NSBundle mainBundle]];
	[liveGame setDelegate:self];
	
	[self.view addSubview:[liveGame view]];
	[[liveGame view] removeFromSuperview];
	[self.view addSubview:[nextGame view]];
	
	CGRect frame = CGRectMake(100, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text =  [[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_CONFERENCE_NAME"];
	[self downloadGamesSchedule];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamDidChangeStatus:) name:@"TEAM_STATUS_CHANGED" object:nil];
}

- (void) setAppName:(NSNotification *)notification {	 
	CGRect frame = CGRectMake(100, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text =  [[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_CONFERENCE_NAME"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) downloadGamesSchedule {
	if( gamesConnection != nil ) {
		[gamesConnection cancel];
		[gamesConnection release];
	}
	
//	LoginType loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
//	NSString * loginID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
	
	NSString * followGamesURLString = nil;
	/*switch ( loginType ) {
		case kFacebookLogin:
		//	followGamesURLString = [NSString stringWithFormat:FOLLOW_GAMES_FB,loginID];
			break;
			
		case kScoretoneLogin:
		//	followGamesURLString = [NSString stringWithFormat:FOLLOW_GAMES_EMAIL,loginID];
			break;
	}*/
	
	NSString *lastConferenceSelected = [[NSUserDefaults standardUserDefaults] stringForKey:@"LAST_SELECTED_CONFERENCE"];
	//NSLog(@"TEST :: lastConferenceSelected :: %@", lastConferenceSelected);
	followGamesURLString = [NSString stringWithString:[NSString stringWithFormat:FOLLOW_GAMES_EMAIL,lastConferenceSelected]];
	
	NSLog(@"Games URL :: %@",followGamesURLString);
	NSURL * allGamesURL = [NSURL URLWithString:followGamesURLString];
	NSURLRequest * theRequest = [NSURLRequest requestWithURL:allGamesURL];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicator setCenter:CGPointMake( 160, 200)];
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
	
	dataReceived = [[NSMutableData alloc] init];
	gamesConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void) teamDidChangeStatus:(NSNotification *)notification {
	if( gamesConnection != NULL ) {
		[gamesConnection release];
		gamesConnection = NULL;
	}
	
	[self downloadGamesSchedule];
}

- (void) reloadScheduleData:(NSNotification *)notification {
	if( gamesConnection != NULL ) {
		[gamesConnection release];
		gamesConnection = NULL;
	}
	[self downloadGamesSchedule];
	
}

- (void) createTeamsWithData:(NSData *)xmlData {
	NSString * allTeamsXML = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
	//NSLog(@"all DATA :::::: %@",allTeamsXML);
	allGames = [[NSMutableArray alloc] init];
	
	XMLUtil * xmlUtil = [[XMLUtil alloc] initWithXml:allTeamsXML];
	XMLXpathObject * lc_xpath = [xmlUtil evaluateXpath:[@"/" stringByAppendingString:@"xml"]];
	XMLNode * allTeamsNode = [[lc_xpath nodes] lastObject];
	//XMLNode * node = [[lc_xpath nodes] objectAtIndex:0];
//	NSLog(@"value: %@ last object %@ ",[node value],[allTeamsNode value]);
//	
	NSMutableArray * allTeamsArray = [[NSMutableArray alloc] initWithArray:[allTeamsNode childrenNamed:@"item"]];
	for (XMLNode * node in allTeamsArray ){
		SMGameInfo * gameInfo = [[SMGameInfo alloc] init];
		[gameInfo setMatchID:[[[node childNamed:@"matchID"] value] intValue]];
		[gameInfo setMatchType:[[node childNamed:@"matchType"] value]];
		// for team 1 
		[gameInfo setConf1:[[node childNamed:@"conf1"] value]];
		[gameInfo setSub1:[[node childNamed:@"sub1"] value]];
		[gameInfo setTeam1Name:[[node childNamed:@"team1Name"] value]];
		[gameInfo setTeam1abbr:[[node childNamed:@"team1abbr"] value]];
		[gameInfo setTeam1Flag:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[node childNamed:@"team1abbr"] value]]]];
		//  for team 2 
		[gameInfo setConf2:[[node childNamed:@"conf2"] value]];
		[gameInfo setSub2:[[node childNamed:@"sub2"] value]];
		[gameInfo setTeam2Name:[[node childNamed:@"team2Name"] value]];
		[gameInfo setTeam2abbr:[[node childNamed:@"team2abbr"] value]];
		[gameInfo setTeam2Flag:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[node childNamed:@"team2abbr"] value]]]];
		
		[gameInfo setTime:[[node childNamed:@"time"] value]];		
		//added to convert string 24:20:00 to 00:20:00 
		if([[[[node childNamed:@"time"] value] substringToIndex:2] isEqualToString:@"24"]) {
			[gameInfo setTime:[[gameInfo time] stringByReplacingOccurrencesOfString:@"24" withString:@"00"]];
		}
		
		[gameInfo setScore:[[node childNamed:@"score"] value]];		
		[gameInfo setFinished:[[[node childNamed:@"finished"] value] intValue]];
		[gameInfo setVenue:[[node childNamed:@"venue"] value]];
		
		NSString * dateTimeStr  = [NSString stringWithFormat:@"%@  %@ ",[[node childNamed:@"date"] value],[gameInfo time]];
	//	NSLog(@"DATE IS :: %@", dateTimeStr);
		NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate * date = [dateFormatter dateFromString:dateTimeStr];
		
		[gameInfo setDate:date];
		[dateFormatter release];
		[gameInfo setDateStr:[self getAppropriateTimeZone:dateTimeStr]];
		[allGames addObject:gameInfo];
		[gameInfo release];

	}
	
	[allTeamsArray release];
	[lc_xpath release];
	[xmlUtil release];
	
	if( gamesConnection != NULL ) {
		[gamesConnection release];
		gamesConnection = NULL;
	}
	
	[liveGame.view removeFromSuperview];
	[nextGame.view removeFromSuperview];
	
	if( allGames != NULL ){
		[nextGame showSchedule:allGames];
		[liveGame showSchedule:allGames];
	}

	//NSLog(@"  live games COUNT : %d",[[liveGame liveGames] count]);
	if( [[liveGame liveGames] count] >= 1 ) {		
		[self.view addSubview:[liveGame view]];
	}
	else {
		[self.view addSubview:[nextGame view]];
	}
	//NSLog(@"  ALL GAMES COUNT : %d",[[liveGame liveGames] count]);
	[[liveGame screenScrollView ] setContentSize:CGSizeMake(320.0f,50.0f*[allGames count]+247.0f)] ;
	[[liveGame gamesTableView] setFrame:CGRectMake(0.0f,267.0f,320.0f,50.0f*[allGames count])];
	
	[[nextGame screenScrollViewForNextGameScreen ] setContentSize:CGSizeMake(320.0f,50.0f*[allGames count]+219.0f)] ;
	[[nextGame gamesTableView] setFrame:CGRectMake(0.0f,219.0f,320.0f,50.0f*[allGames count])];
	
	[allGames release];

}
- (NSString *) getAppropriateTimeZone:(NSString *) paramDate {
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	
	//NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
	//[dateFormatter setTimeZone:gmt];
	
	//NSLog(@"PARAM  DATE %@", paramDate);
	NSDate * temp = [dateFormatter dateFromString:/*timeStamp*/paramDate];
	//NSLog(@"TEMP DATE %@", temp);
	[dateFormatter release];
	
	// take current timezone....
	//dateFormatter = [[NSDateFormatter alloc] init];
//	dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss(zzz)";
//	NSString *zone = [[[dateFormatter stringFromDate:[NSDate date]] substringFromIndex:20] substringToIndex:3 ];
//	//NSLog(@"\n ******** current TIMEZONE: %@",zone);
//	[dateFormatter release];
	
	//	
	NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEEE, MMM dd, "];
	NSString * dateTime = [dateFormat stringFromDate:temp];
	[dateFormat release];
	
	NSDateFormatter * timeFormat = [[NSDateFormatter alloc] init];
	//NSTimeZone *gmt1 = [NSTimeZone timeZoneWithAbbreviation:zone];
	//[timeFormat setTimeZone:gmt1];
	[timeFormat setDateFormat:@"hh:mm a"];
	[timeFormat setAMSymbol:@"AM"];
	[timeFormat setPMSymbol:@"PM"];
	dateTime = [dateTime stringByAppendingString:/*[*/[timeFormat stringFromDate:/*[gameInfo date]*/temp]] ;//substringToIndex:13]];
	//dateTime = [dateTime stringByAppendingFormat:@" (%@)",zone];   // removed the timezone.
	[timeFormat release];
	//NSLog(@"final date:%@",dateTime);
	return dateTime;
}
#pragma mark -
#pragma mark SMLiveGamesDelegate
- (void) foundLiveGames {
//	[nextGame.view removeFromSuperview];
//	[self.view addSubview:liveGame.view];
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[dataReceived appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if( gamesConnection != NULL ) {
		[gamesConnection cancel];
		[gamesConnection release];
		gamesConnection = NULL;
	}
	
	if( dataReceived != NULL ) {
		[dataReceived release];
		dataReceived = NULL;
	}
	
	[[[self.view superview] superview] setUserInteractionEnabled:YES];
	if( activityIndicator != NULL ) {
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator = NULL;
	}
	
	UIAlertView * alert = [[UIAlertView alloc] 
						   initWithTitle:NSLocalizedString(@"Could not connect to the internet",@"Could not connect to the internet") 
						   message:NSLocalizedString(@"You must connect to Wi-Fi or cellular data network to access this feature.",@"You must connect to Wi-Fi or cellular data network to access this feature.")
						   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[[[self.view superview] superview] setUserInteractionEnabled:YES];
	if( activityIndicator != NULL ) {
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator = NULL;
	}
	 
	if( dataReceived != NULL ) {
		[self createTeamsWithData:dataReceived];
		[dataReceived release];
		dataReceived = NULL;
	}
	
	[gamesConnection cancel];
	[gamesConnection release];
	gamesConnection = NULL;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SET_INTERACTION" object:nil];		
}


- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	
	if( gamesConnection != nil ) {
		[gamesConnection release];
	}
	
	if( allGames != nil ) {
		[allGames release];
	}

	
	if( dataReceived != nil ) {
		[dataReceived release];
	}
	
	if( liveGame != nil ) {
		[liveGame release];
		liveGame = NULL;
	}
	
	if( nextGame != nil ){
		[nextGame release];
		nextGame = NULL;
	}
	
    [super dealloc];
}


@end
