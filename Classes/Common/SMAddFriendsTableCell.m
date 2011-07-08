//
//  SMAddFriendsTableCell.m
//  SuperMetric
//
//  Created by MAC06 on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMAddFriendsTableCell.h"


@implementation SMAddFriendsTableCell

@synthesize addMoreFriendsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
