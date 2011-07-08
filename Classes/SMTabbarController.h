//
//  SMTabbarController.h
//  SuperMetric
//
//  Created by codewalla soft on 29/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTauntScreen.h"
#import "Settings.h"
#import "SMGames.h"
#import "SMTeams.h"
#import "SMStandings.h"

@interface SMTabbarController : UITabBarController {
	IBOutlet UITabBarItem* teamsTabBarItem;
	IBOutlet UITabBarItem* gamesTabBarItem;
	IBOutlet UITabBarItem* tauntsTabBarItem;
	IBOutlet UITabBarItem* settingsTabBarItem;
	
	IBOutlet SMTeams * teamsScreen;
	IBOutlet SMGames * gamesScreen;
	IBOutlet SMTauntScreen * tauntScreen;
	IBOutlet Settings * settings;
	IBOutlet SMStandings * standings;
	
}

@property (nonatomic, retain) IBOutlet SMTeams * teamsScreen;
@property (nonatomic, retain) IBOutlet SMGames * gamesScreen;
@property (nonatomic, retain) IBOutlet SMTauntScreen * tauntScreen;
@property (nonatomic, retain) IBOutlet Settings * settings;
@property (nonatomic, retain) IBOutlet SMStandings * standings;

- (void) showTauntMessage:(NSString *)tauntMessage;

@end
