//
//  Settings.h
//  SuperMetric
//
//  Created by mac11 on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSignIn.h"
#import "SMTblCell.h"
#import "SMFriends.h"
#import "SMTeams.h"
#import "SMConferences.h"

@interface Settings : UIViewController <UITableViewDelegate,UITableViewDataSource>{
	IBOutlet UITableView *settingsTblView;
	NSMutableArray * sectionArray1;
	NSMutableArray * sectionArray12;
	NSArray * sectionArray2;
}


- (IBAction) emailMyTauntsAction:(id)sender;
- (IBAction) soundNotificationOnOffAction:(id)sender;
- (IBAction) startUpSoundOnOffAction:(id)sender;

- (id)readPlist:(NSString *)fileName getvalueForKey:(NSString *)key;

@end
