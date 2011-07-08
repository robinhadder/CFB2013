//
//  SMGameInfo.m
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMGameInfo.h"


@implementation SMGameInfo

@synthesize matchID;
@synthesize matchType;

@synthesize conf1;
@synthesize sub1;
@synthesize team1Name;
@synthesize team1abbr;

@synthesize conf2;
@synthesize sub2;
@synthesize team2Name;
@synthesize team2abbr;

@synthesize  venue;
@synthesize date;
@synthesize time;
@synthesize score;
@synthesize finished;
@synthesize dateStr;

@synthesize team1Flag;
@synthesize team2Flag;

- (id) init {
	if( self = [super init]){
	}
	return self;
}

- (void) dealloc {
	//NSLog(@"%@ Released",[self class]);
	if( team1Flag != nil ) {
		[team1Flag release];
	}
	
	if( team1Name != nil ) {
		[team1Name release];
	}
	
	if( team2Name != nil ) {
		[team2Name release];	
	}
	
	if( team1Flag != nil ) {
		[team2Flag release];
	}
	
	if( venue != nil ) {
		[venue release];
	}
	
	if( date != nil ) {
		[date release];
	}
	
	
	[super dealloc];
}

@end
