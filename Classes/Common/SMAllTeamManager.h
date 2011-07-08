//
//  SMAllTeamManager.h
//  SuperMetric
//
//  Created by Macmini-11 on 11/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTeamsInfo.h"
#import APP_DELEGATE_HEADER

@interface SMAllTeamManager :NSObject /*<SMTeamsInfoDelegate>*/ {
	NSURLConnection * teamsConnection;
	NSMutableDictionary * allGroups;
	NSArray * allKeys;
	NSMutableData * dataReceived;
	APP_DELEGATE * appDelegate;
}

//@property (nonatomic, readonly) NSArray * allKeys;
@property (nonatomic, retain) NSMutableDictionary * allGroups;


+ (SMAllTeamManager *) sharedInstance;
- (id) init;

- (NSDictionary *) getAllTeamsForAllConferences;
- (void) clearData;
- (NSArray *) allKeys;

@end
