//
//  SMGameTableViewCell.h
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMGameTableViewCell : UITableViewCell {
	IBOutlet UIImageView * team1Flag;
	IBOutlet UIImageView * team2Flag;
	
	IBOutlet UILabel * team1Name;
	IBOutlet UILabel * team2Name;
	IBOutlet UILabel * vslbl;
	
	IBOutlet UILabel * gameVenueDateTime;
}
@property (nonatomic, retain) IBOutlet UIImageView * team1Flag;
@property (nonatomic, retain) IBOutlet UIImageView * team2Flag;
@property (nonatomic, retain) IBOutlet UILabel * team1Name;
@property (nonatomic, retain) IBOutlet UILabel * team2Name;
@property (nonatomic, retain) IBOutlet UILabel * gameVenueDateTime;


@end
