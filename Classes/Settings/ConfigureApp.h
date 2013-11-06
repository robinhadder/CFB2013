//
//  ConfigureApp.h
//  SuperMetric
//
//  Created by Amey Tavkar on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigureApp : NSObject {
    NSString * conferenceName;
    NSString * conferenceAbbr;
    NSString * conferenceID;
    NSString * subDivision1;
    NSString * subDivision2;
    
    
    NSString * applicationKey;
    NSString * appSceretKey;
}
+ (ConfigureApp *) sharedConfig ;






@property (nonatomic, retain) NSString *conferenceName;
@property (nonatomic, retain) NSString *conferenceAbbr;
@property (nonatomic, retain) NSString *conferenceID;
@property (nonatomic, retain) NSString *subDivision1;
@property (nonatomic, retain) NSString *subDivision2;


@end
