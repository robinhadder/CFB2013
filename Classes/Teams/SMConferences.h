//
//  SMConferences.h
//  SuperMetric
//
//  Created by Amey Tavkar on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMConferenceCustomTableViewCell.h"
#import "SMSignUp.h"
#import "ConfigureApp.h"
#import "SMTeams.h"
#import "SoundManager.h"

@interface SMConferences : UIViewController <UITableViewDelegate,UITableViewDataSource> {

	IBOutlet UITableView *myConferenceTableView;
	IBOutlet SMConferenceCustomTableViewCell *conferenceCell;
	IBOutlet SMConferenceCustomTableViewCell *prevoiusConferenceCell;
	IBOutlet UILabel* conferenceLabel;
	NSMutableArray * myConferences;
	NSMutableArray * currentConferences;
	BOOL isConferenceCalledfromSettings;
	BOOL isFileDownloadComplete;
	
	SMConferenceCustomTableViewCell * cellOld;
	
	NSArray *paths ;
	NSString *documentsDirectoryPath ;
	NSString *tempFilePath ;
	SoundManager* soundManager;
}

@property (assign ) BOOL isConferenceCalledfromSettings;

- (id)readPlist:(NSString *)fileName getvalueForKey:(NSString *)key;
//-(void)reloadTable:(NSIndexPath *)indexPath;
//-(void) loadFile;
@end
