    //
//  SMFriends.m
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMFriends.h"


@implementation SMFriends
- (void)viewDidLoad {
    [super viewDidLoad];
	
//	[[SMUserData sharedInstance] addFbFriendDelegate:self];
	savedFriends = [[SMUserData sharedInstance] getSavedFBFriends];
	if( savedFriends == nil )
		savedFriends = [[NSMutableArray alloc] init];
	
	[tabelView setBackgroundColor:[UIColor clearColor]];
	
	CGRect frame = CGRectMake(100, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = @"My Friends";
	
	[addMoreFriendsLabel setText:@"Add more friends"];
	//[self setTitle:@"My Friends"];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddAFriendAtIndex:) name:ADDED_FB_FRIEND object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteAFriendAtIndex:) name:DELETED_FB_FRIEND object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectFriendsCountry:) name:FRIENDS_COUNTRY_SELECTED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:LOGIN_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark TabelViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rowCount;
	//if(!section)
	if (section == 1) 
		rowCount = [savedFriends count];
	else
		rowCount = 1;
	return rowCount;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSString* strSectionHeader;
	if(section == 1){
		strSectionHeader = NSLocalizedString(@"Edit Friends",@"Edit Friends");
	}
	else {
		strSectionHeader = NSLocalizedString(@"Import from Facebook",@"Import from Facebook");
	}
	return strSectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 1) {
		static NSString *  cellIdentifier1 = @"FriendsTableCell";
		SMFriendsTableCell* cell =  (SMFriendsTableCell*)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier1];
		if( cell == nil ){
			[[NSBundle mainBundle] loadNibNamed:@"SMFriendsTableCell" owner:self options:nil];
			cell = friendsTableCell;
			friendsTableCell = nil;
		}
		[cell setFriendsData:[savedFriends objectAtIndex:indexPath.row]];
		if( [[savedFriends objectAtIndex:indexPath.row] countryLiked] == @"" ){
			[[cell countryLiked] setText:@"Select"];
		}
		return cell;
	}
	else {
		static NSString *  cellIdentifier2 = @"AddFriendsTableCell";
		SMAddFriendsTableCell* cell = (SMAddFriendsTableCell*)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier2];
		if(cell == nil ){
			[[NSBundle mainBundle] loadNibNamed:@"SMAddFriendsTableCell" owner:self options:nil];
			cell =addFriendsTableCell;
			addFriendsTableCell = nil;
		}
		[[cell addMoreFriendsLabel] setText:NSLocalizedString(@"Add more friends",@"Add more friends")];
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([indexPath section]) {
		case 1:
			friendsCountry = [[SMFriendsCountry alloc] initWithNibName:@"SMFriendsCountry" bundle:[NSBundle mainBundle]];
			[friendsCountry setFbFriend:[savedFriends objectAtIndex:[indexPath row]]];
			[self.navigationController pushViewController:friendsCountry animated:YES];
			[friendsCountry release];
			break;
			
		case 0:
			addressBook = [[SMAddressBook alloc] initWithNibName:@"SMAddressBook" bundle:[NSBundle mainBundle]];
			[[self navigationController] pushViewController:addressBook animated:YES];
			[addressBook release];
			break;
	}  

}

#pragma mark -
#pragma mark SMUserFBFriendsDelegate
- (void) didAddAFriendAtIndex:(NSNotification *)notification {
	NSArray * savedFriendst = [[SMUserData sharedInstance] getSavedFBFriends];
	if( [savedFriends count] == [savedFriendst count] - 1 ) {	
		savedFriends = savedFriendst;
		NSIndexPath * indexPath = [[notification object] objectForKey:@"SAVE_INDEX_PATH"];
		NSArray * indexpaths = [[NSArray alloc] initWithObjects:indexPath,nil];
		
		[tabelView beginUpdates];
		[tabelView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationFade];
		[tabelView endUpdates];
		
		[indexpaths release];
	}
	else {
		savedFriends = savedFriendst;
		[tabelView reloadData];
	}
}

- (void) didDeleteAFriendAtIndex:(NSNotification *)notification {
	NSArray * savedFriendst = [[SMUserData sharedInstance] getSavedFBFriends];
	if( [savedFriendst count] == [savedFriends count] -1 ) {
		savedFriends = savedFriendst;
		NSIndexPath * indexPath = [[notification object] objectForKey:@"DELETE_INDEX_PATH"];
		NSArray * indexpaths = [[NSArray alloc] initWithObjects:indexPath,nil];
		
		[tabelView beginUpdates];
		[tabelView deleteRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationFade];
		[tabelView endUpdates];
		
		[indexpaths release];
	}
	else {
		savedFriends = savedFriendst;
		[tabelView reloadData];
	}
}

- (void) didSelectFriendsCountry:(NSNotification *)notification {
	SMFBFriendsData * friend = (SMFBFriendsData *)[notification object];
	SMFriendsTableCell * upFriendsTableCell = (SMFriendsTableCell *)
	[tabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[savedFriends indexOfObject:friend] inSection:1]];
	
	[[upFriendsTableCell countryLiked] setText:[friend countryLiked]];
}

- (void) userDidLogin:(NSNotification *)notification {
	NSDictionary * loginstatus = [notification object];
	LoginType loginType = [[loginstatus objectForKey:LOGIN_TYPE] intValue];
	if( loginType == kFacebookLogin ) {
		BOOL loginStatus = [[loginstatus objectForKey:LOGIN_STATUS] boolValue];				
		if( loginStatus == YES ) {
			if( loginDidSuccedOnce == NO ) {
				savedFriends = [[SMUserData sharedInstance] getSavedFBFriends] ;
				[tabelView reloadData];
				loginDidSuccedOnce = YES;
			}
		}
		else {			
			loginDidSuccedOnce = NO;
			savedFriends = [[NSArray alloc] init];
			[tabelView reloadData];
		}
	}
}

#pragma mark -
#pragma mark Button Actions
- (IBAction) addFaceBookFriendsButtonAction:(id)sender {
	addressBook = [[SMAddressBook alloc] initWithNibName:@"SMAddressBook" bundle:[NSBundle mainBundle]];
	addressBook.collation = [UILocalizedIndexedCollation currentCollation];
	[[self navigationController] pushViewController:addressBook animated:YES];
	[addressBook release];
}


- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}


@end
