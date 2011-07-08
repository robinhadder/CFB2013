//
//  SMAddressBook.h
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "SMFriendsTableCell.h"
#import "SMUserData.h"


@interface SMAddressBook : UITableViewController <UIScrollViewDelegate> {
	IBOutlet SMFriendsTableCell * addBookTableCell;
	NSMutableArray * friends;
	NSMutableDictionary *imageDownloadsInProgress;
	UILocalizedIndexedCollation *collation;
	BOOL loginSuccededOnce; 
}
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

@end
