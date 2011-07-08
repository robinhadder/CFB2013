//
//  XMLXpathObject.m
//
//  Created by Rakesh on 8/28/08.
//  Copyright 2008 Codewalla. All rights reserved.
//

#import "XMLXpathObject.h"
#import "XMLNode.h"


@implementation XMLXpathObject
@synthesize nodes;

- (void)printNodes {
	NSEnumerator *lc_nodesEnum = [self.nodes objectEnumerator];
	XMLNode *lc_currentNode;
	while((lc_currentNode = [lc_nodesEnum nextObject])) {
		[lc_currentNode printNode];
	}
}

- (void)extractNodes {
	xmlNodeSetPtr lc_nodes = xpath->nodesetval;
    int size;
    int i;
    
    size = (lc_nodes) ? lc_nodes->nodeNr : 0;
    for(i = 0; i < size; ++i) {
		assert(lc_nodes->nodeTab[i]);
		XMLNode *lc_node = [[XMLNode alloc] initWithNode:lc_nodes->nodeTab[i]];
		[self.nodes addObject:lc_node];
		[lc_node release];
    }
}

- (id)initWithXpath:(xmlXPathObjectPtr)in_xpath {
	if (self = [super init]) {
		xpath = in_xpath;
		nodes = [[NSMutableArray alloc] init];
		[self extractNodes];
	}
	return self;
}

- (void)dealloc {
	xmlXPathFreeObject(xpath);
	[nodes release];
	[super dealloc];
}

@end
