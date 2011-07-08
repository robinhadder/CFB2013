//
//  SMFBFriendsData.h
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMFBFriendsData : NSObject {
	BOOL isSelected;
	NSString * uid;
	UIImage * friendsImage;
	NSString * friendsName;
	NSString * countryLiked;
	
	
	NSURL * friendsImageURL;
	NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
	
	BOOL isDownloadingImage;
}

@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) UIImage * friendsImage;
@property (nonatomic, retain) NSString * friendsName;
@property (nonatomic, retain) NSString * countryLiked;
@property (nonatomic, retain) NSURL * friendsImageURL;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (id) init;
- (id) initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)getNSDictionary;

- (void)startDownload;
- (void)cancelDownload;
- (void) setCountryLikedByFriend:(NSString *)countryAbbr;

@end
