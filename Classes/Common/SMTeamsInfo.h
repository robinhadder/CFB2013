//
//  SMTeamsInfo.h
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { kNeutral, kLike, kDisLike} TeamStatus;

@protocol SMTeamsInfoDelegate;

@interface SMTeamsInfo : NSObject {
	int teamID;
	UIImage * teamFlag;
	NSString * group;
	NSString *subDivisions;
	NSString * nameEN;
	NSString * abr;
	//int rank;
	bool isLike;
	TeamStatus teamStatus;
	NSString *wonconf;
	NSString *lostconf;
	NSString * wonall;
	NSString *lostall;
	
	NSURLConnection * teamsConnection;
	NSMutableData * dataReceived;
	//NSOperationQueue * operationQueue;
	
	id<SMTeamsInfoDelegate> delegate;
}
@property (nonatomic, readwrite) int teamID;
@property (nonatomic, retain) UIImage * teamFlag;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * subDivisions;
@property (nonatomic, retain) NSString * nameEN;
@property (nonatomic, retain) NSString * abr;
@property (nonatomic, readwrite) bool isLike;

@property (nonatomic, retain) NSString * wonconf;
@property (nonatomic, retain) NSString * lostconf;
@property (nonatomic, retain) NSString * wonall;
@property (nonatomic, retain) NSString * lostall;

@property (nonatomic, readwrite) TeamStatus teamStatus;
@property (nonatomic, assign) id<SMTeamsInfoDelegate> delegate;


- (NSDictionary *) getDictionary;
- (BOOL) changeTeamStatusTo:(TeamStatus)status;
//- (void) getTeamData;
- (void) followTeam;
-(NSNumber *) overallRatingForConference;
-(NSNumber *) overallRating;
@end

@protocol SMTeamsInfoDelegate 

- (void) smTeamInfo:(SMTeamsInfo *)smTeam changedStatusTo:(TeamStatus)newStatus;

@end
