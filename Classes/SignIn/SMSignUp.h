//
//  SMSignUp.h
//  SuperMetric
//
//  Created by mac11 on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTblCell.h"
#import "SMSignIn.h"

@interface SMSignUp : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
	IBOutlet UITableView *signUpTblView;
	IBOutlet UILabel* instructionLabel;
	NSArray *lblTextArray;
	UIAlertView * emailAlert;
}

@end
