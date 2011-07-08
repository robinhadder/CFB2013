//
//  XMLNode.m
//
//  Created by Rakesh on 8/28/08.
//  Copyright 2008 Codewalla. All rights reserved.
//

#import "XMLNode.h"


@implementation XMLNode
@synthesize name;
@synthesize value;


- (void)printNode {
    xmlNodePtr cur;
	if(node->type == XML_NAMESPACE_DECL) {
		xmlNsPtr ns;
		
		ns = (xmlNsPtr)node;
		cur = (xmlNodePtr)ns->next;
		if(cur->ns) { 
			//CNSLog(NSLog(@"= namespace \"%s\"=\"%s\" for node %s:%s\n", 
//						 ns->prefix, ns->href, cur->ns->href, cur->name));
			NSLog(@"= namespace \"%s\"=\"%s\" for node %s:%s\n", 
				  ns->prefix, ns->href, cur->ns->href, cur->name);
		} else {
			//CNSLog(NSLog(@"= namespace \"%s\"=\"%s\" for node %s\n", 
//						 ns->prefix, ns->href, cur->name));
			NSLog(@"= namespace \"%s\"=\"%s\" for node %s\n", 
				  ns->prefix, ns->href, cur->name);
		}
	} else if(node->type == XML_ELEMENT_NODE) {
		cur = node;   	    
		if(cur->ns) { 
			//CNSLog(NSLog(@"= element node \"%s:%s\"\n", 
//						 cur->ns->href, cur->name));
			NSLog(@"= element node \"%s:%s\"\n", 
				  cur->ns->href, cur->name);
		} else {
			//CNSLog(NSLog(@"= element node \"%s\"\n", 
//						 cur->name));
			NSLog(@"= element node \"%s\"\n", 
				  cur->name);
		}
	} else {
		cur = node;    
		//CNSLog(NSLog(@"= node \"%s\": type %d\n", cur->name, cur->type));
		NSLog(@"= node \"%s\": type %d\n", cur->name, cur->type);
	}
}

- (NSArray*)childrenOf:(xmlNode*)in_node named: (NSString*)in_name maxLength:(int)in_maxLength endNode:(xmlNode*)in_endNode {
	xmlNode *cur_node = NULL;
	
	NSMutableArray *lc_nodes = [[NSMutableArray alloc] init];
    for (cur_node = in_node; cur_node && (cur_node != in_endNode) && ([lc_nodes count] < in_maxLength); cur_node = cur_node->next) {
        if (cur_node->type == XML_ELEMENT_NODE) {
			NSString *lc_nodeName = [[NSString alloc] initWithCString:(const char*)cur_node->name encoding:NSUTF8StringEncoding];
			if ([lc_nodeName compare: in_name] == NSOrderedSame) {
				XMLNode *lc_xmlNode = [[XMLNode alloc] initWithNode:cur_node];
				[lc_nodes addObject: lc_xmlNode];
				[lc_xmlNode release];
			} else {
				[lc_nodes addObjectsFromArray:[self childrenOf:cur_node->children named:in_name maxLength: in_maxLength endNode: in_endNode]];
			}
			[lc_nodeName release];
        }
    }
	return [lc_nodes autorelease];
}
- (NSArray*)childrenNamed: (NSString*)in_name {
	return [self childrenOf:node named:in_name maxLength: 100 endNode: node->next];
}
- (NSArray*)childrenNamed: (NSString*)in_name maxLength:(int)in_maxLength {
	return [self childrenOf:node named:in_name maxLength: in_maxLength endNode: node->next];
}
- (XMLNode*)childNamed: (NSString*)in_name {
	NSArray *lc_nodes = [self childrenNamed: in_name maxLength: 1];
	if ([lc_nodes count] > 0) return [lc_nodes objectAtIndex:0];
	return nil;
}
- (NSString*)valueOfAttributeNamed:(NSString*)in_name {
	NSString *lc_value = nil;
    xmlNode *cur_node = node;
	xmlAttr *cur_attr;
	for(cur_attr = cur_node->properties; cur_attr; cur_attr = cur_attr->next) {
		NSString *lc_attrName = [[NSString alloc] initWithCString:(char*)cur_attr->name encoding:NSUTF8StringEncoding];
		if ([lc_attrName compare: in_name] == NSOrderedSame) {
			lc_value = [[[NSString alloc] initWithCString:(char*)cur_attr->children->content encoding:NSUTF8StringEncoding] autorelease];
		}
		[lc_attrName release];
	}
	return lc_value;
}

- (id)initWithNode:(xmlNodePtr)in_node {
	if (self = [super init]) {
		node = in_node;
		name = [[NSString alloc] initWithCString:(const char*)node->name encoding:NSUTF8StringEncoding];
		if (node->children && node->children->content) value = [[NSString alloc] initWithCString:(char*)node->children->content encoding:NSUTF8StringEncoding];
	}
	return self;
}

- (void)dealloc {
	node = nil;
	[name release];
	[value release];
	[super dealloc];
}

@end
