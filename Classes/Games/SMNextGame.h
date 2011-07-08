//
//  SMNextGame.h
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCommonGame.h"

@interface SMNextGame : SMCommonGame {
	IBOutlet UILabel* nextGameLabel;
	IBOutlet UILabel * vslbl;
	IBOutlet UIScrollView *screenScrollViewForNextGameScreen;
}

@property(nonatomic , assign) UIScrollView *screenScrollViewForNextGameScreen;

- (void) showSchedule:(NSArray *)inAllGames;

@end
