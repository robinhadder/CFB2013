//
//  XMLUtil.m
//
//  Created by Rakesh on 8/28/08.
//  Copyright 2008 Codewalla. All rights reserved.
//

#import "XMLUtil.h"


@implementation XMLUtil
@synthesize xml;
@synthesize xmlDocument;
@synthesize resultCode;

- (XMLXpathObject*)evaluateXpath: (NSString*)in_xpath {
	xmlXPathContextPtr xpathCtx = xmlXPathNewContext(xmlDocument);
	if(xpathCtx == NULL) {
		fprintf(stderr,"Error: unable to create new XPath context\n");
	} else {
		xmlXPathObjectPtr xpathObj = xmlXPathEvalExpression(BAD_CAST [in_xpath cStringUsingEncoding:NSUTF8StringEncoding], xpathCtx);
		xmlXPathFreeContext(xpathCtx); 
		if(xpathObj == NULL) {
			//CNSLog(NSLog(@"Error: unable to evaluate xpath expression \"%s\"\n", in_xpath));
			NSLog(@"Error: unable to evaluate xpath expression \"%s\"\n", in_xpath);
		} else {
			return [[XMLXpathObject alloc] initWithXpath:xpathObj];
		}
	}
	return nil;
}

- (void)configureXmlParser: (NSString*)in_content {
	if (in_content) {
		xmlDocPtr doc = NULL; /* the resulting document tree */
		
		/*
		 * The document being in memory, it have no base per RFC 2396,
		 * and the "noname.xml" argument will serve as its base.
		 */
		const char *lc_charcontent = [in_content cStringUsingEncoding:NSUTF8StringEncoding];
		doc = xmlReadMemory(lc_charcontent, strlen(lc_charcontent), "noname.xml", NULL, 0);
		if (doc == NULL) {
//			CNSLog(NSLog(@"Failed to parse document\n"));
			NSLog(@"Failed to parse document\n");
			return;
		} else {
			xmlDocument = doc;
		}
	} else
		xmlDocument = NULL;
}

- (id)initWithXml:(NSString*)in_xml {
	if (self = [super init]) {
		self.resultCode = 0;
		xmlDocument = nil;
		self.xml = in_xml;
		[self configureXmlParser: self.xml];
	}
	return self;
}

- (void)dealloc {
    xmlFreeDoc(xmlDocument);
	[xml release];
	[super dealloc];
}

@end
