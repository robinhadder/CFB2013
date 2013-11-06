//
//  SMConferences.m
//  SuperMetric
//
//  Created by Amey Tavkar on 15/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMConferences.h"
#import "NetworkCheck.h"
#import "SMScoreTones.h"
#import "LoadingScreen.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@implementation SMConferences

@synthesize isConferenceCalledfromSettings;

- (void)viewDidLoad {
	[super viewDidLoad];
	soundManager =[[SoundManager alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setInteractionEnabled:) name:@"SET_INTERACTION" object:nil];
	cellOld = nil;
	[[[self navigationController] navigationBar] setTintColor:[UIColor blackColor]];
	CGRect frame = CGRectMake(100, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"My Conference",@"My Conference");
	[self setTitle:NSLocalizedString(@"My Conference",@"My Conference")];
	
	myConferences = [[NSMutableArray alloc]initWithObjects:@"ACC",@"Big 12",@"Big East",@"Big Ten",@"Conf USA",@"Independents",@"Ivy League",@"MAC",@"Mountain West",@"PAC 12",@"SunBelt",@"SEC",nil];
	currentConferences = [[NSMutableArray alloc]initWithObjects:@"acc",@"big12",@"bige",@"big10",@"cusa",@"indy",@"ivy",@"mac",@"mwest",@"pac12",@"sbelt",@"sec",nil];
}

#pragma mark -
#pragma mark TabelViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 13;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* cellIdentifier = @"conferenceCell";	
	SMConferenceCustomTableViewCell *cell = (SMConferenceCustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SMConferenceCustomTableView" owner:self options:nil];
		cell = conferenceCell;
		conferenceCell = nil;	
	}
	[[cell conferencelabel] setText: [myConferences objectAtIndex:indexPath.row]];
	
	if (indexPath.row ==[[NSUserDefaults standardUserDefaults] integerForKey:@"LAST_SELECTED_ROW"]) {
	    [[cell tickImage] setImage:[UIImage imageNamed:@"tickSelected.png" ]];
		cellOld = cell;
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SMScoreTones * scoretones = nil;
	//The below code for playing sound when a conference is changed.Olaf's wishlist 1. This sound is removed on Olaf's request on 2Dec2010.  
	/*BOOL isSoundPlaying = [[[SoundManager sharedInstance] ptrAVAudioPlayer] isPlaying]; 
	NSLog(@"IS PLAYING :: %d ",isSoundPlaying);
	if (isSoundPlaying !=TRUE) {
	    [[SoundManager sharedInstance] playSound:@"misc_timeforcollegefoot.aif"  delay:0.1];
	}*/
		
	if( cellOld != nil )
	{
		[[cellOld tickImage] setImage:[UIImage imageNamed:@"" ]]; 
	}
		
	cellOld =  (SMConferenceCustomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

	[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"LAST_SELECTED_ROW"];
	[[cellOld tickImage] setImage:[UIImage imageNamed:@"tickSelected.png" ]]; 	
	
	if( [[NetworkCheck sharedInstance] isNetworkAvailable] == NO) {
		return;
	}
	if (isConferenceCalledfromSettings == FALSE) {
		scoretones = [[SMScoreTones alloc] initWithNibName:@"SMScoreTones" bundle:[NSBundle mainBundle]];
		[self.navigationController pushViewController:scoretones animated:YES];
		[scoretones release];
	}
	if (isConferenceCalledfromSettings == YES) {
		[[self view] setUserInteractionEnabled:FALSE];   // disable user interaction 
	}	

		NSDictionary * allAppData = [self readPlist:@"allAppkeys.plist" getvalueForKey:[myConferences objectAtIndex:indexPath.row]];
	    NSLog(@"TEST :: CONF_NAME  %@",[myConferences objectAtIndex:indexPath.row]);
	    [[NSUserDefaults standardUserDefaults] setObject:[myConferences objectAtIndex:indexPath.row] forKey:@"LAST_SELECTED_CONFERENCE_NAME"];
		[[NSUserDefaults standardUserDefaults] setObject:[currentConferences objectAtIndex:indexPath.row] forKey:@"CURRENT_CONF"];
    
	    [[ConfigureApp sharedConfig] setConferenceName:[myConferences objectAtIndex:indexPath.row]];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SET_APP_NAME" object: [[ConfigureApp sharedConfig] conferenceName]];
	
	    [[ConfigureApp sharedConfig] setConferenceID:[allAppData objectForKey:@"CONFERENCE_ID"]];
    	NSLog(@"TEST :: CONF_ID  %@",[[ConfigureApp sharedConfig] conferenceID]);
	    [[NSUserDefaults standardUserDefaults] setObject:[[ConfigureApp sharedConfig] conferenceID] forKey:@"LAST_SELECTED_CONFERENCE"];
		
	    [[ConfigureApp sharedConfig] setSubDivision1:[allAppData objectForKey:@"SUBDIVISION1"]];
	    [[ConfigureApp sharedConfig] setSubDivision2:[allAppData objectForKey:@"SUBDIVISION2"]];
	    [[NSUserDefaults standardUserDefaults] setObject:[[ConfigureApp sharedConfig] subDivision1] forKey:@"LAST_SELECTED_SUBDIVISION1"];
	    [[NSUserDefaults standardUserDefaults] setObject:[[ConfigureApp sharedConfig] subDivision2] forKey:@"LAST_SELECTED_SUBDIVISION2"];
	    [[ConfigureApp sharedConfig] setConferenceAbbr:[allAppData objectForKey:@"CONFERENCE_NAME"]];
        
	    [[NSUserDefaults standardUserDefaults] setObject:[[ConfigureApp sharedConfig] conferenceAbbr] forKey:@"LAST_SELECTED_CONFERENCE_ABBR"];
	
	    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_SCHEDULE_DATA" object:nil];	    
	    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOAD_STANDINGS_DATA" object:nil];
	    //[[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVE_TAGS" object:nil];
	// the below line is commented as when the user chanegs the conference the tags on UA are unregistered and if he dont select a team again then 
	// the user wont be getting any notification for any team.If conference is changed and new team is selected then the tag for the new team is registered on Urban Airship and user will start getting the notifications for the 
	// new team selected. 
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVE_TAGS" object:nil];
	
	
/****************************************************************************************************************/
	
	 //paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	 documentsDirectoryPath = [paths objectAtIndex:0];
//	
//	 NSString *appendConfIdToFilePath = [@"/" stringByAppendingString:[[ConfigureApp sharedConfig] conferenceID]];
//	 tempFilePath = [ documentsDirectoryPath stringByAppendingString:appendConfIdToFilePath];
//	 NSLog(@"tempFilePath %@ ",tempFilePath);
//	  
//	 NSString * addConfIdToURLString = [NSString stringWithString:[NSString stringWithFormat:DOWNLOAD_DATA_FROM_PATH,[[ConfigureApp sharedConfig] conferenceID] ] ];
//	 addConfIdToURLString = [addConfIdToURLString stringByAppendingString:@".zip"];
//	 NSLog(@"addConfIdToURLString :: %@ ",addConfIdToURLString);
//	 
//	 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:addConfIdToURLString]];
//	 [request setDownloadDestinationPath:tempFilePath];
//	 [request setAllowCompressedResponse:YES];
//	 [request setDelegate:self];
//	 [request startAsynchronous];	
/****************************************************************************************************************/
  }

//-(void) loadFile{
//	
//	NSFileManager* fileManager = [NSFileManager defaultManager];
//	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	documentsDirectoryPath = [paths objectAtIndex:0];
//	
//	NSString *appendConfIdToFilePath = [@"/" stringByAppendingString:[[ConfigureApp sharedConfig] conferenceID]];
//	tempFilePath = [ documentsDirectoryPath stringByAppendingString:appendConfIdToFilePath];
//	NSLog(@"LOAD FILE FILEPATH :: %@", tempFilePath);
//
//	//tempFilePath = [ documentsDirectoryPath stringByAppendingString:@"/3212"];
//	NSString *tempFilePath1 = [ documentsDirectoryPath stringByAppendingString:@""];
//	ZipArchive *zip = [[ZipArchive alloc] init];
//	if([zip UnzipOpenFile:tempFilePath]) {
//		
//		if ([zip UnzipFileTo:tempFilePath1 overWrite:NO]) {
//			NSLog(@"Archive unzip Success");
//		} 
//		else {
//			NSLog(@"Failure To Extract Archive, maybe password?");
//		}
//	} 
//	else  {
//		NSLog(@"Failure To Open Archive");
//	}
//	//do cleanup
//	[fileManager removeItemAtPath:tempFilePath error:NULL];	
//	[zip release];	
//}
//
//
//#pragma mark ASIHTTPRequestDelegate
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//	NSData *responseData = [request responseData];
//	NSLog(@"requestFinished %@ :: ", responseData );
//	isFileDownloadComplete = TRUE;
//	if (isFileDownloadComplete) {
//		[self loadFile];		
//	}
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//	NSError *error = [request error];
//	NSLog(@"requestFailed ", error);
//}
//

#pragma mark readingPlist
- (id)readPlist:(NSString *)fileName getvalueForKey:(NSString *)key {  
	NSData *plistData;  
	NSString *error;  
	NSPropertyListFormat format;  
	id plist;  
	
	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];  
	plistData = [NSData dataWithContentsOfFile:localizedPath];   
	
	id returnValue = nil;
	
	plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
	if( plist != nil ){
		returnValue = [plist valueForKey:key];
	}	
	return returnValue;  
}

- (void) setInteractionEnabled:(NSNotification *)notification {
	[[self view] setUserInteractionEnabled:TRUE];	
}

- (void)dealloc {
	//NSLog(@"Comference Release");
	[myConferences release];
	[currentConferences release];
	//[soundManager release];
    [super dealloc];
}



@end
