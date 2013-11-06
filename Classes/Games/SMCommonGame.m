    //
//  SMCommonGame.m
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMCommonGame.h"


@implementation SMCommonGame

@synthesize allGames;
@synthesize gamesTableView;
@synthesize team1Flag;
@synthesize team2Flag;
@synthesize team1Name;
@synthesize team2Name;
@synthesize venue;
@synthesize date;
@synthesize time;

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
#pragma mark Public Functions
- (void) showDetailedGame:(SMGameInfo *)gameInfo {
	[[self team1Flag] setImage:[gameInfo team1Flag]];
	[[self team2Flag] setImage:[gameInfo team2Flag]];
	[[self team1Name] setText:[gameInfo team1Name]];
	[[self team2Name] setText:[gameInfo team2Name]];
	[[self venue] setText:[gameInfo venue]];
	[[self time] setText:[gameInfo dateStr]];
//
	}

- (void) showSchedule:(NSArray *)inAllGames {
	[self setAllGames:inAllGames];
	[gamesTableView reloadData];
}

#pragma mark -
#pragma mark TabelViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [allGames count];
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* cellIdentifier = @"GamesTablesCell";	
	
	SMGameTableViewCell * cell = (SMGameTableViewCell *)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
	if( cell == nil ){
		[[NSBundle mainBundle] loadNibNamed:@"SMGamesTableCell" owner:self options:nil];
		cell = gameTableCell;
		gameTableCell = nil;
	}
	
	SMGameInfo * gameInfo = [allGames objectAtIndex:indexPath.row];
	NSString *gameText = [NSString stringWithFormat:@"%@ - %@", [gameInfo team1Name],[gameInfo team2Name]];   // combined both te team data in a single label.
	[[cell team1Name] setText:gameText];
	//[[cell team1Name] setText:[gameInfo team1Name]];
	//[[cell team2Name] setText:[gameInfo team2Name]];
	[[cell team1Flag] setImage:[gameInfo team1Flag]];
	[[cell team2Flag] setImage:[gameInfo team2Flag]];

	[cell setBackgroundColor:[UIColor whiteColor]];
	//NSDate * date1 = [gameInfo date];
//	NSDateFormatter * datetimeFormatter = [[NSDateFormatter alloc] init];
//	[datetimeFormatter setDateFormat:@"MM/dd, hh:mm a"];
//	NSString * datetimeStr = [datetimeFormatter stringFromDate:date1];
//	
	NSString * venueStr = ([gameInfo venue]!=NULL) ? ([gameInfo venue]) : (@"");
	NSString * venueAndTime = [NSString stringWithFormat:@"%@, %@",[gameInfo dateStr],venueStr];       // comma immediately after the time for the game.
	[[cell gameVenueDateTime] setText:venueAndTime];
	//[datetimeFormatter release];
	[cell setBackgroundColor:[UIColor whiteColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	
 	return cell;	
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.bounds.size.width, 30)] autorelease];
	UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SectionalHeader.png"]] autorelease];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0,tableView.bounds.size.width, 30)] autorelease];
	label.text = @"Schedule";
	[label setTextAlignment:NSTextAlignmentCenter];
	label.textColor = [UIColor whiteColor];
	[label setBackgroundColor:[UIColor clearColor]];
	[headerView addSubview:imageView];
	[headerView addSubview:label];
	return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Schedule";
}

- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	if( allGames != nil ){
		[allGames release];
	}
    [super dealloc];
}


@end
