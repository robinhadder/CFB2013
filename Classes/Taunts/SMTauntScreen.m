//
//  SMTauntScreen.m
//  SuperMetric
//
//  Created by Rakesh Patole on 23/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMTauntScreen.h"
#import "SMUserData.h"

@implementation SMTauntScreen

@synthesize tauntTextView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
	
	[[SMUserData sharedInstance] loginIntoFaceBook];
	NSLog(@"DVE TEST %d",[[self.navigationController  viewControllers] count]);
	
	CGRect frame = CGRectMake(200, 0, 130, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Taunt",@"Taunt");
	
	[self setTitle:NSLocalizedString(@"Taunt",@"Taunt")];
	
	
	[selectFriendsButton setTitle:NSLocalizedString(@"Select Friends",@"Select Friends")];
	[cancelButton setTitle:NSLocalizedString(@"Cancel",@"Cancel")];
	
	[tauntTextView becomeFirstResponder];
	[tauntTextView setText:@""];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void) selectFriendsButtonAction:(id)sender {
	tauntMyFriends = [[SMTauntMyFriends alloc] initWithNibName:@"SMTauntMyFriends" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:tauntMyFriends animated:YES];
	[[tauntMyFriends tauntTextView] setText:[tauntTextView text]];
	NSLog(@"TauntScreen Text: %@ tauntMyFriends: %@",[tauntTextView text],[[tauntMyFriends tauntTextView] text]);
	[tauntMyFriends release];
}

- (void) cancelButtonAction:(id)sender{
	[tauntTextView setText:@""];
	[self.tabBarController setSelectedIndex:0];
}


- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
    [super dealloc];
}


@end
