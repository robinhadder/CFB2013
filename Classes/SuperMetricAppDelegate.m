//
//  SuperMetricAppDelegate.m
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SuperMetricAppDelegate.h"
#import "SuperMetricViewController.h"
#import "SMUserData.h"
#import "SMTeamsManager.h"

#import "ASIHTTPRequest.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "Reachability.h"
#import "ConfigureApp.h"

static NSString *requestURL = @"https://go.urbanairship.com/api/device_tokens/";

@implementation SuperMetricAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize deviceToken;


- (void) applicationDidFinishLaunching:(UIApplication *)application {	
			
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTagsFromUA:) name:@"REMOVE_TAGS" object:nil];
	
	// Uncomment the below code for olaf's wishlist 2i.e forshowing a pop up when theapp is a launched for the 10th time   
//	if( [[NSUserDefaults standardUserDefaults] integerForKey:NO_OF_LOGIN] == 0 ){
//		[[NSUserDefaults standardUserDefaults ] setInteger:1 forKey:NO_OF_LOGIN];
//	}
//	else{
//		int updatedCount = [[NSUserDefaults standardUserDefaults] integerForKey:NO_OF_LOGIN];
//		updatedCount++;
//		[[NSUserDefaults standardUserDefaults ] setInteger:updatedCount forKey:NO_OF_LOGIN];
//	}
//	
//	if ([[NSUserDefaults standardUserDefaults] integerForKey:NO_OF_LOGIN] == 10) {
//		[self showReviewPopUpMessage];
//	}
	
	//BOOL isStartUpSoundOn;
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"keyisStartUpSoundOn"] != nil) {
		isStartUpSoundOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"keyisStartUpSoundOn"]; 
	}
	else {
		isStartUpSoundOn = TRUE;
	}

	if(isStartUpSoundOn == TRUE){
		[[SoundManager sharedInstance] playSound:@"misc_timeforcollegefoot.aif"  delay:0.1];
	}


	operationQueue = [[NSOperationQueue alloc] init];
	
	[[UIApplication sharedApplication] 
	 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) ];
	
	[window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

//-(void) showReviewPopUpMessage{
//
//	UIAlertView * reviewAlert = [[UIAlertView alloc]initWithTitle:@"Review App" message:@"Please take a minute and review this app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
//	[reviewAlert show];
//	[reviewAlert release];
//}

- (void) applicationWillTerminate:(UIApplication *)application {
}

//The delegate receives this message after the registerForRemoteNotificationTypes: method of UIApplication is invoked and there is no error in the registration process.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken {
	
	NSLog(@"Registration Succeeded :: %@",_deviceToken);	
	
	// generate device token
	self.deviceToken = [[[[_deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] 
						 stringByReplacingOccurrencesOfString:@">" withString:@""] 
						stringByReplacingOccurrencesOfString: @" " withString: @""];
	[self registerDeviceToken:self.deviceToken];
}	

//Sent to the delegate when Apple Push Service cannot successfully complete the registration process.
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
	NSLog(@"Registration Failed %@", [error description]);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"remote notification: %@",userInfo);
	/*
	if( soundManager != NULL && [[soundManager ptrAVAudioPlayer] isPlaying] == YES ) {
		NSString * fileName = [soundManager strFileName];
		if( fileName != NULL ) {
			if( fileName != @"es_end.wav" || fileName != @"es_uhoh.wav" ||  fileName != @"en_end.wav" || fileName != @"en_uhoh.wav" ){
				return;
			}
		}
	}*/
	 
   
	NSDictionary *tempDictionary = [userInfo objectForKey:@"aps"];
	NSLog(@"Aps :: %@",tempDictionary);
	
	NSString * soundFile = [tempDictionary objectForKey:@"sound"];
	[soundManager playSound:soundFile delay:0.1f];
	
//	NSString * alertMsg = [tempDictionary objectForKey:@"alert"];
//	
//	if( tauntMessage != nil )
//		[tauntMessage release];
//	
//	
//	tauntMessage = [[NSString alloc] initWithString:[tempDictionary objectForKey:@"taunt"]];
//	 
//	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ScoreTones" message:alertMsg delegate:self cancelButtonTitle:NSLocalizedString(@"Taunt",@"Taunt") otherButtonTitles:NSLocalizedString(@"Cancel",@"Cancel"),nil];
//    [alert show];
//    [alert release];
//    
}

- (void) removeTagsFromUA:(NSNotification *)notification {
	NSArray *noneTag = [[NSArray alloc] initWithObjects:@"None",nil ]; 
	//[ self addTagsAction :[[NSArray alloc ] initWithObjects:@"None", nil ] ];
	[ self addTagsAction: noneTag];
	[ noneTag release];
}


/**
 *	Method: addTagsAction
 *	Description: action method call on button click
 *	Parameters: none
 *	Returns: none
 */
-(void) addTagsAction:(NSArray *)tags {
	NSLog(@"tags :: %@",tags);
	NSArray *tagsArray = [[NSArray alloc]initWithArray:tags];
	NSLog(@"tagsArray :: %@",tagsArray);
	[self assignTagsToDevicetoken:self.deviceToken withDeviceAlias:nil withDeviceTags:tagsArray];
	[tagsArray release];
}

/**
 *	Method: registerDeviceToken
 *	Description: method will be used to registring device token on Urban Airship
 *	Parameters: _devicetoken
 *	Returns: none
 */
- (void)registerDeviceToken:(NSString *)_devicetoken
{
	NSString *urlString = [NSString stringWithFormat:@"%@%@", requestURL, _devicetoken];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = @"PUT";
	request.username = kApplicationKey;
	request.password = kApplicationSecret;

	[request setDelegate:self];
	[request setDidFinishSelector:@selector(saTokenSucceeded:)];
	[request setDidFailSelector:@selector(saTokenFailed:)];
	
	// Process request using an NSOperationQueue 
	[operationQueue addOperation:request];
	
}

/**
 *	Method: assignTagsToDevicetoken
 *	Description: the method will be used for adding tags to a particuler device token
 *	Parameters: _devicetoken
 alias
 tags
 *	Returns: none
 */

- (void)assignTagsToDevicetoken:(NSString *)_devicetoken withDeviceAlias:(NSString *)alias withDeviceTags:(NSArray *)tags {
	
	/* Build the ASIHTTPRequest */
	NSString *urlString = [NSString stringWithFormat:@"%@%@", requestURL, _devicetoken];
	NSURL *url = [NSURL URLWithString:urlString];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = @"PUT";
	request.username = kApplicationKey;
	request.password = kApplicationSecret;
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(saTokenSucceeded:)];
	[request setDidFailSelector:@selector(saTokenFailed:)];
	
	// Append JSON Payload if alias or tags specified 
	if ((alias != nil && [alias	length] != 0) ||
		(tags != nil && [tags count] != 0)) {
		
		NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithCapacity:2];
		
		if (alias != nil && [alias	length] != 0) {
			[jsonDict setObject:nil forKey:@"alias"];
		}
		
		if (tags != nil && [tags count] != 0) {
			[jsonDict setObject:tags forKey:@"tags"];
		}
		
		NSLog(@"Token %@", [[CJSONSerializer serializer] serializeDictionary:jsonDict]);
		[request addRequestHeader: @"Content-Type" value: @"application/json"];
		[request appendPostData:
		 [[[CJSONSerializer serializer] serializeDictionary:jsonDict] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	// Process request using an NSOperationQueue 
	[operationQueue addOperation:request];
	
}

- (void)saTokenSucceeded:(ASIHTTPRequest *)request; {
	NSLog(@"Token Succeeded");
}


- (void)saTokenFailed:(ASIHTTPRequest *)request; {
	if ([[request error] code] == ASIRequestCancelledErrorType) {
		NSLog(@"Token Canceled");	
	}
	else {
		NSLog(@"Token Failed");	
	}	
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//	if( buttonIndex == 0 && tauntMessage != nil) {
//		[viewController tauntFriendsWithTaunt:tauntMessage];
//	}
//}
/*


#pragma mark -
#pragma mark SoundManagerDelegate
- (void)soundManager:(SoundManager *)SoundManager didBeginPlaying:(NSString *)fileName {
}

- (void)soundManager:(SoundManager *)SoundManager didFinishPlaying:(NSString *)fileName{
}
 */

- (void)dealloc {
	[operationQueue release];
    [window release];
	[deviceToken release];   
	[super dealloc];
}


@end
