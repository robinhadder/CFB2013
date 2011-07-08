//
//  SMSignIn.h
//  SuperMetric
//
//  Created by mac11 on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTblCell.h"
#import "SMSignUp.h"

@interface SMSignIn : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
	IBOutlet UITableView *signInTblView;
	IBOutlet UILabel* instructionLabel;
	IBOutlet UILabel* subTitleLabel;

	
	NSArray *labelTextArr;
}


@end
