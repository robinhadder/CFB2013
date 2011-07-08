//
//  NetworkCheck.h
//  RouteRageous
//
//  Created by MAC06 on 25/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkCheck : NSObject {

}

+(NetworkCheck*)sharedInstance;
-(BOOL)isNetworkAvailable;
@end
