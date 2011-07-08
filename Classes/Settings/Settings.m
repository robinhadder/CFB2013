//
//  Settings.m
//  SuperMetric
//
//  Created by mac11 on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"


@implementation Settings


UIAlertView * facebookAlert;
UIAlertView * scoreTonesAlert;

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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:LOGIN_NOTIFICATION object:nil];
	
	CGRect frame = CGRectMake(100, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Settings",@"Settings");
	[self setTitle:NSLocalizedString(@"Settings",@"Settings")];
	
	sectionArray1 = [[NSMutableArray alloc]initWithObjects:@"My Conference",@"My Team",@"Log out from ScoreTones",nil];
	sectionArray12 = [[NSMutableArray alloc]initWithObjects:@"My Friends",@"Log out from Facebook",nil];
	
	sectionArray2 = [[NSArray alloc] initWithObjects:@"Play start-up sound",@"Notify me with sound",@"Email me my taunts",nil];

	[settingsTblView setBackgroundColor:[UIColor clearColor]];
	[[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"keyisStartUpSoundOn" ] != nil) {
		[[NSUserDefaults standardUserDefaults] setBool:[standardUserDefaults boolForKey:@"keyisStartUpSoundOn"] forKey:@"keyisStartUpSoundOn"];
	}
	else{
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"keyisStartUpSoundOn"];
	}
	
	if([[NSUserDefaults standardUserDefaults] objectForKey:@"notifyWithSoundButton" ] != nil) {
		[[NSUserDefaults standardUserDefaults] setBool:[standardUserDefaults boolForKey:@"notifyWithSoundButton"] forKey:@"notifyWithSoundButton"];
	}
	else{
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"notifyWithSoundButton"];
	}
	
	if([[NSUserDefaults standardUserDefaults] objectForKey:SEND_TAUNT_MESSAGE ] != nil) {
		[[NSUserDefaults standardUserDefaults] setBool:[standardUserDefaults boolForKey:SEND_TAUNT_MESSAGE] forKey:SEND_TAUNT_MESSAGE];
	}
	else{
		[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:SEND_TAUNT_MESSAGE];
	}
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
    return 5;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int totalRows = 1;
	
    if(section == 0) {
		totalRows = 3;
	}

	if(section == 1) {
		totalRows = 2;
	}
	
	return totalRows;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier1 = @"CellSec1";
	static NSString * cellIdentifier2 = @"CellSec2";
	static NSString * cellIdentifier3 = @"CellSec3";
	static NSString * cellIdentifier4 = @"CellSec4";
	static NSString * cellIdentifier5 = @"CellSec5";
	
	SMTblCell *cell = nil;
	LoginType initialLoginType;
	BOOL isLoggedIn;
	switch ([indexPath section]) {
		case 0:
			cell  = (SMTblCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
			if (cell == nil) {
				cell = [[[SMTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1] autorelease];
			}
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			NSString * cellText = [sectionArray1 objectAtIndex:[indexPath row]];
			[cell setLabelText:NSLocalizedString(cellText,@"")];
			
			[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
			//if( [indexPath row] == 1 && [[SMUserData sharedInstance] getScoreTonesEmail] == NULL ) {
//				[[cell cellLabel] setTextColor:[UIColor grayColor]];
//				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//			}
			
			//if( [indexPath row] == 2 && [[SMUserData sharedInstance] fbSession].isConnected == NO){
//				[[cell cellLabel] setTextColor:[UIColor grayColor]];
//				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//			}
			
			if( [indexPath row] == 2 && [[SMUserData sharedInstance] getScoreTonesEmail] == NULL){
					[[cell cellLabel] setTextColor:[UIColor grayColor]];
			    	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
				   // notifyWithSoundButton = [[NSUserDefaults standardUserDefaults ] boolForKey: @"notifyWithSoundButton"];     
				    //[[NSUserDefaults standardUserDefaults ] setBool:notifyWithSoundButton forKey:@"notifyWithSoundButton" ]; 
				}
			
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			break;
			
		case 1:
			cell  = (SMTblCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
			if (cell == nil) {
				cell = [[[SMTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2] autorelease];
			}
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			NSString * cellText1 = [sectionArray12 objectAtIndex:[indexPath row]];
			[cell setLabelText:NSLocalizedString(cellText1,@"")];
			
			//[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
			//if( [indexPath row] == 1 && [[SMUserData sharedInstance] getScoreTonesEmail] == NULL ) {
//				[[cell cellLabel] setTextColor:[UIColor grayColor]];
//				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//			}
			
			if( [indexPath row] == 1 && [[SMUserData sharedInstance] fbSession].isConnected == NO){
				[[cell cellLabel] setTextColor:[UIColor grayColor]];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
				
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			break;
			
		case 2:
			cell  = (SMTblCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
			if (cell == nil) {
				cell = [[[SMTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3] autorelease];
			}
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			[cell createCellLabel:CGRectMake(9,6,193,32)];
			[cell setLabelText:NSLocalizedString([sectionArray2 objectAtIndex:[indexPath row]],@"")];
			[cell createCellSwitch:CGRectMake(200,8,94,27)];
			[[cell cellOnOffSwitch] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"keyisStartUpSoundOn"]];
				
			[[cell cellOnOffSwitch] addTarget:self action:@selector(startUpSoundOnOffAction:) forControlEvents:UIControlEventValueChanged];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			break;
			
		case 3:
			initialLoginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
			isLoggedIn = [[[NSUserDefaults standardUserDefaults] objectForKey:INITAL_LOGIN] boolValue];
			cell  = (SMTblCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
			if (cell == nil) {
				cell = [[[SMTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier4] autorelease];
			}
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			[cell setLabelText:NSLocalizedString([sectionArray2 objectAtIndex:1],@"")];
			[cell createCellSwitch:CGRectMake(200,8,94,27)];
			//BOOL startUpSoundOnOff = [[NSUserDefaults standardUserDefaults] boolForKey:SEND_TAUNT_MESSAGE];
			
			[[cell cellOnOffSwitch] setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"notifyWithSoundButton"]];
			
		//	[[cell cellOnOffSwitch] setOn:startUpSoundOnOff];
			[[cell cellOnOffSwitch] addTarget:self action:@selector(soundNotificationOnOffAction:) forControlEvents:UIControlEventValueChanged];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
			if( initialLoginType == kFacebookLogin || initialLoginType == kNoLogin || isLoggedIn == NO ) {
				[[cell cellLabel] setTextColor:[UIColor grayColor]];
				[[cell cellOnOffSwitch] setEnabled:NO];
			}
			break;			
			
		case 4:
			initialLoginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
			isLoggedIn = [[[NSUserDefaults standardUserDefaults] objectForKey:INITAL_LOGIN] boolValue];
			cell  = (SMTblCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier5];
			if (cell == nil) {
				cell = [[[SMTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier5] autorelease];
			}
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			[cell setLabelText:NSLocalizedString([sectionArray2 objectAtIndex:2],@"")];
			[cell createCellSwitch:CGRectMake(200,8,94,27)];
			BOOL emailMeMyTauntsOnOff = [[NSUserDefaults standardUserDefaults] boolForKey:SEND_TAUNT_MESSAGE];
			[[cell cellOnOffSwitch] setOn:emailMeMyTauntsOnOff];
			[[cell cellOnOffSwitch] addTarget:self action:@selector(emailMyTauntsAction:) forControlEvents:UIControlEventValueChanged];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
			if( initialLoginType == kFacebookLogin || initialLoginType == kNoLogin || isLoggedIn == NO ) {
				[[cell cellLabel] setTextColor:[UIColor grayColor]];
				[[cell cellOnOffSwitch] setEnabled:NO];
			}
			break;
		
	}
	
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:5];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	switch (section) {
		case 0:
			sectionHeader = @"";
			break;
		case 1:
			sectionHeader = @"";
			break;
		case 2:
			sectionHeader = @"";
			break;

		case 3:
			sectionHeader = NSLocalizedString(@"Push Notifications",@"Push Notifications");
			break;
		case 4:
			sectionHeader = NSLocalizedString(@"Email Notifications",@"Email Notifications");
			break;
			
	}
	return sectionHeader;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0){
		NSString * scoreTonesEmail = [[SMUserData sharedInstance] getScoreTonesEmail];
		SMTeams * objSMTeams = nil;
		SMConferences * objSMConferences = nil;
	
		switch ([indexPath row]) {
			case 0:
				
				objSMConferences =[[SMConferences alloc] initWithNibName:@"SMConferences" bundle:[NSBundle mainBundle]];
				[objSMConferences setIsConferenceCalledfromSettings:YES];
				[self.navigationController pushViewController:objSMConferences animated:YES];
				[objSMConferences release];
				break;
							
			case 1:
				[[SMTeamsManager sharedInstance] setAllGroups : nil]; 
				objSMTeams =[[SMTeams alloc] initWithNibName:@"SMTeams" bundle:[NSBundle mainBundle]];
				[self.navigationController pushViewController:objSMTeams animated:YES];
				[objSMTeams release];
				break;
				
			case 2:
				if( scoreTonesEmail != NULL ) {
					scoreTonesAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log out from Scoretones",@"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") otherButtonTitles:NSLocalizedString(@"OK",@""),nil];
					[scoreTonesAlert show];
				}
				break;
		}
		
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
	if(indexPath.section == 1){
		SMFriends* objSMFriends = nil;
		
		switch ([indexPath row]) {
			case 0:
				objSMFriends = [[SMFriends alloc] initWithNibName:@"SMFriends" bundle:[NSBundle mainBundle]];
				[self.navigationController pushViewController:objSMFriends animated:YES];
				[objSMFriends release];
				break;
				
			case 1:
				if([[SMUserData sharedInstance] fbSession].isConnected){
					facebookAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log out from Facebook",@"") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") otherButtonTitles:NSLocalizedString(@"OK",@""),nil];
					[facebookAlert show];
				}
				break;
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

#pragma mark -
#pragma mark Button Actions
- (IBAction) emailMyTauntsAction:(id)sender {
	NSLog(@"dev test ::  emailMyTauntsAction");	
	LoginType initialLoginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
	if( initialLoginType == kScoretoneLogin ) {
		UISwitch * onoffswitch = (UISwitch *)sender;
		BOOL  value = [onoffswitch isOn];
		[[NSUserDefaults standardUserDefaults] setBool:value forKey:SEND_TAUNT_MESSAGE];
	}
}

- (IBAction) soundNotificationOnOffAction:(id)sender {
	NSLog(@"dev test ::  soundNotificationOnOffAction");
	UISwitch * onoffswitch = (UISwitch *)sender;
	BOOL  value = [onoffswitch isOn];
	NSLog(@"Sound Button IS :: %d", value);
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:@"notifyWithSoundButton"];
	if( value == YES ) {
		[[UIApplication sharedApplication] 
		 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge) ];
	}
	else {
		[[UIApplication sharedApplication] 
		 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge) ];
	}

}

- (IBAction) startUpSoundOnOffAction:(id)sender{
	NSLog(@"dev test ::  startUpSoundOnOffAction");
	UISwitch * onoffswitch = (UISwitch *)sender;
	BOOL  value = [onoffswitch isOn];
	NSLog(@"dev test  BUtton IS :: %d", value);
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:@"keyisStartUpSoundOn"];
	if( value == YES ) {
		[[UIApplication sharedApplication] 
		 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge) ];
	}
	else {
		[[UIApplication sharedApplication] 
		 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge) ];
	}
}


#pragma mark readingPlist
- (id)readPlist:(NSString *)fileName getvalueForKey:(NSString *)key {  
	NSData *plistData;  
	NSString *error;  
	NSPropertyListFormat format;  
	id plist;  
	
	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];  
	plistData = [NSData dataWithContentsOfFile:localizedPath];   
	
	id returnValue = nil;
	
	plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
	if( plist != nil ){
		returnValue = [plist valueForKey:key];
	}
	
	return returnValue;  
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if( alertView == scoreTonesAlert ) {
		if( buttonIndex == 1 ){
			[[SMUserData sharedInstance] logoutFrom:kScoretoneLogin];
		}
	}
	else {
		if( alertView == facebookAlert ) {
			if( buttonIndex == 1 ){
				[[SMUserData sharedInstance] logoutFrom:kFacebookLogin];
			}
		}
	}
}

- (void) userDidLogin:(NSNotification *)notification {	
	[settingsTblView reloadData];
}

- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end

