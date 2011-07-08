//
//  SMFBFriendsData.m
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMFBFriendsData.h"


@implementation SMFBFriendsData

#define IS_SELECTED			@"IS_SELECTED"
#define UID					@"UID"
#define FRIENDS_NAME		@"FRIENDS_NAME"
#define COUNTRY_LIKED		@"COUNTRY_LIKED"
#define IMAGE_URL			@"IMAGE_URL"

@synthesize isSelected;
@synthesize uid;
@synthesize friendsImage;
@synthesize friendsName;
@synthesize countryLiked;
@synthesize friendsImageURL;
@synthesize activeDownload;
@synthesize imageConnection;

- (id) init {
	if( self = [super init] ) {
	}
	return self;
}

- (id) initWithDictionary:(NSDictionary *)dict {
	if( self = [super init] ) {
		isSelected = [[dict objectForKey:@"IS_SELECTED"] boolValue];
		[self setUid:[dict objectForKey:UID]];
		[self setFriendsImageURL:[dict objectForKey:IMAGE_URL]];
		[self setFriendsName:[dict objectForKey:FRIENDS_NAME]];
		[self setCountryLiked:[dict objectForKey:COUNTRY_LIKED]];
	}
	return self;
}

- (NSDictionary *)getNSDictionary {
	NSMutableDictionary * friendsData = [[NSMutableDictionary alloc] init];
	[friendsData setObject:[NSNumber numberWithBool:isSelected] forKey:IS_SELECTED];
	[friendsData setObject:uid forKey:UID];
	[friendsData setObject:friendsName forKey:FRIENDS_NAME];
	[friendsData setObject:countryLiked forKey:COUNTRY_LIKED];
	return friendsData;
}

- (void)startDownload{
	if( friendsImageURL == NULL || friendsImage != NULL || imageConnection != NULL)
		return;
	
	isDownloadingImage = YES;
	NSLog(@"Download image for :: %@",friendsName);
    self.activeDownload = [[NSMutableData alloc] init];
	NSURLRequest * request = [NSURLRequest requestWithURL:friendsImageURL];
    imageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

- (void) setCountryLikedByFriend:(NSString *)countryAbbr {
	[self setCountryLiked:countryAbbr];
	[[NSNotificationCenter defaultCenter] postNotificationName:FRIENDS_COUNTRY_SELECTED object:self];
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.activeDownload = nil;
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
	CGSize itemSize = CGSizeMake( 45, 45);
	UIGraphicsBeginImageContext(itemSize);
	CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
	[image drawInRect:imageRect];
	self.friendsImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_FRIENDS_IMAGE_COMP" object:self];
    self.activeDownload = nil;
    [image release];
    
    self.imageConnection = nil;
	NSLog(@"Downloaded Image for :: %@",friendsName);
	
	
}

- (void) dealloc {
	NSLog(@"%@ Released",[self class]);
	if( friendsName != nil ) {
		[friendsName release];
	}
	
	if( countryLiked != nil ) {
		[countryLiked release];
	}
	
	if( uid != nil ) {
		[uid release];
	}
	
	if( friendsImage != nil ){
		[friendsImage release];
	}	
	
	if( friendsImageURL != nil ){ 
		[friendsImageURL release];
	}
	
	if( activeDownload != nil ) {
		[activeDownload release];
	}
    
	if (imageConnection != nil ) {
		[imageConnection cancel];
		[imageConnection release];
	}
	
	[super dealloc];
}

@end
