//
//  SMTblCell.h
//  SuperMetric
//
//  Created by mac11 on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMTblCell : UITableViewCell<UITextFieldDelegate> {
	
	UILabel *cellLabel;
	UITextField *cellTextField;
	UISwitch *cellOnOffSwitch;

}

@property(nonatomic, retain) UILabel *cellLabel;
@property(nonatomic, retain) UITextField *cellTextField;
@property(nonatomic, retain) UISwitch *cellOnOffSwitch;

- (void) createCellLabel:(CGRect)frame;
- (void) createCellTextField:(CGRect)frame;
- (void) createCellSwitch:(CGRect)frame;

- (void)setLabelText:(NSString *)text;

@end
