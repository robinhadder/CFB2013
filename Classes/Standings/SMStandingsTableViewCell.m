//
//  SMStandingsTableViewCell.m
//  SuperMetric
//
//  Created by Macmini-11 on 04/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMStandingsTableViewCell.h"


@implementation SMStandingsTableViewCell
@synthesize teamName;
@synthesize teamFlag;
@synthesize currentStanding;
@synthesize teamInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}


@end
