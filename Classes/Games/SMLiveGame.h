//
//  SMLiveGame.h
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCommonGame.h"

@protocol SMLiveGamesDelegate;

@interface SMLiveGame : SMCommonGame <UIScrollViewDelegate>{
	IBOutlet UIScrollView *screenScrollView;
	IBOutlet UILabel * score;
	IBOutlet UILabel * labelVS;
	IBOutlet UILabel * label_;
	IBOutlet UISegmentedControl * switchLiveGames;
	
	IBOutlet UIButton *scoreForTeam1;
	IBOutlet UIButton *scoreForTeam2;
	
	IBOutlet UIImageView * game1Img;
	IBOutlet UIImageView * game2Img;
	
	IBOutlet UILabel* liveNowLabel;
	
	NSMutableArray * liveGames;
	
	id<SMLiveGamesDelegate> delegate;
}

@property ( nonatomic, assign ) id<SMLiveGamesDelegate> delegate;
@property (nonatomic, readonly) NSMutableArray * liveGames;
@property (nonatomic, readonly) UIScrollView * screenScrollView;

- (void) showSchedule:(NSArray *)inAllGames;
- (IBAction) switchLiveMatches:(id)sender;

@end

@protocol SMLiveGamesDelegate <NSObject>

- (void) foundLiveGames;

@end

