//
//  SMConferenceCustomTableViewCell.h
//  SuperMetric
//
//  Created by Amey Tavkar on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMConferenceCustomTableViewCell : UITableViewCell {
	IBOutlet UIImageView * tickImage;
	IBOutlet UILabel * conferencelabel;

}
@property (nonatomic, retain) IBOutlet UIImageView * tickImage;
@property (nonatomic, retain) IBOutlet UILabel * conferencelabel;

@end
