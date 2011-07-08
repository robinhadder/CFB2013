//
//  SMFriendsTableCell.m
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMFriendsTableCell.h"


@implementation SMFriendsTableCell

@synthesize friendsAvatar;
@synthesize friendsName;
@synthesize countryLiked;
@synthesize friendInfo;
@synthesize selectDeselectButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
}

- (void) setFriendsData:(SMFBFriendsData *)inFriendsData {
	if( friendInfo != NULL )
		[friendInfo release];
	
	friendInfo = [inFriendsData retain];
	[friendsName setText:[friendInfo friendsName]];
	[countryLiked setText:[friendInfo countryLiked]];
	
	if( [friendInfo isSelected] ) {
		[friendsName setTextColor:[UIColor blackColor]];
		[selectDeselectButton setImage:[UIImage imageNamed:@"tickSelected.png"] forState:UIControlStateNormal];
	}
	else {
		[friendsName setTextColor:[UIColor grayColor]];
		[selectDeselectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	}

}

#pragma mark -
#pragma mark Button Actions
- (IBAction) selectDeselectFriendButtonAction:(id)sender {
/*	UIButton * button = (UIButton *)sender;
	if( [friendInfo isSelected] ) {
		[friendInfo setIsSelected:NO];
		[button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	}
	else {
		[friendInfo setIsSelected:YES];
		[button setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateNormal];
	}
*/
	 
}

- (IBAction) addFriendButtonAction:(id)sender {
	[[SMUserData sharedInstance] saveFriend:friendInfo];
}

- (IBAction) removeFriendButtonAction:(id)sender {
	[[SMUserData sharedInstance] deleteFriend:friendInfo];
}



- (void)dealloc {
	if( friendsAvatar != NULL ) {
		[friendsAvatar removeFromSuperview];
		[friendsAvatar release];
	}
	
	if( friendsName != NULL ) {
		[friendsName removeFromSuperview];
		[friendsName release];
	}
	
	if( countryLiked != NULL ) {
		[countryLiked removeFromSuperview];
		[countryLiked release];
	}
	
	if( selectDeselectButton != NULL ) {
		[selectDeselectButton removeFromSuperview];
		[selectDeselectButton release];
	}
	
	if( uid != NULL ){
		[uid release];
	}
	
	if( friendInfo != NULL ){
		[friendInfo release];
	}
    [super dealloc];
}


@end
