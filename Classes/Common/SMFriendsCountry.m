//
//  SMFriendsCountry.m
//  SuperMetric
//
//  Created by codewalla soft on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMFriendsCountry.h"
#import "SMTeamsManager.h"
#import "SMTeamsInfo.h"

@implementation SMFriendsCountry

@synthesize fbFriend;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/



- (void)viewDidLoad {
    [super viewDidLoad];
	CGRect frame = CGRectMake(200, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	label.text = @"SCORETONES";
	self.navigationItem.titleView = label;
	
	[noTeambutton setTitle:NSLocalizedString(@"No team",@"No team") forState:UIControlStateNormal];
	
	allTeams = [[SMTeamsManager sharedInstance] getAllTeams];
	if( fbFriend != nil ) {
		[friendsNamelbl setText:[NSString stringWithFormat:@"%@'s %@",[fbFriend friendsName],NSLocalizedString(@"team",@"team")]];
	}
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Button Action
- (IBAction) noTeamButtonAction:(id)sender {
	if(fbFriend!=nil){
		[fbFriend setCountryLikedByFriend:@""];
	}
	
	
	
	[self .navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark -
#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [allTeams count];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	CGRect frame = CGRectZero;
	frame.size = [pickerView rowSizeForComponent:component];
	view = [[UIView alloc] initWithFrame:frame];
	
	UILabel * countryLbl = [[UILabel alloc] initWithFrame:CGRectMake( 70, frame.origin.y, frame.size.width -100, frame.size.height)];
	
		[countryLbl setText:[[allTeams objectAtIndex:row] nameEN]];
	
	
	
	[countryLbl setBackgroundColor:[UIColor clearColor]];
	
	UIImageView * countryflag = [[UIImageView alloc] initWithFrame:CGRectMake( frame.origin.x + 10, frame.origin.y, frame.size.height, frame.size.height)];
	[countryflag setImage:[[allTeams objectAtIndex:row] teamFlag]];
	
	[view addSubview:countryflag];
	[view addSubview:countryLbl];
	
	[countryLbl release];
	[countryflag release];
	return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if( fbFriend != nil && [allTeams count] > row) {
		//[fbFriend setCountryLiked:[[allTeams objectAtIndex:row] abr]];
		[fbFriend setCountryLikedByFriend:[[allTeams objectAtIndex:row] abr]];
	}
}


- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	if( allTeams != nil ) {
		[allTeams release];
	}
    [super dealloc];
}


@end

