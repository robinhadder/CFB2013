//
//  SMSettings.h
//  SuperMetric
//
//  Created by mac11 on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SMTblCell.h"
#import "Settings.h"

@interface SMSettings : UIViewController {
	IBOutlet UIImageView* backGroundImage;
	Settings *settingsView;
}

@property(nonatomic,assign) IBOutlet UIImageView* backGroundImage;

@end

