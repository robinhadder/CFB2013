//
//  LoadingScreen.m
//  iLove
//
//  Created by Codewalla on 09/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoadingScreen.h"


@implementation LoadingScreen

@synthesize delegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	//[bottomLineLabel setText:NSLocalizedString(@"Destiny Love Reading",@"")];
    [super viewDidLoad];
	[self performSelector:@selector(callAnotherScreen) withObject:nil afterDelay:9];	
}

- (void) callAnotherScreen
{
	if(delegate)
	{
		[delegate loadingScreenTapped];
	}
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
	// Release any retained subviews of the main view.
	delegate = nil;
}

//-(void) touchesBegan:(NSSet * )touches withEvent:(UIEvent * )event
//{
//	//[delegate loadingScreenTapped];
//}

- (void)dealloc 
{
	NSLog(@"========= Loading Screen Release=====");
    [super dealloc];
}


@end
