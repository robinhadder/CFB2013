//
//  SMTeams.h
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTeamsTableViewCell.h"
#import "SMTeamsInfo.h"

@interface SMTeams : UIViewController </*SMTeamsInfoDelegate*/UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView * tableView;
	IBOutlet SMTeamsTableViewCell * teamsTableCell;
	IBOutlet UILabel* teamLabel;
	IBOutlet UILabel* instructionLabel;
	NSDictionary * allGroups;
	NSArray * allKeys;
	NSArray * imageNames;
	SMTeamsInfo * teamInfoToChkLike;
	UIActivityIndicatorView * activityIndicator;
}
@property (nonatomic , retain) NSDictionary * allGroups;

@end
