//
//  NSHTTPCookieAdditions.m
//  asi-http-request
//


#import "NSHTTPCookieAdditions.h"

@implementation NSHTTPCookie (ValueEncodingAdditions)

- (NSString *)decodedValue
{
	NSMutableString *s = [NSMutableString stringWithString:[[self value] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//Also swap plus signs for spaces
	[s replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [s length])];
	return [NSString stringWithString:s];
}

- (NSString *)encodedValue
{
	return [[self value] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end


