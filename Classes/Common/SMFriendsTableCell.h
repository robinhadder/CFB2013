//
//  SMFriendsTableCell.h
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "SMUserData.h"
#import "SMFBFriendsData.h"

@interface SMFriendsTableCell : UITableViewCell {
	IBOutlet UIImageView * friendsAvatar;
	IBOutlet UILabel * friendsName;
	IBOutlet UILabel * countryLiked;
	
	IBOutlet UIButton * selectDeselectButton;
	
	NSString * uid;
	SMFBFriendsData * friendInfo;
}
@property (nonatomic, retain) IBOutlet UIImageView * friendsAvatar;
@property (nonatomic, retain) IBOutlet UILabel * friendsName;
@property (nonatomic, retain) IBOutlet UILabel * countryLiked;
@property (nonatomic, retain) SMFBFriendsData * friendInfo;
@property (nonatomic, retain)IBOutlet UIButton *selectDeselectButton;

- (void) setFriendsData:(SMFBFriendsData *)friendsData;
- (IBAction) selectDeselectFriendButtonAction:(id)sender;
- (IBAction) addFriendButtonAction:(id)sender;
- (IBAction) removeFriendButtonAction:(id)sender;


@end
