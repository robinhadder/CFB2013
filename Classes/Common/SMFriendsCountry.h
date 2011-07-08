//
//  SMFriendsCountry.h
//  SuperMetric
//
//  Created by codewalla soft on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMFBFriendsData.h"

@interface SMFriendsCountry : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UILabel * friendsNamelbl;
	IBOutlet UIPickerView * friendsCountryPicker;
	IBOutlet UIButton* noTeambutton;
	
	NSArray * allTeams;
	SMFBFriendsData * fbFriend;
}
@property (nonatomic, retain) SMFBFriendsData * fbFriend;

- (IBAction) noTeamButtonAction:(id)sender;

@end
