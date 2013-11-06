//
//  SMScoreTones.m
//  SuperMetric
//
//  Created by mac11 on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMScoreTones.h"
#import "SMUserData.h"
#import "NetworkCheck.h"
#import "SuperMetricViewController.h"

@implementation SMScoreTones

@synthesize tableView;
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppNameWithCurrentSelectedConf:) name:@"SET_APP_NAME" object:nil];
	[[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
	
	[welcomeLabel setText:NSLocalizedString(@"Welcome",@"Welcome")];
	[instructionLabel setText:NSLocalizedString(@"Before you get started, please set up an account or sign in below.",@"Before you get started, please set up an account or sign in below.")];
	
	
	[tableView setBackgroundColor:[UIColor clearColor]];
	
	contentArray1 = [[NSArray arrayWithObjects:@"Create ScoreTones account", nil] retain];
	contentArray2 = [[NSArray arrayWithObjects:@"With Facebook account", nil] retain];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) setAppNameWithCurrentSelectedConf:(NSNotification *)notification {
	self.navigationItem.title = [[ConfigureApp sharedConfig] conferenceName];                        // set app name according to the conference selected.
	//self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"LAST_SELECTED_CONFERENCE"];
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
    int returnValue = 0;
    
    returnValue = [contentArray2 count];
	
	return returnValue;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
    
    
    cell.textLabel.text = NSLocalizedString([contentArray2 objectAtIndex:indexPath.row],@"ScoreTones");
	
	
	cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if( [[NetworkCheck sharedInstance] isNetworkAvailable] == NO) {
		return;
	}
	
    if(indexPath.row == 0) {
        [[SMUserData sharedInstance] loginIntoFaceBook];
    } else {
        
       	NSMutableDictionary * loginDict = [[NSMutableDictionary alloc] init];
        [loginDict setObject:[NSNumber numberWithBool:YES] forKey:LOGIN_STATUS];
        [loginDict setObject:[NSNumber numberWithInt:kScoretoneGuest] forKey:LOGIN_TYPE];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:loginDict];
        [loginDict release];
        
    }
	
	
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = NSLocalizedString(@"Sign Up",@"Sign Up");
	}
	if(section == 1) {
		sectionHeader = NSLocalizedString(@"Sign In",@"Sign In");
	}
	
	return sectionHeader;
}

- (void)dealloc {
	[contentArray1 release];
	[contentArray2 release];
	[super dealloc];
}


@end

