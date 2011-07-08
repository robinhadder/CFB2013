//
//  SMTauntFriends.h
//  SuperMetric
//
//  Created by codewalla soft on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface SMTauntFriends : UIViewController <MFMailComposeViewControllerDelegate> {
	IBOutlet UITextField * tauntLinkTextField;
	IBOutlet UIButton * emailButton;
	IBOutlet UIButton * tauntMoreButton;
	IBOutlet UILabel * instructionLabel;
	IBOutlet UIButton * playDailyFBlink;
	NSURLConnection *teamsConnection; 
}
@property ( nonatomic, retain ) IBOutlet UITextField * tauntLinkTextField;

- (IBAction) emailTauntLinkButtonAction:(id)sender;
- (IBAction) tauntMoreButtonAction:(id)sender;
- (IBAction) playDailyFBlinkAction:(id)sender;

@end
