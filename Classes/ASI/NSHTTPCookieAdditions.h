//
//  NSHTTPCookieAdditions.h
//  asi-http-request
//

#import <Foundation/Foundation.h>

@interface NSHTTPCookie (ValueEncodingAdditions)

- (NSString *)encodedValue;
- (NSString *)decodedValue;

@end
