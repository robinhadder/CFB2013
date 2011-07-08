//
//  SuperMetricViewController.h
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTabbarController.h"
#import "SMUserData.h"
#import "SMSignIn.h"
#import "SMScoreTones.h"
#import "LoadingScreen.h"

@interface SuperMetricViewController : UIViewController <LoadingScreenDelegate, UIAlertViewDelegate, UITabBarControllerDelegate> {
	IBOutlet SMTabbarController * tabBarController;
	SMSignIn * navigationController;
	SMScoreTones *scoreTones;
	SMConferences *conferenceObj;
	LoadingScreen *pLoadingScreen;
}
@property (nonatomic, retain) SMSignIn * navigationController;
@property (nonatomic, retain) UITabBarController * tabBarController;

- (UITabBarController *)tabBarController;
- (void) tauntFriendsWithTaunt:(NSString *)tauntMessage;

@end

