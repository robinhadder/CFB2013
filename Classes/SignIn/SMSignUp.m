//
//  SMSignUp.m
//  SuperMetric
//
//  Created by mac11 on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMSignUp.h"
#import "SMUserData.h"


@implementation SMSignUp
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(DeleteButtonAction:)];
	[self.navigationItem setLeftBarButtonItem:backButton];	
	[backButton release];
	
	signUpTblView.backgroundColor= [UIColor clearColor];
	
	lblTextArray = [[NSArray alloc] initWithObjects:@"E-mail",@"User Name",@"Password",@"Password confirm",nil];
	
	CGRect frame = CGRectMake(100, 0, 100, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:18.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Sign Up",@"Sign Up");
	[self.navigationItem.backBarButtonItem setTitle:@"text###"];
	
	[instructionLabel setText:NSLocalizedString(@"Don't have a ScoreTones account yet? You can create one right here.",@"Don't have a ScoreTones account yet? You can create one right here.")];
	
	
	
}
-(IBAction) DeleteButtonAction:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
	[cell setLabelText:NSLocalizedString([lblTextArray objectAtIndex:indexPath.row],@"")];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	[cell cellLabel].font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	
	if(indexPath.row == 0) {
		[cell cellTextField].placeholder = NSLocalizedString(@"example@example.com",@"example@example.com");
		[[cell cellTextField] setKeyboardType:UIKeyboardTypeEmailAddress];
	}
	else if (indexPath.row ==1){
		[cell cellTextField].placeholder = NSLocalizedString(@"user name",@"user name");
		[[cell cellTextField] setKeyboardType:UIKeyboardTypeEmailAddress];		
	}
	else if(indexPath.row == 2){
		[cell cellTextField].placeholder = NSLocalizedString(@"Password",@"Password");
		[cell cellTextField].secureTextEntry = YES;
	}
	else {
		[cell cellTextField].placeholder = NSLocalizedString(@"password confirm",@"password confirm");
		[cell cellTextField].secureTextEntry = YES;
	}	
	
	
	if( [indexPath row] > 0 ){
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.0f;
}


#pragma mark -
#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	SMTblCell * cellEmail  = (SMTblCell *)[signUpTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	SMTblCell * cellUserId = (SMTblCell *)[signUpTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	SMTblCell * cellPass   = (SMTblCell *)[signUpTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	SMTblCell * cellPassConfirm = (SMTblCell *)[signUpTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	
	NSString * email  = [[cellEmail cellTextField] text];
	NSString * userId = [[cellUserId cellTextField] text]; 
	NSString * pass = [[cellPass cellTextField] text];
	NSString * passconfirm = [[cellPassConfirm cellTextField] text];
	
	if( [email length] != 0 && [userId length] != 0 &&[pass length] != 0 && [passconfirm length] != 0 ){
		if( [passconfirm isEqualToString:pass] == NO ) {
			[[cellPassConfirm cellTextField] setText:@""];
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Password" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
		else {
			[[SMUserData sharedInstance] loginIntoScoreWithEmail:email scoretoneUserName:userId andPassword:pass];
		}
	}
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	CGFloat y = 0;
	
	if( [textField tag] == 0 ) {
		y = 200.0f;
	}
	else if( [textField tag] == 1 ) {
		y = 160.0f;
	}
	else if( [textField tag] == 2) {
		y = 100.0f;
	} 
	else {
		y = 20.0f;
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
			//[textField setText:@""];
		/*	emailAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Email" message:@"Please Check your email ID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[emailAlert show];
			[emailAlert release];*/
			signInByUserName = TRUE;
				
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
#pragma mark UIViewAnimationDelegate
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
}

//#pragma mark -
//#pragma mark UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	[alertView release];
//}


- (void)dealloc {
    [super dealloc];
}


@end

