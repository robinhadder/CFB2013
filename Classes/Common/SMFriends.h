//
//  SMFriends.h
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMFriendsTableCell.h"
#import "SMAddFriendsTableCell.h"
#import "SMFriendsCountry.h"
#import "SMAddressBook.h"

@interface SMFriends : UIViewController <UITableViewDelegate,UITableViewDataSource/*,SMUserFBFriendsDelegate*/> {
	IBOutlet UITableView * tabelView;
	IBOutlet SMFriendsTableCell * friendsTableCell;
	IBOutlet SMAddFriendsTableCell* addFriendsTableCell;
	
	
	IBOutlet UILabel* addMoreFriendsLabel;
	
	SMAddressBook * addressBook;
	SMFriendsCountry * friendsCountry;
	NSArray * savedFriends;
	
	BOOL loginDidSuccedOnce;
}

- (IBAction) addFaceBookFriendsButtonAction:(id)sender;

@end
