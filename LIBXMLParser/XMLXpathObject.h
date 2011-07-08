//
//  XMLXpathObject.h
//
//  Created by Rakesh on 8/28/08.
//  Copyright 2008 Codewalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libxml/parser.h>
#import <libxml/tree.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>


@interface XMLXpathObject : NSObject {
	xmlXPathObjectPtr xpath;
	NSMutableArray *nodes;
}
- (id)initWithXpath:(xmlXPathObjectPtr)in_xpath;
- (void)printNodes;

@property (nonatomic, retain) NSMutableArray *nodes;

@end
