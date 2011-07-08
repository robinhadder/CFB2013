//
//  SMQuietTime.h
//  SuperMetric
//
//  Created by mac11 on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTblCell.h"

@interface SMQuietTime : UIViewController <UITableViewDelegate , UITableViewDataSource> {

	IBOutlet UITableView *quietTimeTblView;
	IBOutlet UIPickerView *timePicker;
	NSArray *hoursArray;
	NSArray *minArray;
	NSArray *amPmArray;
	NSArray *lblArray;
	
	NSMutableString *pickerValue;
	BOOL toFlag;
	BOOL fromFlag;
}

@end
