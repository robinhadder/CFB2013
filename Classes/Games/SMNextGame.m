//
//  SMNextGame.m
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMNextGame.h"


@implementation SMNextGame

@synthesize screenScrollViewForNextGameScreen;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[nextGameLabel setText:NSLocalizedString(@"NEXT GAME",@"NEXT GAME")];
	[screenScrollViewForNextGameScreen setContentSize:(CGSizeMake(320.0f,870.0f)) ];
	[screenScrollViewForNextGameScreen setScrollEnabled:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
}

- (void) showSchedule:(NSArray *)inAllGames {
	NSMutableArray * array = [[NSMutableArray alloc] initWithArray:inAllGames];
	if( [array count] > 0 ) {
		SMGameInfo * gameInfo = [[array objectAtIndex:0] retain];
		[array removeObjectAtIndex:0];
		
		[self showDetailedGame:gameInfo];
		
		[gameInfo release];
		
		[super showSchedule:array];
		[vslbl setText:@"VS"];
	}
	[array release];
}


- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
    [super dealloc];
}


@end
