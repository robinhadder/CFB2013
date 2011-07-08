//
//  SMTeamsManager.h
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTeamsInfo.h"
#import APP_DELEGATE_HEADER

@interface SMTeamsManager : NSObject <SMTeamsInfoDelegate> {
	NSURLConnection * teamsConnection;
	NSMutableDictionary * allGroups;
	NSMutableDictionary * allTeamsGroups;
	NSArray * allKeys;
	NSMutableData * dataReceived;
	APP_DELEGATE * appDelegate;
}
//@property (nonatomic, readonly) NSArray * allKeys;
@property (nonatomic, retain) NSMutableDictionary * allGroups;

+ (SMTeamsManager *) sharedInstance;
- (id) init;

- (NSDictionary *) getTeamsAccordingToGroup;
- (NSArray *) getAllTeams;
- (NSArray *) allKeys;
- (void) clearData;
@end
