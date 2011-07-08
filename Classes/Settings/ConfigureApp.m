//
//  ConfigureApp.m
//  SuperMetric
//
//  Created by Amey Tavkar on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ConfigureApp.h"


@implementation ConfigureApp
static ConfigureApp * sharedConfig = nil;

@synthesize conferenceName;
@synthesize conferenceAbbr;
@synthesize conferenceID;
@synthesize subDivision1;
@synthesize subDivision2;

+ (ConfigureApp *) sharedConfig {
	@synchronized(self) {
		
		if (sharedConfig == nil) {
			sharedConfig = [[ConfigureApp alloc ] init]; 
		}
	}
	return sharedConfig;
}



@end
