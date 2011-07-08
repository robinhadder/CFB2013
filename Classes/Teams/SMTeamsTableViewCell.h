//
//  SMTeamsTableViewCell.h
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTeamsInfo.h"
#import "SoundManager.h"

@interface SMTeamsTableViewCell : UITableViewCell {
	IBOutlet UIImageView * teamFlag;
	IBOutlet UILabel * teamName;
	
	IBOutlet UIButton * likeBtn;
	IBOutlet UIButton * dislikeBtn;
	
	UIImage * likeImage;
	UIImage * dislikeImage;
	UIImage * neutralImageL;
	UIImage * neutralImageD;
	
	SMTeamsInfo * teamInfo;
	SoundManager* soundManager;
}
@property (nonatomic, retain) IBOutlet UIImageView * teamFlag;
@property (nonatomic, retain) IBOutlet UILabel * teamName;
@property (nonatomic, retain) SMTeamsInfo * teamInfo;
@property (nonatomic, retain) IBOutlet UIButton * likeBtn;

- (void) setTeamSInfo:(SMTeamsInfo *)inTeamInfo;
- (void) likeButtonAction:(id)sender;
- (void) dislikeButtonAction:(id)sender;

@end
