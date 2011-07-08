//
//  SuperMetricViewController.m
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SuperMetricViewController.h"
#import <MessageUI/MessageUI.h>
#import "NetworkCheck.h"
#import APP_DELEGATE_HEADER

@implementation SuperMetricViewController

@synthesize tabBarController;
@synthesize navigationController;

UIAlertView * signInAlert;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad]; 
	
	pLoadingScreen = [[LoadingScreen alloc] initWithNibName:@"LoadingScreen" bundle:[NSBundle mainBundle]];
	pLoadingScreen.delegate = self;
	[self.view addSubview:pLoadingScreen.view];
}

- (void) loadingScreenTapped 
{
	[pLoadingScreen.view removeFromSuperview];
	[pLoadingScreen release];
	pLoadingScreen = nil;

	//SCNetworkReachabilityRef rechability = SCNetworkReachabilityCreateWithName( NULL, [@"http://api.scoretones.com/index.php" UTF8String]);
	
	BOOL isNetworkAvailable = [[NetworkCheck sharedInstance] isNetworkAvailable];	
	BOOL initialLogin = [[NSUserDefaults standardUserDefaults] boolForKey:INITAL_LOGIN];
	//BOOL isConferenceSelected = [[NSUserDefaults standardUserDefaults] boolForKey:IS_CONFERENCE_SELECTED];
	NSLog(@"TEST ::initialLogin ::%d ",initialLogin);
	if( initialLogin == NO || isNetworkAvailable == NO ){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:LOGIN_NOTIFICATION object:nil];
		
		conferenceObj = [[SMConferences alloc]initWithNibName:@"SMConferences" bundle:[NSBundle mainBundle]];
		[conferenceObj setIsConferenceCalledfromSettings:FALSE];
		navigationController = [[UINavigationController alloc] initWithRootViewController:conferenceObj];		
		
			
		[self.view addSubview:[navigationController view]];
		[[navigationController view] setCenter:CGPointMake( 160, 220)];
	}
	else {	
		
		signInByUserName = [[NSUserDefaults standardUserDefaults] boolForKey:@"singInUserName"];
		[self.view addSubview:[[self tabBarController] view]];
		[[[self tabBarController] view] setCenter:CGPointMake( 160, 220)];
		tabBarController.delegate = self;
	}
}

- (UITabBarController*)tabBarController {
	if( tabBarController == nil ) {
		[[NSBundle mainBundle] loadNibNamed:@"SMTabBar" owner:self options:nil];
	}
	return tabBarController;
}

- (void) tauntFriendsWithTaunt:(NSString *)tauntMessage; {
	if( tabBarController != nil ) {
		if( [tabBarController selectedIndex] != 2 ) {
			[tabBarController setSelectedIndex:2];
			[tabBarController showTauntMessage:tauntMessage];
		}
	}
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) siginInDidComplete:(SMSignIn *)inObject {
	
}

- (void) userDidLogin:(NSNotification *)notification {
	NSDictionary * dict = [notification object];
	LoginType loginType = [[dict objectForKey:LOGIN_TYPE] intValue];
	BOOL loginStatus = [[dict objectForKey:LOGIN_STATUS] boolValue];
	
	if( loginStatus == YES ) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:INITAL_LOGIN];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:loginType] forKey:LOGIN_TYPE];
		NSString * addDeviceURL = NULL;
		NSString * confID = NULL;
		switch ( loginType) {
			case kFacebookLogin:
				[[NSUserDefaults standardUserDefaults] setObject:[[SMUserData sharedInstance] uid] forKey:LOGIN_ID];
				[[SMUserData sharedInstance] addFacebookUser:[[SMUserData sharedInstance] uid]];
				//confID = [[ConfigureApp sharedConfig]conferenceID];				
				addDeviceURL = [NSString stringWithString:ADD_DEVICE_BY_FB];
				break;
				
			case kScoretoneLogin:
				[[NSUserDefaults standardUserDefaults] setObject:[[SMUserData sharedInstance] getScoreTonesEmail] forKey:LOGIN_ID];
				//confID = [[ConfigureApp sharedConfig]conferenceID];
				addDeviceURL = [NSString stringWithString:ADD_DEVICE_BY_EMAIL];
				break;
		}
		
		confID = [[ConfigureApp sharedConfig]conferenceID];
		NSLog(@"DEV TEST :: confID  %@", confID);
		APP_DELEGATE * appObj = (APP_DELEGATE *)[[UIApplication sharedApplication] delegate];
		NSString * deviceToken = [appObj deviceToken];
		NSLog(@"DEV TEST :: device token %@", deviceToken);
		if( deviceToken != NULL ){
			NSString * loginID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
			//NSString * addDeviceToken = [NSString stringWithFormat:addDeviceURL,loginID,deviceToken,confID];
			NSString * addDeviceToken = [NSString stringWithFormat:addDeviceURL,loginID,deviceToken,confID];
			NSLog(@"TO Add device :: %@",addDeviceToken);
			NSURL * url = [NSURL URLWithString:addDeviceToken];
			NSURLRequest * request = [NSURLRequest requestWithURL:url];
			NSData * receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
			NSString * tokenOp = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
			NSLog(@"%@",tokenOp);
		}
		
		if( tabBarController != nil  )
			return;
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:IF_RETURN_USER];
		[scoreTones.view removeFromSuperview];
		[scoreTones release];
		scoreTones = nil;
		
		[navigationController.view removeFromSuperview];
		[navigationController release];
		navigationController = nil;
		
		
		[self.view addSubview:[[self tabBarController] view]];
		[[[self tabBarController] view] setCenter:CGPointMake( 160, 220)];
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		
		[tabBarController setDelegate:self];
		
	}
	/*
	else {
		if( loginType == kFacebookLogin ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to login to the Facebook" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
	}
	 */
}

- (void)dealloc {
	if( tabBarController != nil ) {
		[tabBarController.view removeFromSuperview];
		[tabBarController release];
	}
	
	if( scoreTones != nil ) {
		[scoreTones.view removeFromSuperview];
		[scoreTones release];
	}
	
    [super dealloc];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{	
	if( alertView == signInAlert ) {
		[tabBarController.view removeFromSuperview];
		[tabBarController release];
		tabBarController = NULL;
		
		[[SMTeamsManager sharedInstance] clearData];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:LOGIN_NOTIFICATION object:nil];
		
		scoreTones = [[SMScoreTones alloc]initWithNibName:@"SMScoreTones" bundle:[NSBundle mainBundle]];
		navigationController = [[UINavigationController alloc] initWithRootViewController:scoreTones];
		[self.view addSubview:[navigationController view]];
		[[navigationController view] setCenter:CGPointMake( 160, 220)];
		
		[signInAlert release];
	}
}
/*
#pragma mark -
#pragma mark UITabBarController
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	BOOL initialLogin = [[NSUserDefaults standardUserDefaults] boolForKey:INITAL_LOGIN];
	if( initialLogin == NO ) {
		int selectedIndex = [tabBarController selectedIndex];
		if( selectedIndex == 0  || selectedIndex == 1 ) {
			signInAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please sign in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[signInAlert show];
		}
	}
}
 */


@end
