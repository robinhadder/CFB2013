//
//  SMQuietTime.m
//  SuperMetric
//
//  Created by mac11 on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMQuietTime.h"


@implementation SMQuietTime

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

	[quietTimeTblView setBackgroundColor:[UIColor whiteColor]];
	
	lblArray = [[NSArray alloc]initWithObjects:@"Badge updates only!",
				@"Enabled",
				@"From",
				@"To",
				nil];
	
	CGRect frame = CGRectMake(0, 0, 400, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = @"Quiet Time";
	[[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
	
	//[timePicker selectRow:1 inComponent:0 animated:NO];
	
	//timePicker.frame = CGRectMake(0,200,320,198);
	
	hoursArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",
				  @"8",@"9",@"10",@"11",@"12",nil];
	minArray = [[NSArray alloc]initWithObjects:@"00",@"15",@"30",@"45",nil];
	amPmArray = [[NSArray alloc]initWithObjects:@"AM",@"PM",nil];
	
	pickerValue = [[NSMutableString alloc]init];
	toFlag = NO;
	fromFlag = NO;
	
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:nil action:nil]autorelease];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    SMTblCell *cell = (SMTblCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[SMTblCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	switch (indexPath.row) {
		case 0:
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			[cell setLabelText:[lblArray objectAtIndex:0]];
			//[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			[cell cellLabel].textAlignment = UITextAlignmentCenter;
			[cell cellLabel].textColor = [UIColor grayColor];
			break;
			
		case 1:
			[cell createCellLabel:CGRectMake(9,6,193,32)];
			[cell setLabelText:[lblArray objectAtIndex:1]];
			[cell createCellSwitch:CGRectMake(200,8,94,27)];
			break;
			
		case 2:
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			[cell setLabelText:[lblArray objectAtIndex:2]];
			[cell createCellLabel:CGRectMake(200,6,94,32)];
			//[cell setLabelText:@""];
			
			if(toFlag == YES && ([cell cellLabel].text == nil)){
				//pickerValue = @"";
				[cell setLabelText:pickerValue];
				[pickerValue setString:@""];
				toFlag = NO;
			}
			
			break;
		
		case 3:
			[cell createCellLabel:CGRectMake(9,6,280,32)];
			[cell setLabelText:[lblArray objectAtIndex:3]];
			[cell createCellLabel:CGRectMake(200,6,94,32)];
			//[cell setLabelText:@""];
			
			if(fromFlag == YES && ([cell cellLabel].text == nil)){
				//pickerValue = @"";
				[cell setLabelText:pickerValue];
				[pickerValue setString:@""];
				fromFlag = NO;
			}
			break;
			
	}
	
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	
	//[cell createCellTextField:CGRectMake(101,6,194,31)];
	//[cell setLabelText:[labelTextArr objectAtIndex:indexPath.row]];
	
    return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	if(indexPath.row == 2)
		toFlag = YES;
	if(indexPath.row == 3)
		fromFlag = YES;
	[quietTimeTblView reloadData];
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

#pragma mark ---- UIPickerViewDataSource delegate methods ----
	 
// returns the number of columns to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
		return 3;
}
	 
// returns the number of rows
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
		//return [timePickerArray count];
	if(component == 0)
		return 12;
	else if(component == 1)
		return 4;
	else
		return 2;
}
/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if(component == 0)
		return [hoursArray objectAtIndex:row];
	else if(component == 1)
		return [minArray objectAtIndex:row];
	else 
		return [amPmArray objectAtIndex:row];
}*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	//NSMutableString *str;// = [[NSMutableString alloc]init];
	if(component == 0)
		[pickerValue appendString:[hoursArray objectAtIndex:row]];
	if(component == 1)
		[pickerValue appendString:[minArray objectAtIndex:row]];
	if(component == 2)
		[pickerValue appendString:[amPmArray objectAtIndex:row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
		return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
    UILabel *retval = view;
	
    if (!retval) {
		
        retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 44.0)] autorelease];
    }
	
	if(component == 0){
		retval.text = [NSString stringWithFormat:@"%@", [hoursArray objectAtIndex:row]];
		retval.textAlignment = UITextAlignmentRight;
	}
	else if(component == 1){
		retval.text = [NSString stringWithFormat:@"%@", [minArray objectAtIndex:row]];
		retval.textAlignment = UITextAlignmentCenter;
	}
	else {
		retval.text = [NSString stringWithFormat:@"%@", [amPmArray objectAtIndex:row]];
		retval.textAlignment = UITextAlignmentCenter;
	}
	[retval setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];

	return retval;
	
}


- (void)dealloc {
    [super dealloc];
}


@end

