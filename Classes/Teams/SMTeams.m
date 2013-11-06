    //
//  SMTeams.m
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "SMTeams.h"
#import "SMTeamsManager.h"

@implementation SMTeams

@synthesize allGroups;

- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReloadTableData:) name:@"RELOAD_TABLE" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDownloadTeamData:) name:@"DOWNLOADED_TEAMS_DATA" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamDidChangeStatus:) name:@"TEAM_STATUS_CHANGED" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamWillChangeStatus:) name:@"TEAM_REGQUEST_STATUS_CHANGE" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadingTeamsDataCompleted:) name:@"DOWNLODING_TEAMS_DATA_ENDED" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadingTeamsDataStarted:) name:@"DOWNLODING_TEAMS_DATA_STARTED" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimatingIndicator:) name:@"STARTINDICATOR" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimatingIndicator:) name:@"STOPINDICATOR" object:nil];
	
	[[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
	
	CGRect frame = CGRectMake(100, 0, 100, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"My Team",@"My Team");

	[teamLabel setText:NSLocalizedString(@"Teams",@"Teams")];
	[instructionLabel setText:NSLocalizedString(@"Pick the teams you want to follow",@"Pick the teams you want to follow")];
	
	imageNames = [[NSArray alloc] initWithObjects:@"grey_down.png",@"yellow up.png",nil];
	NSLog(@"TEST :: RETAIN COUNT %d ", [allGroups retainCount]);
	if (allGroups!=NULL ) {
		[allGroups release ];		
	}
	allKeys = [[SMTeamsManager sharedInstance] allKeys];
	allGroups = [[SMTeamsManager sharedInstance] getTeamsAccordingToGroup];
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
     return [allGroups count];
	//return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray * array = [allGroups allKeys];
	return [[allGroups objectForKey:[array objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* cellIdentifier = @"TeamsInfoCell";	
	
	SMTeamsTableViewCell * cell = (SMTeamsTableViewCell *)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
	if( cell == nil ){
		[[NSBundle mainBundle] loadNibNamed:@"SMTeamsTableViewCell" owner:self options:nil];
		cell = teamsTableCell;
		teamsTableCell = nil;
	}
	NSMutableArray * teamsInGroup = [allGroups objectForKey:[allKeys objectAtIndex:indexPath.section]];
	SMTeamsInfo * teamInfo = [teamsInGroup objectAtIndex:indexPath.row];
		
	[[cell likeBtn] setImage:[UIImage imageNamed:[imageNames objectAtIndex:[teamInfo isLike]]] forState:UIControlStateNormal];
	[[cell likeBtn] setSelected:[teamInfo isLike]];
	[[cell teamName] setText:[teamInfo nameEN]];
	[[cell teamFlag] setImage:[teamInfo teamFlag]];
	[cell setTeamSInfo:teamInfo];
	return cell;	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if([[allKeys objectAtIndex:0] isEqualToString:@"noSubDiv"]) {
		return @"";
	}
	else {
		return [allKeys objectAtIndex:section];
	}
}

- (void) didDownloadTeamData:(NSNotification *)notification {
	allGroups = [[SMTeamsManager sharedInstance] getTeamsAccordingToGroup];
	//NSLog(@"TEAMS :: ALL GROUPS %@", allGroups);
	[tableView reloadData];
}


- (void) didReloadTableData:(NSNotification *)notification {
	for(int i=0;i<[[allGroups allKeys] count];i++) {
		for(int j=0;j<[[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] count];j++) {
			SMTeamsInfo * team = [[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] objectAtIndex:j];
			if([team teamID] == [[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"]) {
				[[[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] objectAtIndex:j] setIsLike:NO];
			}
		}
	}
	[tableView reloadData];
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

- (void) startAnimatingIndicator:(NSNotification *)notification {
	NSLog(@"Team will change status");
	[tableView setUserInteractionEnabled:FALSE];
	//[[[self.view superview] superview] setUserInteractionEnabled:NO];
//	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//	[activityIndicator setCenter:CGPointMake( 160, 200)];
//	[self.view addSubview:activityIndicator];
//	[activityIndicator startAnimating];
	
}

- (void) stopAnimatingIndicator:(NSNotification *)notification {
	NSLog(@"Team has change status");
	[ tableView setUserInteractionEnabled:TRUE];
	//[[[self.view superview] superview] setUserInteractionEnabled:YES];
//	[activityIndicator stopAnimating];
//	[activityIndicator removeFromSuperview];
//	[activityIndicator release];
//	activityIndicator = NULL;
	
}
	
- (void) teamWillChangeStatus:(NSNotification *)notification {
	NSLog(@"Team will change status");
	[[[self.view superview] superview] setUserInteractionEnabled:NO];
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicator setCenter:CGPointMake( 160, 200)];
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
}

- (void) teamDidChangeStatus:(NSNotification *)notification {
	[[[self.view superview] superview] setUserInteractionEnabled:YES];
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	[activityIndicator release];
	activityIndicator = NULL;
	
	SMTeamsInfo * teamInfoIn = (SMTeamsInfo *)[notification object];
	int section = [allKeys indexOfObject:[teamInfoIn group]];
	int index = [[allGroups objectForKey:[teamInfoIn group]] indexOfObject:teamInfoIn];
	NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:section];
	SMTeamsTableViewCell * cell = (SMTeamsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell setTeamSInfo:teamInfoIn];
/*	
	if( [teamInfoIn isEqual:teamInfo] ) {
		switch ([teamInfo teamStatus]) {
			case kLike:
				[dislikeBtn setImage:neutralImageD forState:UIControlStateNormal];
				[likeBtn setImage:likeImage forState:UIControlStateNormal];
				break;
				
			case kDisLike:
				[dislikeBtn setImage:dislikeImage forState:UIControlStateNormal];
				[likeBtn setImage:neutralImageL forState:UIControlStateNormal];
				break;
				
			case kNeutral:
				[dislikeBtn setImage:neutralImageD forState:UIControlStateNormal];
				[likeBtn setImage:neutralImageL forState:UIControlStateNormal];
				break;
		}
	}*/
}
#pragma mark -
#pragma mark TeamInfoDelegate
//- (void) getTeamObject:(SMTeamsInfo *)teamInfo {
/*	teamInfoToChkLike = teamInfo;
	for(int i=0;i<[[allGroups allKeys] count];i++) {
		for(int j=0;j<[[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] count];j++) {
			SMTeamsInfo * team = [[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] objectAtIndex:j];
			if([team teamID] == prevTeamID) {
				[[[allGroups objectForKey:[[allGroups allKeys] objectAtIndex:i]] objectAtIndex:j] setIsLike:NO];
			}
		}
	}
	[tableView reloadData]; */
//}
//- (void) smTeamInfo:(SMTeamsInfo *)smTeam changedStatusTo:(TeamStatus)newStatus{}

- (void)dealloc {
	NSLog(@"Teams Release");	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


@end
