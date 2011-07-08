//
//  XMLNode.h
//
//  Created by Rakesh on 8/28/08.
//  Copyright 2008 Codewalla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libxml/parser.h>
#import <libxml/tree.h>


@interface XMLNode : NSObject {
	xmlNodePtr node;
	NSString *name;
	NSString *value;
}
- (id)initWithNode:(xmlNodePtr)in_node;
- (void)printNode;
- (XMLNode*)childNamed: (NSString*)in_name;
- (NSString*)valueOfAttributeNamed:(NSString*)in_name;
- (NSArray*)childrenNamed: (NSString*)in_name;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;

@end
