//
//  XMLUtil.h
//
//  Created by Rakesh on 8/28/08.
//  Copyright 2008 Codewalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libxml/parser.h>
#import <libxml/tree.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
#import "XMLXpathObject.h"


@interface XMLUtil : NSObject {
	NSString *xml;
	xmlDocPtr xmlDocument;
	int32_t resultCode;
}

@property (nonatomic, retain) NSString *xml;
@property (readwrite) xmlDocPtr xmlDocument;
@property (readwrite) int32_t resultCode;

- (XMLXpathObject*)evaluateXpath: (NSString*)in_xpath;
- (id)initWithXml:(NSString*)in_xml;

@end
