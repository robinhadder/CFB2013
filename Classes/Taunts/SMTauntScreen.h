//
//  SMTauntScreen.h
//  SuperMetric
//
//  Created by Rakesh Patole on 23/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTauntMyFriends.h"

@interface SMTauntScreen : UIViewController {
	IBOutlet UITextView * tauntTextView;
	IBOutlet SMTauntMyFriends * tauntMyFriends;
	IBOutlet UIBarButtonItem * selectFriendsButton;
	IBOutlet UIBarButtonItem * cancelButton;
}

@property (nonatomic, retain) IBOutlet UITextView * tauntTextView;

- (void) selectFriendsButtonAction:(id)sender;
- (void) cancelButtonAction:(id)sender;


@end
