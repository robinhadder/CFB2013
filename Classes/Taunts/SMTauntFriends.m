    //
//  SMTauntFriends.m
//  SuperMetric
//
//  Created by codewalla soft on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "SMTauntFriends.h"
#import "SMUserData.h"

@implementation SMTauntFriends

@synthesize tauntLinkTextField;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CGRect frame = CGRectMake(200, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Taunt",@"Taunt");
	
	[instructionLabel setText:@"Use this link to send people to your personal taunt page on the ScoreTones website."];
	[tauntMoreButton setTitle:NSLocalizedString(@"Taunt More",@"Taunt More") forState:UIControlStateNormal];
	[emailButton setTitle:NSLocalizedString(@"Email link",@"Email link") forState:UIControlStateNormal];	
	
	int scoreTonewTauntDisplayText = [[NSUserDefaults standardUserDefaults]  integerForKey:@"UserID"];
	NSLog(@"user id at link page:%d",scoreTonewTauntDisplayText);
	NSString * urlString = [@"http://scoretones.com/users/" stringByAppendingFormat:@"%d",scoreTonewTauntDisplayText];
	NSString *scoreTonesEmailID = [[NSUserDefaults standardUserDefaults]  objectForKey:LOGIN_ID];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"singInUserName"] == 1) {
		urlString = [@"http://scoretones.com/users/" stringByAppendingString:scoreTonesEmailID];
		
	}
	[tauntLinkTextField setText:urlString];
	
	
	if( scoreTonesEmailID != nil ) {
		[emailButton setEnabled:YES];
		[tauntLinkTextField setEnabled:YES];
  }
	else {
		[tauntLinkTextField setEnabled:NO];
		[emailButton setEnabled:NO];
	}

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Button Action
- (IBAction) emailTauntLinkButtonAction:(id)sender {
	NSString * scoreTonesEmailID = [[SMUserData sharedInstance] getScoreTonesEmail];
	if( scoreTonesEmailID == nil ) {
		return;
	}
		
		
	NSString * scoreTonesEmailId = [[SMUserData sharedInstance] getScoreTonesEmail];
	MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc] init];
	NSArray * toRecipients = [[NSArray alloc] initWithObjects:scoreTonesEmailId,nil];
	[mailComposer setToRecipients:toRecipients];
	[mailComposer setSubject:@"Taunt Link"];
	[mailComposer setMessageBody:[tauntLinkTextField text] isHTML:NO];
	[mailComposer setMailComposeDelegate:self];
	[self presentModalViewController:mailComposer animated:YES];
	
	[toRecipients release];
}

- (IBAction) tauntMoreButtonAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) playDailyFBlinkAction:(id)sender{
	NSLog(@"TEST :: PLAY DAILY LINK ");
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://apps.facebook.com/dailyballs/"]];
}

#pragma mark -
#pragma mark UIMailComposerViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissModalViewControllerAnimated:YES];
	if( error != nil ) {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
    [super dealloc];
}


@end
