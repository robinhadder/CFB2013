//
//  SMTblCell.m
//  SuperMetric
//
//  Created by mac11 on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMTblCell.h"


@implementation SMTblCell

@synthesize cellLabel;
@synthesize cellTextField;
@synthesize cellOnOffSwitch;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
	}
	
	return self;
}
 */

#pragma mark SubView Creation methods

-(void) createCellLabel:(CGRect) frame{

	//cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(9,6,84,31)];
	cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)];
	[cellLabel setTextColor:[UIColor blackColor]];
	[cellLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
	[self.contentView addSubview:cellLabel];
}


-(void) createCellTextField:(CGRect) frame{
	
	cellTextField = [[UITextField alloc]initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)];
	[cellTextField setBorderStyle:UITextBorderStyleRoundedRect];
	//textFieldRounded.placeholder = @"<enter text>";  //place holder
	[cellTextField setBackgroundColor:[UIColor whiteColor]]; //background color
	//textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	[cellTextField setKeyboardType:UIKeyboardTypeDefault];  // type of the keyboard
	[cellTextField setReturnKeyType:UIReturnKeyDone];  // type of the return key
	
	[cellTextField setClearButtonMode:UITextFieldViewModeWhileEditing];	// has a clear 'x' button to the right
	[cellTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	cellTextField.delegate = self;
	
	[self.contentView addSubview:cellTextField];
}

-(void) createCellSwitch:(CGRect) frame {
	
	cellOnOffSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)];
	[cellOnOffSwitch setOn:YES];

	[self.contentView addSubview:cellOnOffSwitch];
}


#pragma mark setValues to SubViews

- (void)setLabelText:(NSString *)text;{
	[cellLabel setText:text];
}

- (void)dealloc {
    [super dealloc];
	[cellLabel release];
	[cellTextField release];
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
/*
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
*/
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
    return 0;
}


// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    // Set up the cell...
//	
//    return cell;
//}

//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here. Create and push another view controller.
//	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
//	// [self.navigationController pushViewController:anotherViewController];
//	// [anotherViewController release];
//}


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



@end

