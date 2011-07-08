//
//  SMGames.h
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNextGame.h"
#import "SMLiveGame.h"


@interface SMGames : UIViewController <SMLiveGamesDelegate> {
	SMNextGame * nextGame;
	SMLiveGame * liveGame;
	
	NSURLConnection * gamesConnection;
	NSMutableArray * allGames;
	NSMutableData * dataReceived;
	UIActivityIndicatorView * activityIndicator;
}


- (NSString *) getAppropriateTimeZone:(NSString *) paramDate ;

@end
