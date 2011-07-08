//
//  SMTeamsTableViewCell.m
//  SuperMetric
//
//  Created by codewalla soft on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMTeamsTableViewCell.h"


@implementation SMTeamsTableViewCell

@synthesize teamName;
@synthesize teamFlag;
@synthesize teamInfo;
@synthesize likeBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		soundManager =[[SoundManager alloc] init];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setTeamSInfo:(SMTeamsInfo *)inTeamInfo {
	[self setTeamInfo:inTeamInfo];
	
	if( dislikeImage == nil ){
		dislikeImage = [UIImage imageNamed:@"grey_down.png"];
	}
	
	if( likeImage == nil ) {
		likeImage = [UIImage imageNamed:@"yellow up.png"];
	}
	
	if( neutralImageL == nil ) {
		neutralImageL = [UIImage imageNamed:@"grey_down.png"];
	}
	
	if( neutralImageD == nil ) {
		neutralImageD = [UIImage imageNamed:@"grey_down.png"];
	}
	/*switch ([teamInfo teamStatus]) {
		case kLike:
			[dislikeBtn setImage:neutralImageD forState:UIControlStateNormal];
			[likeBtn setImage:likeImage forState:UIControlStateNormal];
			break;
			
		case kDisLike:
			[dislikeBtn setImage:dislikeImage forState:UIControlStateNormal];
			[likeBtn setImage:neutralImageL forState:UIControlStateNormal];
			break;
			
		case kNeutral:
			[dislikeBtn setImage:neutralImageD forState:UIControlStateNormal];
			[likeBtn setImage:neutralImageL forState:UIControlStateNormal];
			break;
	}*/
}

#pragma mark -
#pragma mark Table Cell Button Actions
- (void) likeButtonAction:(id)sender {
	//The below code for playing sound when a team is changed.Olaf's wishlist 1.  
	if ([teamInfo teamID] != [[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"]) {

		BOOL isSoundPlaying = [[[SoundManager sharedInstance] ptrAVAudioPlayer] isPlaying]; 
		NSString *currConf = [[NSUserDefaults standardUserDefaults] objectForKey:@"CURRENT_CONF"];
		NSLog(@"currConf :: %@",currConf);
		NSString *currTeam = [NSString stringWithString:[teamInfo abr]];
		NSString *string2;
		string2 = [currTeam lowercaseString];
		NSString * soundToplay = [currConf stringByAppendingFormat:@"_%@",string2];
		NSString * soundToplayforteam = [soundToplay stringByAppendingString:@"_intro.caf"];
		NSLog(@"SOUND TO PLAY %@::  ",soundToplayforteam);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"STARTINDICATOR" object:nil];
		[likeBtn setImage:[UIImage imageNamed:@"yellow up.png"] forState:UIControlStateNormal];	
		[teamInfo setIsLike:YES];
		
		NSLog(@"PREVIOUS TEAM ID %d <<==>> CURRENT TEAM ID :: %d", [[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"],[teamInfo teamID]);
		
		if (isSoundPlaying !=TRUE /*&& [teamInfo teamID] != [[NSUserDefaults standardUserDefaults] integerForKey:@"prevTeamID"]*/) {
			[[SoundManager sharedInstance] playSound:soundToplayforteam  delay:0.1];
		}
			[teamInfo followTeam];
		//[teamInfo getTeamData];
   }
}

- (void) dislikeButtonAction:(id)sender {
/*	if( teamInfo != NULL ) {
		switch( [teamInfo teamStatus]) {
			case kDisLike:
				[teamInfo changeTeamStatusTo:kNeutral];
				break;
				
			case kNeutral:
			case kLike:
				[teamInfo changeTeamStatusTo:kDisLike];
				break;
		}
	}*/
}

- (void)dealloc {
	
	if( teamInfo != nil ) {
		[teamInfo release];
	}
	
    [super dealloc];
}


@end
