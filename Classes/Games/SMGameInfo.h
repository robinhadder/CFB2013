//
//  SMGameInfo.h
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMGameInfo : NSObject {
	int matchID;
	NSString * matchType;
	
	NSString *conf1;
	NSString *sub1;
	NSString *team1Name;
	NSString *team1abbr;
	
	NSString * conf2;
	NSString *	sub2;
	NSString * team2Name;
	NSString * team2abbr ;
	
	NSString * venue;
	NSDate *date;
	NSString *time ;
	NSString * score;
	NSString * dateStr;
	int finished;

	UIImage * team1Flag;
	UIImage * team2Flag;

}

@property (nonatomic, assign) int matchID;
@property (nonatomic, retain) NSString *matchType;

@property (nonatomic, retain) NSString *conf1;
@property (nonatomic, retain) NSString *sub1;
@property (nonatomic, retain) NSString *team1Name;
@property (nonatomic, retain) NSString *team1abbr;

@property (nonatomic, retain) NSString *conf2;
@property (nonatomic, retain) NSString *sub2;
@property (nonatomic, retain) NSString *team2Name;
@property (nonatomic, retain) NSString *team2abbr;

@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSDate   *date;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString * score;
@property (nonatomic, retain) NSString * dateStr;
@property (nonatomic, assign) int finished;

@property (nonatomic, retain) UIImage * team1Flag;
@property (nonatomic, retain) UIImage * team2Flag;




@end
