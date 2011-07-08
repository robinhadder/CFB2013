//
//  SMUserData.h
//  SuperMetric
//
//  Created by codewalla soft on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMFBFriendsData.h"
#import "FBConnect.h"
#import "SMTeamsManager.h"

typedef enum {
	kNoLogin = 0,
	kFacebookLogin,
	kScoretoneLogin
} LoginType;

@interface SMUserData : NSObject <FBSessionDelegate,FBDialogDelegate, FBRequestDelegate> {
	FBSession * fbSession;
	LoginType loginType;
	
	NSString * uid;
	NSMutableArray * savedFBFriends;
	NSMutableArray * downloadedFBFriends;
	NSMutableArray * receivedFriendsUID;
	
	
	NSURLConnection * connection;
	NSMutableData * dataReceived;
}
@property (nonatomic, retain) NSMutableArray * downloadedFBFriends;
@property (nonatomic, readonly) LoginType loginType;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, readonly) FBSession * fbSession;

+(SMUserData *)sharedInstance;

- (void) loginIntoScoreWithEmail:(NSString *)emailID  scoretoneUserName:(NSString *) userName andPassword:(NSString *)password;
- (void) verifyUserWithEmail:(NSString *)emailID  andPassword:(NSString *)password  isSignInByUserName:(BOOL)signInByUserName;
- (void) logoutFrom:(LoginType)loginType;
- (NSString *) getScoreTonesEmail;
- (void) loginIntoFaceBook;
- (void) openPermissionDialogBox;
- (NSArray *) getSavedFBFriends;
- (BOOL) downloadFBFriends;

- (void) saveFriend:(SMFBFriendsData *)fbUSerData ;
- (void) deleteFriend:(SMFBFriendsData *)friendData;
- (BOOL) addFacebookUser:(NSString *)uuid;

@end


