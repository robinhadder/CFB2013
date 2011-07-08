//
//  SMGameTableViewCell.m
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMGameTableViewCell.h"


@implementation SMGameTableViewCell

@synthesize team1Name;
@synthesize team2Name;
@synthesize team1Flag;
@synthesize team2Flag;
@synthesize gameVenueDateTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
	[vslbl setText:@"-"];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
