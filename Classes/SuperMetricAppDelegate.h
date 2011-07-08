//
//  SuperMetricAppDelegate.h
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundManager.h"


@class SuperMetricViewController;

@interface SuperMetricAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
	SuperMetricViewController *viewController;
	UIWindow *window;
	NSString *deviceToken;
	NSString * tauntMessage;
	NSOperationQueue *operationQueue;          // for managing multiple request in a queue

	SoundManager * soundManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SuperMetricViewController *viewController;
@property (nonatomic, retain) NSString *deviceToken;

-(void) showReviewPopUpMessage;

/**
 *	Method: addTagsAction
 *	Description: add tags to urban air ship server
 *	Parameters: array tags to be addes
 *	Returns: none
 */
-(void) addTagsAction:(NSArray *)tags ;

/**
 *	Method: assignTagsToDevicetoken
 *	Description: the method will be used for adding tags to a particuler device token
 *	Parameters: _devicetoken
 alias
 tags
 *	Returns: none
 */
- (void)assignTagsToDevicetoken:(NSString *)_devicetoken withDeviceAlias:(NSString *)alias withDeviceTags:(NSArray *)tags;

/**
 *	Method: registerDeviceToken
 *	Description: method will be used to registring device token on Urban Airship
 *	Parameters: _devicetoken
 *	Returns: none
 */
- (void)registerDeviceToken:(NSString *)_devicetoken;



@end

