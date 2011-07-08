    //
//  SMLiveGame.m
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMLiveGame.h"


@implementation SMLiveGame

@synthesize delegate;
@synthesize liveGames;
@synthesize screenScrollView;

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
	
	[liveNowLabel setText:NSLocalizedString(@"LIVE NOW",@"LIVE NOW")];
	liveGames = [[NSMutableArray alloc] init];
	[game1Img setHidden:YES];
	[game2Img setHidden:YES];
	[screenScrollView setContentSize:CGSizeMake(320.0f,870.0f)];
	[screenScrollView setScrollEnabled:YES];

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

#pragma mark -
#pragma mark Public Functions
- (void) showDetailedGame:(SMGameInfo *)gameInfo {
	[super showDetailedGame:gameInfo];
	[labelVS setText:@"VS"];
	[label_ setText:@"_"];
	NSArray * arr = [[gameInfo score] componentsSeparatedByString:@":"]; 
	[scoreForTeam1 setTitle:[arr objectAtIndex:0] forState:UIControlStateNormal ];
	[scoreForTeam2 setTitle:[arr objectAtIndex:1] forState:UIControlStateNormal ];
//	[time setText:[gameInfo dateStr]];
//	[venue setText:[gameInfo venue]];
	//[score setText:[gameInfo score]];
}

- (void) showSchedule:(NSArray *)inAllGames {
	NSMutableArray * allGamesT = [[NSMutableArray alloc] initWithArray:inAllGames];
	if( liveGames != nil )
		[liveGames release];
		
	liveGames = [[NSMutableArray alloc] init];

	
	NSDate * currentDate = [NSDate date];
	/*NSString * dateTimeStr  = [NSString stringWithFormat:@"%d"@"-" @"%d"@"-" @"%d"@" " @"%d"@":" @"%d"@":" @"%d"@, 2010,11,20,10,30,00 ];
	 NSLog(@"DATE IS :: %@", dateTimeStr);
	 NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	 NSDate * currentDate = [dateFormatter dateFromString:dateTimeStr];
	 NSLog(@"Current Date :: %@", currentDate);*/
	
	for( SMGameInfo * gameInfo in inAllGames ) {
		if( [[gameInfo date] compare:currentDate] == NSOrderedSame || [[gameInfo date] compare:currentDate] == NSOrderedAscending ){
			if ([liveGames count] == 0) {                      // if the count of live games is more than one then shoe the details of the game at 0 position
				[liveGames addObject:gameInfo];
				[allGamesT removeObject:gameInfo];				
			}
		}
		/*else {
			[allGamesT removeObject:gameInfo];
		}*/
	}
	
	if( [liveGames count] > 0 ) {
		[self showDetailedGame:[liveGames objectAtIndex:0]];
	/*	if( [liveGames count] >= 2 ) {
			[switchLiveGames setHidden:NO];
			[game1Img setHidden:NO];
			[game2Img setHidden:NO];
			[game1Img setImage:[UIImage imageNamed:@"game1Select.png"]];
		}*/
	/*	[switchLiveGames setEnabled:YES forSegmentAtIndex:1];
		if( delegate != nil ) {
			[delegate foundLiveGames];
		}*/
	}
	
	[super showSchedule:allGamesT];
	[allGamesT release];
}

#pragma mark -
#pragma mark Controll Actions
- (IBAction) switchLiveMatches:(id)sender {
	UISegmentedControl * switchGames = (UISegmentedControl *)sender;
	int tagSelected = [switchGames selectedSegmentIndex];
	if( tagSelected < [liveGames count] ) {
		[self showDetailedGame:[liveGames objectAtIndex:tagSelected]];
	}
	
	if(tagSelected == 0) {
		[game1Img setImage:[UIImage imageNamed:@"game1Select.png"]];
		[game2Img setImage:[UIImage imageNamed:@"game2Deselect.png"]];
	}
	else {
		[game1Img setImage:[UIImage imageNamed:@"game1Deselect.png"]];
		[game2Img setImage:[UIImage imageNamed:@"game2Select.png"]];
	}
}

- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	if( liveGames != nil ) {
		[liveGames release];
	}
	
    [super dealloc];
}


@end
