//
//  SMScoreTones.h
//  SuperMetric
//
//  Created by codewalla soft on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSignIn.h"
#import "ConfigureApp.h"

@interface SMScoreTones : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	IBOutlet UITableView *tableView;
	IBOutlet UILabel* welcomeLabel;
	IBOutlet UILabel* instructionLabel;
	NSArray *contentArray1;
	NSArray *contentArray2;
}

@property (nonatomic, retain) UITableView *tableView;

@end
