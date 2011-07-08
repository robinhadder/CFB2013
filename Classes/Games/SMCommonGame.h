//
//  SMCommonGame.h
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMGameTableViewCell.h"
#import "SMGameInfo.h"

@interface SMCommonGame : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	
	IBOutlet UIImageView * team1Flag;
	IBOutlet UIImageView * team2Flag;
	
	IBOutlet UILabel * team1Name;
	IBOutlet UILabel * team2Name;
	
	IBOutlet UILabel * venue;
	IBOutlet UILabel * date;
	IBOutlet UILabel * time;
	
	IBOutlet UITableView * gamesTableView;
	IBOutlet SMGameTableViewCell * gameTableCell;
	
	NSArray * allGames;
}
@property (nonatomic, readonly) IBOutlet UITableView * gamesTableView;
@property (nonatomic, readonly) IBOutlet UIImageView * team1Flag;
@property (nonatomic, readonly) IBOutlet UIImageView * team2Flag;
@property (nonatomic, readonly) IBOutlet UILabel * team1Name;
@property (nonatomic, readonly) IBOutlet UILabel * team2Name;
@property (nonatomic, readonly) IBOutlet UILabel * venue;
@property (nonatomic, readonly) IBOutlet UILabel * date;
@property (nonatomic, readonly) IBOutlet UILabel * time;
@property (nonatomic, retain) NSArray * allGames;

- (void) showSchedule:(NSArray *)allGames;
- (void) showDetailedGame:(SMGameInfo *)gameInfo;

@end
