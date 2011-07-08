//
//  SMUserData.m
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMUserData.h"
#import "XMLUtil.h"
#import "XMLNode.h"

@interface SMUserData(Private)

- (void) logoutFromScoreTones;
- (void) logoutFromFaceBook;

- (void) showFBDialog;
- (void) saveFriendsToStoreinArray:(NSArray *)friendsToStore forUser:(NSString *)userID;
- (void) showSignInAlert;
- (void) showLoginFailerAlertWithError:(NSString *)errorMesg;
- (void) removeAlert;

- (NSMutableDictionary *) getFriendsStore ;
- (void) saveFriendsToStore:(NSDictionary *)friendsDict ;
- (NSMutableArray *) getFriendsForUser:(NSString *)userID;

@end



@implementation SMUserData

#define SAVED_FB_FRIENDS		@"SAVED_FB_FRIENDS"
#define SCORE_TONES_EMAIL		@"SCORE_TONES_EMAIL"

//@synthesize delegate;
@synthesize loginType;
@synthesize downloadedFBFriends;
@synthesize uid;
@synthesize fbSession;

static SMUserData * sharedInstance = nil;
NSString * tempEmail = nil;
UIAlertView * alertView = nil;

+(SMUserData *)sharedInstance {
	@synchronized( self ) {
		if( sharedInstance == nil ) {
			sharedInstance = [[SMUserData alloc] init];
		}
	}
	return sharedInstance;
}

- (id) init {
	if( self = [super init] ){
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectFriendsCountry:) name:FRIENDS_COUNTRY_SELECTED object:nil];
	}
	return self;
}

#pragma mark -
#pragma mark Public Functions
- (BOOL) addFacebookUser:(NSString *)uuid {
	BOOL returnValue = NO;
	
	NSString * urlString = [NSString stringWithFormat:FB_SIGN_IN,uuid,@" "];
	NSURL * url = [NSURL URLWithString:urlString];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	NSError * error;
	NSData * dataRecevied = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSLog(@"FBLogin outcome :: %@",[[NSString alloc] initWithData:dataRecevied encoding:NSUTF8StringEncoding]);
	
	return returnValue;
}

- (void) loginIntoScoreWithEmail:(NSString *)emailID scoretoneUserName:(NSString *)userName andPassword:(NSString *)password {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self showSignInAlert];
	
	tempEmail = [emailID retain];
	dataReceived = [[NSMutableData alloc] init];
	//NSURL * loginURL = [NSURL URLWithString:[NSString stringWithFormat:SIGNUP_URL,userName,emailID,password]];
	//NSString * loginURL = [NSString stringWithFormat:[NSString stringWithFormat:SIGNUP_URL,userName,emailID,password]];
	NSString * loginURL = [NSString stringWithFormat:SIGNUP_URL,userName,emailID,password];
	NSLog(@"TEST :: SIGN UP %@",loginURL);
	//NSURLRequest * therequest = [NSURLRequest requestWithURL:loginURL]; 
	NSURLRequest * therequest = [NSURLRequest requestWithURL:[ NSURL URLWithString:loginURL]]; 
	connection = [[NSURLConnection alloc] initWithRequest:therequest delegate:self];
}

- (void) verifyUserWithEmail:(NSString *)emailID  andPassword:(NSString *)password  isSignInByUserName:(BOOL)signInByUserName {
	NSURL * loginURL; 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[self showSignInAlert];
	tempEmail = [emailID retain];
	dataReceived = [[NSMutableData alloc] init];
	if (signInByUserName == TRUE) {
		 loginURL = [NSURL URLWithString:[NSString stringWithFormat:SIGNIN_USERNAME_URL,emailID,password]];	
	}else{
		 loginURL = [NSURL URLWithString:[NSString stringWithFormat:SIGNIN_EMAIL_URL,emailID,password]];		
	}
	NSLog(@"TEST : LOGIN URL :: %@ ", loginURL);

	NSURLRequest * therequest = [NSURLRequest requestWithURL:loginURL]; 
	connection = [[NSURLConnection alloc] initWithRequest:therequest delegate:self];
}

- (void) logoutFrom:(LoginType)inloginType {
	LoginType storedLoginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] intValue];
	if( storedLoginType == inloginType ){
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:INITAL_LOGIN];
	}
	
	switch ( inloginType ) {
		case kScoretoneLogin:
			[self logoutFromScoreTones];
			break;
		
		case kFacebookLogin:
			[self logoutFromFaceBook];
			break;
	}
}

- (void) loginIntoFaceBook {
	if( fbSession == NULL ) {
		fbSession = [[FBSession sessionForApplication:FB_APPLICATION_KEY secret:FB_SECRET_KEY delegate:self] retain]; 
	}
	if( [fbSession resume] == NO ) {
		[self performSelector:@selector(showFBDialog) withObject:nil afterDelay:0.5f];
	}
}

- (void) openPermissionDialogBox {
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.permission = @"publish_stream";
	[dialog show];
}


- (NSString *) getScoreTonesEmail {
	NSString * userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:SCORE_TONES_EMAIL];
	return userEmail;
}


- (void) saveFriend:(SMFBFriendsData *)fbUSerData {
	[self getSavedFBFriends];
	
	if( fbUSerData != NULL ){
		for( SMFBFriendsData * friData in savedFBFriends ){
			NSString * uidToAdd = [fbUSerData uid];
			NSString * savedUid = [friData uid];
			if( [savedUid isEqualToString:uidToAdd] ) {
				return;
			}
		}
		
		[fbUSerData setCountryLiked:@""];
		NSMutableDictionary * indexPaths = [[NSMutableDictionary alloc] init];
		
		[savedFBFriends addObject:fbUSerData];
		NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[savedFBFriends indexOfObject:fbUSerData] inSection:0];
		[indexPaths setObject:indexPath forKey:@"SAVE_INDEX_PATH"];
		
		[self saveFriendsToStoreinArray:savedFBFriends forUser:uid];
		
		if( downloadedFBFriends != NULL ) {
			indexPath = [NSIndexPath indexPathForRow:[downloadedFBFriends indexOfObject:fbUSerData] inSection:0];
			[indexPaths setObject:indexPath forKey:@"DELETE_INDEX_PATH"];
			[downloadedFBFriends removeObject:fbUSerData];
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:ADDED_FB_FRIEND object:indexPaths];
	}	
}

- (void) deleteFriend:(SMFBFriendsData *)friendData {
	[self getSavedFBFriends];
	NSMutableDictionary * indexPaths = [[NSMutableDictionary alloc] init];
	NSIndexPath * indexPath;
	
	if( downloadedFBFriends != NULL ) {
		[downloadedFBFriends addObject:friendData];
		indexPath = [NSIndexPath indexPathForRow:[downloadedFBFriends indexOfObject:friendData] inSection:0];
		[indexPaths setObject:indexPath forKey:@"SAVE_INDEX_PATH"];
	}
	
	indexPath = [NSIndexPath indexPathForRow:[savedFBFriends indexOfObject:friendData] inSection:0];
	[indexPaths setObject:indexPath forKey:@"DELETE_INDEX_PATH"];
	[savedFBFriends removeObject:friendData];
	[[NSNotificationCenter defaultCenter] postNotificationName:DELETED_FB_FRIEND object:indexPaths];
	
	[self saveFriendsToStoreinArray:savedFBFriends forUser:uid];
}

- (NSArray *) getSavedFBFriends {
	if( uid == NULL )
		return nil;
	
	if( savedFBFriends != nil )
		return savedFBFriends;
	
	
	NSArray * savedFriendsDict = [self getFriendsForUser:uid];
	savedFBFriends = [[NSMutableArray alloc] init];
	
	for( NSDictionary * friendsData in savedFriendsDict ){
		SMFBFriendsData * friendInfo = [[SMFBFriendsData alloc] initWithDictionary:friendsData];
		[savedFBFriends addObject:friendInfo];
		[friendInfo release];
	}
	
	return savedFBFriends;
}

- (BOOL) downloadFBFriends {
	BOOL areFBFriendsDownloaded = NO;
	if( downloadedFBFriends != NULL ) {
		areFBFriendsDownloaded = YES;
	}
	else {
		FBRequest * fbRequest = [FBRequest requestWithSession:[[SMUserData sharedInstance] fbSession] delegate:self];
		NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"first_name,pic_square",@"fields",nil];
		[fbRequest call:@"friends.get" params:params];
	}
	return areFBFriendsDownloaded;
}


#pragma mark -
#pragma mark Private Functions
- (void) logoutFromScoreTones {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:SCORE_TONES_EMAIL];
	NSMutableDictionary * loginDict = [[NSMutableDictionary alloc] init];
	[loginDict setObject:[NSNumber numberWithBool:NO] forKey:LOGIN_STATUS];
	[loginDict setObject:[NSNumber numberWithInt:kScoretoneLogin] forKey:LOGIN_TYPE];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:loginDict];
	//
	notifyWithSoundButton = [[NSUserDefaults standardUserDefaults ] boolForKey: @"notifyWithSoundButton"];     
	[[NSUserDefaults standardUserDefaults ] setBool:notifyWithSoundButton forKey:@"notifyWithSoundButton" ]; 
}

- (void) logoutFromFaceBook {
	[[FBSession session] logout];
	[[SMUserData sharedInstance] setDownloadedFBFriends:nil];
}

- (void) showSignInAlert {	
	[self removeAlert];
	
	alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Signing In" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[alertView show];
	
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicator setCenter:CGPointMake( 140.0f, 75.0f)];
	[activityIndicator startAnimating];
	
	[alertView addSubview:activityIndicator];
}

- (void) showLoginFailerAlertWithError:(NSString *)errorMesg {
	[self removeAlert];
	
	alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorMesg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

- (void) removeAlert {
	if( alertView != nil ) {
		[alertView dismissWithClickedButtonIndex:0 animated:YES];
		[alertView release];
		alertView = nil;
	}
}

- (void) showFBDialog {
	FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:fbSession] autorelease];
    [dialog show];
}

- (NSMutableDictionary *) getFriendsStore {
	NSMutableDictionary * fbUsersIDFriends = [[[NSUserDefaults standardUserDefaults] objectForKey:SAVED_FB_FRIENDS] mutableCopy];
	if( fbUsersIDFriends == nil ) {
		fbUsersIDFriends = [[NSMutableDictionary alloc] init];
	}
	return fbUsersIDFriends;
}

- (void) saveFriendsToStore:(NSDictionary *)friendsDict {
	[[NSUserDefaults standardUserDefaults] setObject:friendsDict forKey:SAVED_FB_FRIENDS];
}

- (NSMutableArray *) getFriendsForUser:(NSString *)userID {
	NSMutableDictionary * friendsDict = [self getFriendsStore];
	NSMutableArray * friendsArray = [friendsDict objectForKey:userID];
	if( friendsArray == NULL ) {
		friendsArray = [[NSMutableArray alloc] init];
		[friendsDict setObject:friendsArray forKey:userID];
		[self saveFriendsToStore:friendsDict];
	}
	return friendsArray;
}
		 
- (void) saveFriendsToStoreinArray:(NSArray *)friendsToStore forUser:(NSString *)userID {
	if( uid == nil ) {
		return;
	}
	
	NSMutableDictionary * storedFriendsDict = [self getFriendsStore];
	
	NSMutableArray * friendsArray = [[NSMutableArray alloc] init];
	for ( SMFBFriendsData * friendsData in friendsToStore) {
		NSDictionary * friendsDict = [friendsData getNSDictionary];
		[friendsArray addObject:friendsDict];
		[friendsDict release];
	}
	
	[storedFriendsDict setObject:[friendsArray mutableCopy] forKey:userID];
	[self saveFriendsToStore:storedFriendsDict];
	
	[friendsArray release];
	[storedFriendsDict release];
}

#pragma mark -
#pragma mark FBSessionDelegate
- (void)session:(FBSession*)session didLogin:(FBUID)inuid {
	uid = [[NSString alloc] initWithFormat:@"%lld",inuid];
	NSLog(@"FB Login Succeded %@ " ,uid);
	if( [self getScoreTonesEmail] == NULL ) {
		NSString * urlString = [NSString stringWithFormat:FB_SIGN_IN,uid,@" "];
		NSURL * url = [NSURL URLWithString:urlString];
		NSLog(@"DEV TEST :: URL %@", urlString);
		NSURLRequest * request = [NSURLRequest requestWithURL:url];
		
		NSError * error;
		[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
		if( error ) {
			NSLog(@"DEV TEST :: Error :: %@",[error localizedDescription]);
		}
	}
	
	[self getSavedFBFriends];
	
	loginType = kFacebookLogin;
	NSMutableDictionary * loginDict = [[NSMutableDictionary alloc] init];
	[loginDict setObject:[NSNumber numberWithBool:YES] forKey:LOGIN_STATUS];
	[loginDict setObject:[NSNumber numberWithInt:kFacebookLogin] forKey:LOGIN_TYPE];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:loginDict];
	[loginDict release];
}

- (void)sessionDidNotLogin:(FBSession*)session {
	NSLog(@"Login sessionDidNotLogin");
	[self setDownloadedFBFriends:nil];
	NSMutableDictionary * loginDict = [[NSMutableDictionary alloc] init];
	[loginDict setObject:[NSNumber numberWithBool:NO] forKey:LOGIN_STATUS];
	[loginDict setObject:[NSNumber numberWithInt:kFacebookLogin] forKey:LOGIN_TYPE];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:loginDict];
	[loginDict release];
}


- (void)sessionDidLogout:(FBSession*)session {
	NSLog(@"Login sessionDidLogout");
	
	[self saveFriendsToStoreinArray:savedFBFriends forUser:uid];
	
	[savedFBFriends release];
	savedFBFriends = nil;
	
	[self setDownloadedFBFriends:NULL];
	
	[uid release];
	uid = nil;
	
	NSMutableDictionary * loginDict = [[NSMutableDictionary alloc] init];
	[loginDict setObject:[NSNumber numberWithBool:NO] forKey:LOGIN_STATUS];
	[loginDict setObject:[NSNumber numberWithInt:kFacebookLogin] forKey:LOGIN_TYPE];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:loginDict];
	[loginDict release];
}


#pragma mark -
#pragma mark FBRequestDelegate
- (void)requestLoading:(FBRequest*)request {
	NSLog(@"Request requestLoading :: %@",request);
}


- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response {
	NSLog(@"Request didReceiveResponse :: %@",response);
}


- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	NSLog(@"Request didFailWithError :: %@",error);
}


- (void)request:(FBRequest*)request didLoad:(id)result {	
	if( receivedFriendsUID == NULL ) {
		receivedFriendsUID = [[NSMutableArray alloc] initWithArray:result];
		NSString * inuid = [NSString stringWithString:@""];
		
		for( NSDictionary * str in receivedFriendsUID ) {
			inuid = [inuid stringByAppendingFormat:@"%@,",[str objectForKey:@"uid"]];
		}
		
		NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"first_name,last_name,pic_square",@"fields",inuid,@"uids",nil];
		FBRequest * fbRequest = [FBRequest requestWithDelegate:self];
		[fbRequest call:@"users.getInfo" params:params];
	}
	else {		
		[self getSavedFBFriends];
		downloadedFBFriends = [[NSMutableArray alloc] init];
		for( NSMutableDictionary * friendsDict in result ) {
			SMFBFriendsData * friendsData = [[SMFBFriendsData alloc] init];
			NSString * friendsName = [NSString stringWithFormat:@"%@ %@",[friendsDict objectForKey:@"first_name"],[friendsDict objectForKey:@"last_name"]];
			[friendsData setFriendsName:friendsName];
			[friendsData setUid:[friendsDict objectForKey:@"uid"]];		
			[friendsData setIsSelected:NO];
			NSString * temp = [friendsDict valueForKey:@"pic_square"];
			if( (NSNull *)temp != [NSNull null] ) {
				NSURL * urlWithString = [NSURL URLWithString:temp];
				if( urlWithString != NULL )
					[friendsData setFriendsImageURL:urlWithString];
			}			
			
			BOOL alreadyAdded = NO;
			if( savedFBFriends != nil ) {
				for( SMFBFriendsData * savedfbFriend in savedFBFriends ) {
					if( [[savedfbFriend uid] isEqualToString:[friendsData uid]] ){
						alreadyAdded = YES;
						break;
					}
				}
			}
			if( alreadyAdded == NO ) {
				[downloadedFBFriends addObject:friendsData];
			}
			
			[friendsData release];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOADED_FB_FRIENDS" object:nil];
	}
}

#pragma mark -
#pragma mark Friends Country selected
- (void) didSelectFriendsCountry:(NSNotification *)notification {
	[self saveFriendsToStoreinArray:savedFBFriends forUser:uid];
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[dataReceived appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self showLoginFailerAlertWithError:[error localizedDescription]];
	[dataReceived release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	NSString * receivedXML = [[NSString alloc] initWithData:dataReceived encoding:NSUTF8StringEncoding];
	NSLog(@"%@",receivedXML);
	XMLUtil * xmlUtil = [[XMLUtil alloc] initWithXml:receivedXML];
	XMLXpathObject * lc_xpath = [xmlUtil evaluateXpath:[@"/" stringByAppendingString:@"xml"]];
	XMLNode * allNodes = [[lc_xpath nodes] lastObject];
	XMLNode * node = [allNodes childNamed:@"error"];
	if( node == NULL ) {
		[self removeAlert];
		[[NSUserDefaults standardUserDefaults] setObject:tempEmail forKey:@"SCORE_TONES_EMAIL"];
		
		NSMutableDictionary * loginDict = [[NSMutableDictionary alloc] init];
		[loginDict setObject:[NSNumber numberWithBool:YES] forKey:LOGIN_STATUS];
		[loginDict setObject:[NSNumber numberWithInt:kScoretoneLogin] forKey:LOGIN_TYPE];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:loginDict];
		[loginDict release];
	}
	else {
		NSString * errorMesg = [node value];
		[self showLoginFailerAlertWithError:errorMesg];
		NSMutableDictionary * loginDict = [[NSMutableDictionary alloc] init];
		[loginDict setObject:[NSNumber numberWithBool:NO] forKey:LOGIN_STATUS];
		[loginDict setObject:[NSNumber numberWithInt:kScoretoneLogin] forKey:LOGIN_TYPE];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:loginDict];
		[loginDict release];
	}	
	
	[dataReceived release];
}


- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if( savedFBFriends != nil ){
		[savedFBFriends release];
	}
	[super dealloc];
}

@end
