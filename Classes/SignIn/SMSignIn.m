//
//  SMSignIn.m
//  SuperMetric
//
//  Created by mac11 on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMSignIn.h"
#import "SMUserData.h"

@implementation SMSignIn

//@synthesize smTblCell;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(DeleteButtonAction:)];
	[self.navigationItem setLeftBarButtonItem:backButton];	
	[backButton release];
	
	signInTblView.backgroundColor= [UIColor clearColor];
	labelTextArr = [[NSArray alloc]initWithObjects:@"E-mail or User Name",@"Password",nil];
	CGRect frame = CGRectMake(350, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = @"Sign In";
	[subTitleLabel setText:NSLocalizedString(@"ScoreTones account",@"ScoreTones account")];
	[instructionLabel setText:NSLocalizedString(@"Already have a ScoreTones account? You're all set — just sign in here.",@"Already have a ScoreTones account? You're all set — just sign in here.")];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
}
-(IBAction) DeleteButtonAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    SMTblCell *cell = (SMTblCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[SMTblCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell createCellLabel:CGRectMake(9,0,280,35)];
	[cell createCellTextField:CGRectMake(9,35,280,35)];
	[[cell cellTextField] setDelegate:self];
	[[cell cellTextField] setTag:[indexPath row]];
	[cell setLabelText:NSLocalizedString([labelTextArr objectAtIndex:indexPath.row],@"")];
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell cellLabel].font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	
	if(indexPath.row == 0) {
		[cell cellTextField].placeholder = NSLocalizedString(@"example@example.com",@"example@example.com");
		[[cell cellTextField] setKeyboardType:UIKeyboardTypeEmailAddress];
	}
	else {
		[cell cellTextField].placeholder = NSLocalizedString(@"Password",@"Password");
		[cell cellTextField].secureTextEntry = YES;
	}
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0f;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Sign In below";
	}
	return sectionHeader;
}*/

#pragma mark -
#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	SMTblCell * cellEmail = (SMTblCell *)[signInTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	SMTblCell * cellPass = (SMTblCell *)[signInTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	
	NSString * email = [[cellEmail cellTextField] text];
	NSString * pass = [[cellPass cellTextField] text];
	
	if( [email length] != 0 && [pass length] != 0 ){
		[[ SMUserData sharedInstance] verifyUserWithEmail:email andPassword:pass  isSignInByUserName:signInByUserName];  
	}
	NSLog(@"TEST :: entered username ans password " );
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	CGFloat y = 0;
	
	if( [textField tag] == 0 )
		y = 200.0f;
	else if( [textField tag] == 1 ) {
		y = 120.0f;
	}
	
	
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:KeyboardMoveAnimationDuration];
	
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	[self.view setCenter:CGPointMake( self.view.center.x, y)];
	
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if( [textField tag] == 0 ){
		NSString *regExString;
		NSPredicate *textPredicate;	
		
		if(textField.text)
			NSLog(@"emailId:%@",textField.text);
		
		regExString =@"[A-Z0-9a-z._%+-]+[A-Z0-9a-z]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	   
		textPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExString];
		if ([textPredicate evaluateWithObject:textField.text] == NO ) {
		//	[textField setText:@""];
			signInByUserName = TRUE;
			//UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Email" message:@"Please Check your email ID" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			//[alertView show];
			//[alertView release];
		}
		else {
			signInByUserName = FALSE;
		}
		[[NSUserDefaults standardUserDefaults] setBool:signInByUserName forKey:@"singInUserName"];
	}
	
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:KeyboardMoveAnimationDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	[self.view setCenter:CGPointMake( self.view.center.x, 210)];
	
	[UIView commitAnimations];
	
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alertView release];
}


- (void)dealloc {
    [super dealloc];
}


@end

