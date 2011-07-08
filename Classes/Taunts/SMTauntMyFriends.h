//
//  SMTauntMyFriends.h
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "SMTauntFriends.h"
#import "SMAddressBook.h"
#import "SMFriends.h"
#import "SMUserData.h"
#import "SMFriendsTableCell.h"
#import "SMAddFriendsTableCell.h"
#import "FBConnect.h"

@interface SMTauntMyFriends : UIViewController <FBRequestDelegate,FBDialogDelegate, MFMailComposeViewControllerDelegate, UINavigationBarDelegate>{
	IBOutlet UITextView* tauntTextView;
	IBOutlet UITableView * smtableView;
	
	IBOutlet SMFriendsTableCell * tauntMyfriTableCell;
	IBOutlet SMAddFriendsTableCell * tauntAddMyFriTableCell;
	
	
	IBOutlet UIButton * autoAppendLink;
	IBOutlet UIButton * hitThemButton;
	IBOutlet UIButton * editButton; 
	
	IBOutlet UILabel* automaticLinkLabel;
	IBOutlet UILabel* tauntAddMoreFriendsLabel;
	
	SMTauntFriends * tauntFriends;
	SMFriends * friends;
	SMAddressBook * addressBook;
	
	FBRequest * fbRequest;
	
	bool autoAppend;
	
	int requestCount;
	int userID;
	
	NSArray * savedFriends;
	BOOL loginDidSuccedOnce;
	BOOL isUserIDURL;
	NSURLConnection * postConnection;
	NSURLConnection * teamsConnection;
	NSMutableData * dataReceived;

}
@property (nonatomic, retain) IBOutlet UITextView * tauntTextView;

- (int)createUserDetailsWithDataReceived:(NSString *)receivedData;
- (void) postMessageToFriendsWall;
- (void) checkUploadPermission;
- (void) getUserIDForCurrentUser;
- (IBAction) giveItToThemButtonAction:(id)sender;
- (IBAction) addFriendsButtonAction:(id)sender;
- (IBAction) editFriendListButtonAction:(id)sender;
- (IBAction) txtViewReturnClicked:(id)sender;
- (IBAction) autoAppendButtonAction:(id)sender;
- (IBAction) cancelButtonAction:(id)sender;

@end
