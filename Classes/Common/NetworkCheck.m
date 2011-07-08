//
//  NetworkCheck.m
//  RouteRageous
//
//  Created by MAC06 on 25/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetworkCheck.h"
#import "Reachability.h"

@implementation NetworkCheck

static NetworkCheck * sharedInstance = nil;

+ (NetworkCheck *)sharedInstance {
	@synchronized(self){
		if(sharedInstance==nil) 
		{
			sharedInstance = [[NetworkCheck alloc] init];
		}
	}
	return sharedInstance;
}


-(id) init
{
	self = [super init];
	if( self!= nil)
	{}
	return self;
}

-(BOOL)isNetworkAvailable
{
	Reachability* reachabilityObj = [Reachability reachabilityWithHostName:@"www.google.com"];
	
	NetworkStatus internetStatus = [reachabilityObj currentReachabilityStatus];
	
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		UIAlertView * alert = [[UIAlertView alloc] 
							   initWithTitle:NSLocalizedString(@"Could not connect to the internet",@"Could not connect to the internet") 
							   message:NSLocalizedString(@"You must connect to Wi-Fi or cellular data network to access this feature.",@"You must connect to Wi-Fi or cellular data network to access this feature.")
							   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return FALSE;
	}
	else 	{
		return TRUE;
	}
	
}


@end
