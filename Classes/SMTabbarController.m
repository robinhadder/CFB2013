    //
//  SMTabbarController.m
//  SuperMetric
//
//  Created by codewalla soft on 29/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMTabbarController.h"


@implementation SMTabbarController

@synthesize teamsScreen;
@synthesize gamesScreen;
@synthesize settings;
@synthesize standings;


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
	
	//[teamsTabBarItem setTitle:NSLocalizedString(@"Schedule",@"Schedule") ];
//	[gamesTabBarItem setTitle:NSLocalizedString(@"Standings",@"Standings")];
//	[tauntsTabBarItem setTitle:NSLocalizedString(@"Taunt",@"Taunt")];
//	[settingsTabBarItem setTitle:NSLocalizedString(@"Settings",@"Settings")];

	[teamsTabBarItem    initWithTitle:@"Schedule" image:[UIImage imageNamed:@"TabBar_schedule.png"] tag:1];
	[gamesTabBarItem    initWithTitle:@"Standings" image:[UIImage imageNamed:@"TabBar_standings.png"] tag:2];
	[settingsTabBarItem initWithTitle:@"Settings" image:[UIImage imageNamed:@"TabBar_Settings.png"] tag:4];
		
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)dealloc {
	if( teamsScreen != nil ) {
		if( [teamsScreen.view superview] != nil ) {
			[teamsScreen.view removeFromSuperview];
		}
		[teamsScreen release];
	}
	
	if( gamesScreen != nil ) {
		if( [gamesScreen.view superview] != nil ) {
			[gamesScreen.view removeFromSuperview];
		}
		[gamesScreen release];
	}
	
	
	if( settings != nil ) {
		if( [settings.view superview] != nil ) {
			[settings.view removeFromSuperview];
		}
		[settings release];
	}
	
    [super dealloc];
}


@end
