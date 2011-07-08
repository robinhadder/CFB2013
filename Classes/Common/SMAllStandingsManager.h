//
//  SMAllStandingsManager.h
//  SuperMetric
//
//  Created by Amey Tavkar on 12/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTeamsInfo.h"
#import APP_DELEGATE_HEADER

@interface SMAllStandingsManager : NSObject {
	NSURLConnection * teamsConnection;
	NSMutableDictionary * allGroups;
	NSArray * allKeys;
	NSMutableData * dataReceived;
	APP_DELEGATE * appDelegate;
}

//@property (nonatomic, readonly) NSArray * allKeys;
@property (nonatomic, retain) NSMutableDictionary * allGroups;

+ (SMAllStandingsManager *) sharedInstance;
- (id) init;
- (NSDictionary *) getTeamsStandingsAccordingToConference;

- (void) clearData;
- (NSArray *) allKeys;
-(void)downloadAllStandingsData;
@end
