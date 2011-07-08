//
//  SMStandings.h
//  SuperMetric
//
//  Created by Macmini-11 on 04/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMStandingsTableViewCell.h"

@interface SMStandings : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView * tableView;
	UISegmentedControl * segmentedControl;
	IBOutlet SMStandingsTableViewCell * standingsTableCell;
	UIActivityIndicatorView * activityIndicator;
	NSDictionary * allGroups;
	NSDictionary * allGroups1;
	NSMutableArray * allConferenceTeams;
	NSMutableArray * allGroupsTeams;
	NSArray * allKeys;
	NSArray *items;

}

- (void) pickOne:(id)sender;
- (NSMutableArray *) getArrayFromDict:(NSDictionary *)allGrp;

@end
