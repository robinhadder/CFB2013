//
//  SMStandings.m
//  SuperMetric
//
//  Created by Macmini-11 on 04/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMStandings.h"
#import "SMTeamsManager.h"
#import "SMAllTeamManager.h"
#import "SMAllStandingsManager.h"

@implementation SMStandings

- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStandingsData:) name:@"RELOAD_STANDINGS_DATA" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadTeamData:) name:DOWNLOADED_TEAMS_DATA object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadAllTeamData:) name:@"DOWNLOADED_ALL_TEAMS_DATA" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadingTeamsDataCompleted:) name:@"DOWNLODING_TEAMS_DATA_ENDED" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadingTeamsDataStarted:) name:@"DOWNLODING_TEAMS_DATA_STARTED" object:nil];
	
	[[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
	CGRect frame = CGRectMake(100, 0, 100, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Standings",@"Standings");
	
	items = [[NSArray alloc] initWithObjects:@"Conference",@"Overall",nil] ;
	segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
	segmentedControl.frame = CGRectMake(10, 5, 304, 30);
	
	[segmentedControl setImage:[UIImage imageNamed:@"Conference_Normal.png"]forSegmentAtIndex:0];
	[segmentedControl setImage:[UIImage imageNamed:@"Overall_OnPress.png"]forSegmentAtIndex:1];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.selectedSegmentIndex =0;
	[segmentedControl addTarget:self
	action:@selector(pickOne:)
	forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:segmentedControl];
	//[segmentedControl release];
	[self pickOne : segmentedControl];

	//allKeys = [[SMTeamsManager sharedInstance] allKeys];
	//allGroups = [[SMAllStandingsManager sharedInstance] getTeamsStandingsAccordingToConference];
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) didDownloadTeamData:(NSNotification *)notification {
	allGroups = [[SMAllStandingsManager sharedInstance] getTeamsStandingsAccordingToConference];
	[self pickOne: segmentedControl];
}
- (void) didDownloadAllTeamData:(NSNotification *)notification {
	allGroups1 = [[SMAllTeamManager sharedInstance] getAllTeamsForAllConferences];
	allConferenceTeams = [self getArrayFromDict:allGroups1];
	[self pickOne: segmentedControl];
}

- (void) downloadingTeamsDataStarted:(NSNotification *)notification {
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicator setCenter:CGPointMake( 160, 200)];
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
}

- (void) downloadingTeamsDataCompleted:(NSNotification *)notification {
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	[activityIndicator release];
	activityIndicator = NULL;
}


#pragma mark -
#pragma mark TabelViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
	if (allGroups!= NULL) {
	  return [[allGroups allKeys] count];		
	}
	else{
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray * array = [allGroups allKeys];
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
	NSLog(@"NO OF ROWS IN SECTION #%d : %d", section, [[allGroups objectForKey:[reversedArray objectAtIndex:section]] count]);	
	return [[allGroups objectForKey:[reversedArray objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* cellIdentifier = @"TeamsInfoCell";	
	
	SMStandingsTableViewCell * cell = (SMStandingsTableViewCell *)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
	if( cell == nil ){
		[[NSBundle mainBundle] loadNibNamed:@"SMStandingsTableViewCell" owner:self options:nil];
		cell = standingsTableCell;
		standingsTableCell = nil;
	}
	SMTeamsInfo * teamInfo;
		NSMutableArray * teamsInGroup = [allGroups objectForKey:[allKeys objectAtIndex:indexPath.section]];
	    NSLog(@"TEAMS IN GROUP OF SECTION %d %@ :: %d", indexPath.section, teamsInGroup, indexPath.row);
		teamInfo = [teamsInGroup objectAtIndex:indexPath.row];

	[[cell teamName] setText:[teamInfo nameEN]];
	[[cell teamFlag] setImage:[teamInfo teamFlag]];
	NSString * str;
	if([segmentedControl selectedSegmentIndex] == 0) {               // for conference tab wonconf - lostconf  combination is used 
		str= [NSString stringWithFormat:@"%@",[teamInfo wonconf]];
		str = [str stringByAppendingString:@"-"];
		str = [str stringByAppendingFormat:@"%@",[teamInfo lostconf]];
	}else {                                                          // for overall tab wonconf - lostconf  combination is used 
		str= [NSString stringWithFormat:@"%@",[teamInfo wonall]];
		str = [str stringByAppendingString:@"-"];
		str = [str stringByAppendingFormat:@"%@",[teamInfo lostall]];
	}

	[[cell currentStanding ]setText:str];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(![[allKeys objectAtIndex:0] isEqualToString:@"noSubDiv"]) {
		return [allKeys objectAtIndex:section];
	}
	else {
		return @"";
	}
}


- (void) reloadStandingsData:(NSNotification *)notification {
	[[SMAllStandingsManager sharedInstance] setAllGroups:nil];
	[[SMAllTeamManager sharedInstance ] setAllGroups:nil];
	[segmentedControl setSelectedSegmentIndex:0];
	[self pickOne : segmentedControl];
	
}

- (void) pickOne:(id)sender{
	NSLog(@"PIK ONE ");
	UISegmentedControl *segmentedControl1 = (UISegmentedControl *)sender;
	if([segmentedControl1 selectedSegmentIndex] == 0) {
		[segmentedControl setImage:[UIImage imageNamed:@"Conference_Normal.png"]forSegmentAtIndex:0];
		[segmentedControl setImage:[UIImage imageNamed:@"Overall_OnPress.png"]forSegmentAtIndex:1];
		allKeys = [[SMAllStandingsManager sharedInstance] allKeys];
		allGroups = [[SMAllStandingsManager sharedInstance] getTeamsStandingsAccordingToConference];
		if (allGroups!= NULL ) {
			for(int i=0;i<[[allGroups allKeys]count];i++) {
			       NSSortDescriptor * teamsSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"overallRatingForConference" ascending:NO];
			       NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:teamsSortDescriptor,nil];
			       [[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] sortUsingDescriptors:sortDescriptors];
				   [teamsSortDescriptor release];
				   [sortDescriptors release]; 
			}
			for(int i=0;i<[[allGroups allKeys]count];i++) {
				NSSortDescriptor * teamsSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wonconf" ascending:NO];
				NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:teamsSortDescriptor,nil];
				[[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] sortUsingDescriptors:sortDescriptors];
				[teamsSortDescriptor release];
				[sortDescriptors release]; 
			}
		  [tableView reloadData];
		}
			}
	else {
		
		[segmentedControl setImage:[UIImage imageNamed:@"Overall_Normal.png"]forSegmentAtIndex:1];
		[segmentedControl setImage:[UIImage imageNamed:@"Conference_OnPress.png"]forSegmentAtIndex:0];
		if(allGroups == nil) {
			allKeys = [[SMAllStandingsManager sharedInstance] allKeys];
			allGroups = [[SMAllStandingsManager sharedInstance] getTeamsStandingsAccordingToConference];
			allGroupsTeams = [self getArrayFromDict:allGroups];
		}
		for(int i=0;i<[[allGroups allKeys]count];i++) {
			NSSortDescriptor * teamsSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"overallRating" ascending:NO];
			NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:teamsSortDescriptor,nil];
			[[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] sortUsingDescriptors:sortDescriptors];
			[teamsSortDescriptor release];
			[sortDescriptors release]; 
		}
		for(int i=0;i<[[allGroups allKeys]count];i++) {
			NSSortDescriptor * teamsSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wonall" ascending:NO];
			NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:teamsSortDescriptor,nil];
			[[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] sortUsingDescriptors:sortDescriptors];
			[teamsSortDescriptor release];
			[sortDescriptors release]; 
		}
		
		[tableView reloadData];
	}
}

- (NSMutableArray *) getArrayFromDict:(NSDictionary *)allGrp {
	NSMutableArray * arrayOfAllTeams = [[NSMutableArray alloc] init];
	for(int i=0;i<[[allGrp allKeys] count];i++) {
		for(int j=0;j<[[allGrp objectForKey:[[allGrp allKeys] objectAtIndex:i]] count] ;j++) {
			[arrayOfAllTeams addObject:[[allGrp objectForKey:[[allGrp allKeys] objectAtIndex:i]] objectAtIndex:j]];
		}
	}
	return arrayOfAllTeams;
}

- (void)dealloc {
    [items release];
	[super dealloc];
	
}

@end
