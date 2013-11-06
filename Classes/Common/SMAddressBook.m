    //
//  SMAddressBook.m
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMAddressBook.h"
#import "SMUserData.h"

@interface SMAddressBook()

- (void) startIconDownload:(SMFBFriendsData *)friendData forIndexPath:(NSIndexPath *)indexPath;
- (void) loadImagesForOnscreenRows;
- (void) appImageDidLoad:(NSIndexPath *)indexPath;
//- (NSMutableDictionary) sortFriendsInAscendingOrder:(NSMutableArray *)allFriends;

@end


@implementation SMAddressBook
@synthesize collation;

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
	
	CGRect frame = CGRectMake(100, 0, 250, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Facebook Friends",@"Facebook Friends");
	
	[self setTitle:@"Address Book Friends"];
	friends = [[NSMutableArray alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddAFriendAtIndex:) name:ADDED_FB_FRIEND object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteAFriendAtIndex:) name:DELETED_FB_FRIEND object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:LOGIN_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedFBFriends:) name:@"DOWNLOADED_FB_FRIENDS" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedFBFriendsImage:) name:@"DOWNLOAD_FRIENDS_IMAGE_COMP" object:nil];
	
	self.collation = [UILocalizedIndexedCollation currentCollation];
	[[SMUserData sharedInstance] loginIntoFaceBook];
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
#pragma mark TabelViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [friends count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.collation sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	int i,j;
	BOOL success = FALSE;
	char searchChar = [title characterAtIndex:0];
	j=0;
	while(!success) {
		searchChar = searchChar + j;
		NSLog(@"search char = %c",searchChar);
		for(i=0;i<[friends count];i++) {
			SMFBFriendsData * friendsData = [friends objectAtIndex:i];	
			if([[friendsData friendsName] characterAtIndex:0] == searchChar)  {
				success = TRUE;
				break ;
			}
		}
		j++;
	}
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* cellIdentifier = @"AddressBookTableCell";
	
	SMFriendsTableCell * cell =  (SMFriendsTableCell *)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
	if( cell == nil ){
		[[NSBundle mainBundle] loadNibNamed:@"SMAddBookTableCell" owner:self options:nil];
		cell = addBookTableCell;
		addBookTableCell = nil;
	}
	
	SMFBFriendsData * friendsData = [friends objectAtIndex:indexPath.row];	
	[[cell friendsName] setText:[friendsData friendsName]];
	[[cell friendsAvatar] setImage:[friendsData friendsImage]];
	/*
	if( [friendsData friendsImage] != NULL ) {
		[[cell friendsAvatar] setImage:[friendsData friendsImage]];
	}
	else {
		[[cell friendsAvatar] setImage:nil];
	}
	 */
	[cell setFriendInfo:friendsData];
	
	if (self.tableView.dragging == NO && self.tableView.decelerating == NO)	{
		[self startIconDownload:friendsData forIndexPath:indexPath];
	}
	
	[cell setBackgroundColor:[UIColor whiteColor]];
	
	return cell;	
}

- (void)requestWasCancelled:(FBRequest*)request {
	NSLog(@"Request requestWasCancelled");
}

#pragma mark -
#pragma mark Table cell image support
- (void)startIconDownload:(SMFBFriendsData *)friendData forIndexPath:(NSIndexPath *)indexPath{
    SMFBFriendsData * fbFriend = [imageDownloadsInProgress objectForKey:indexPath];
    if (fbFriend == NULL) {
		fbFriend = [friends objectAtIndex:indexPath.row];
        [imageDownloadsInProgress setObject:fbFriend forKey:indexPath];
        [fbFriend startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows{
    if ([friends count] > 0){
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths){
			SMFBFriendsData * fbFriend = [friends objectAtIndex:indexPath.row];
            if ([fbFriend friendsImage]==nil){
                [self startIconDownload:fbFriend forIndexPath:indexPath];
            }
        }
    }
}


- (void)appImageDidLoad:(NSIndexPath *)indexPath{
    SMFBFriendsData * fbFriend = [imageDownloadsInProgress objectForKey:indexPath];
    if (fbFriend != nil)  {
        SMFriendsTableCell *cell = (SMFriendsTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [[cell friendsAvatar] setImage:[fbFriend friendsImage]];
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark Notifications
- (void) didLoadImage:(UIImage *)friendsimage forFriend:(SMFBFriendsData *)fbFriend {
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[friends indexOfObject:fbFriend] inSection:0];
	SMFriendsTableCell * fbFriendCell = (SMFriendsTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	[[fbFriendCell friendsAvatar] setImage:friendsimage];
}

- (void) didAddAFriendAtIndex:(NSNotification *)notification {
	NSIndexPath * indexPath = [[notification object] objectForKey:@"DELETE_INDEX_PATH"];
	NSArray * indexPaths = [[NSArray alloc] initWithObjects:indexPath,nil];
	
	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
	
	[indexPath release];
}

- (void) didDeleteAFriendAtIndex:(NSNotification *)notification {	
	NSIndexPath * indexPath = [[notification object] objectForKey:@"SAVE_INDEX_PATH"];
	NSArray * indexPaths = [[NSArray alloc] initWithObjects:indexPath,nil];
	
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
	
	[indexPath release];
}

- (void) downloadedFBFriends:(NSNotification *)notification {
	friends = [[SMUserData sharedInstance] downloadedFBFriends];
	
	NSSortDescriptor * playerSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendsName" ascending:YES];
	NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:playerSortDescriptor,nil];
	[friends sortUsingDescriptors:sortDescriptors];
	[playerSortDescriptor release];
	[sortDescriptors release];
	//NSLog(@"output of sort descriptor: %@",friends);
	//	NSMutableDictionary * sortedFriends = [self sortFriendsInAscendingOrder:friends]; 
	[self.tableView reloadData];
}

- (void) downloadedFBFriendsImage:(NSNotification *)notification {
	SMFBFriendsData * friend = [notification object];
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[friends indexOfObject:friend] inSection:0];
	SMFriendsTableCell * cell = (SMFriendsTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	[[cell friendsAvatar] setImage:[friend friendsImage]];
	/*
	SMFBFriendsData *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.appRecord.appIcon;
    }
	 */
}

#pragma mark -
#pragma mark User Facebook login Notification
- (void) userDidLogin:(NSNotification *)notification {	
	NSDictionary * loginstatus = [notification object];
	LoginType loginType = [[loginstatus objectForKey:LOGIN_TYPE] intValue];
	if( loginType == kFacebookLogin ) {
		BOOL loginStatus = [[loginstatus objectForKey:LOGIN_STATUS] boolValue];
		if( loginStatus == YES) {
			if( loginSuccededOnce == NO ) {//To gurantee object are loaded only once
				if( [[SMUserData sharedInstance] downloadFBFriends] == YES ) {
					friends =  [[SMUserData sharedInstance] downloadedFBFriends];
					[self.tableView reloadData];
				}
				loginSuccededOnce = YES;
			}
		}
		else {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}


- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	friends = NULL;
    [super dealloc];
}


@end
