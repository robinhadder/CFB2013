//
//  SMStandingsTableViewCell.h
//  SuperMetric
//
//  Created by Macmini-11 on 04/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTeamsInfo.h"

@interface SMStandingsTableViewCell : UITableViewCell {
	IBOutlet UIImageView * teamFlag;
	IBOutlet UILabel * teamName;
	IBOutlet UILabel * currentStanding;

	SMTeamsInfo * teamInfo;

}
@property (nonatomic, retain) IBOutlet UIImageView * teamFlag;
@property (nonatomic, retain) IBOutlet UILabel * teamName;
@property (nonatomic, retain) IBOutlet UILabel *currentStanding ;
@property (nonatomic, retain) SMTeamsInfo * teamInfo;

@end
