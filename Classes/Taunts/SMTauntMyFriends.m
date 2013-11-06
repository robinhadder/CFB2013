    //
//  SMTauntMyFriends.m
//  SuperMetric
//
//  Created by codewalla soft on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMTauntMyFriends.h"
#import "SMUserData.h"
#import "XMLUtil.h"
#import "XMLNode.h"

@interface SMTauntMyFriends()
- (void) storeTauntMsgToDB; 
@end

@implementation SMTauntMyFriends

@synthesize tauntTextView;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTauntMessage:) name:@"SEND_TAUNT_MSG" object:nil];
	
	CGRect frame = CGRectMake(200, 0, 200, 44);
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor yellowColor];
	self.navigationItem.titleView = label;
	label.text = NSLocalizedString(@"Taunt",@"Taunt");
	
	//[[[self navigationItem] backBarButtonItem] setTitle:NSLocalizedString(@"Select Friends",@"Select Friends")];
	
	[automaticLinkLabel setText:@"Also show this taunt on ScoreTones.com and add a link on Facebook."];
	[hitThemButton setTitle:NSLocalizedString(@"Hit them...",@"Hit them...") forState:UIControlStateNormal];
	//[editButton setTitle:NSLocalizedString(@"Edit",@"Edit") forState:UIControlStateNormal];
	//[tauntAddMoreFriendsLabel setText:NSLocalizedString(@"Add more friends",@"Add more friends")];
	tauntTextView = [[UITextView alloc] init];
	
	savedFriends = [[SMUserData sharedInstance] getSavedFBFriends];
	if( savedFriends == NULL ) {
		savedFriends = [[NSMutableArray alloc] init];
	}
		
	[smtableView setBackgroundColor:[UIColor clearColor]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddAFriendAtIndex:) name:ADDED_FB_FRIEND object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteAFriendAtIndex:) name:DELETED_FB_FRIEND object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectFriendsCountry:) name:FRIENDS_COUNTRY_SELECTED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:LOGIN_NOTIFICATION object:nil];
	
	autoAppend = false;
	requestCount = 0;
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Message" style:UIBarButtonItemStyleBordered target:self action:@selector(DeleteButtonAction:)];
	[self.navigationItem setLeftBarButtonItem:backButton];	
	[backButton release];
	
}

-(IBAction) DeleteButtonAction:(id)sender {
	[self.navigationController popViewControllerAnimated:NO];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark -
#pragma mark TabelViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rowCount;
	if(!section)
		rowCount = [savedFriends count];
	else
		rowCount = 1;
	return rowCount;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSString* strSectionHeader;
	if(section == 0){
		strSectionHeader = NSLocalizedString(@"Select Friends",@"Select Friends");
	}
	else {
		strSectionHeader = NSLocalizedString(@"Import from Facebook",@"Import from Facebook");
	}
	return strSectionHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 0 ){
		static NSString* cellIdentifier = @"SMTauntMyFriendsTableCell";
		SMFriendsTableCell * cell =  (SMFriendsTableCell *)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier];
		if( cell == nil ){
			[[NSBundle mainBundle] loadNibNamed:@"SMTauntMyFriTableCell" owner:self options:nil];
			cell = tauntMyfriTableCell;
			tauntMyfriTableCell = nil;
		}
		[cell setFriendsData:[savedFriends objectAtIndex:[indexPath row]]];
		return cell;
	}
	else {
		static NSString *  cellIdentifier2 = @"SMTauntAddMyFriendsTableCell";
		SMAddFriendsTableCell* cell = (SMAddFriendsTableCell*)[tableView1 dequeueReusableCellWithIdentifier:cellIdentifier2];
		if(cell == nil ){
			[[NSBundle mainBundle] loadNibNamed:@"SMTauntAddMyFriTableCell" owner:self options:nil];
			cell =tauntAddMyFriTableCell;
			tauntAddMyFriTableCell = nil;
		}
		[[cell addMoreFriendsLabel] setText:NSLocalizedString(@"Add more friends",@"Add more friends")];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"index path:%@",indexPath);
	if( [indexPath section] == 1 ){
		addressBook = [[SMAddressBook alloc] initWithNibName:@"SMAddressBook" bundle:[NSBundle mainBundle]];
		[[self navigationController] pushViewController:addressBook animated:YES];
		[addressBook release];
	}
	else if([indexPath section] == 0) {
		SMFriendsTableCell * cell =  (SMFriendsTableCell *)[tableView1 cellForRowAtIndexPath:indexPath];
		if([[cell friendInfo] isSelected]) {
			[[cell friendsName] setTextColor:[UIColor grayColor]];
			[[cell friendInfo] setIsSelected:NO];
			[[cell selectDeselectButton] setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
		}
		else {
			[[cell friendsName] setTextColor:[UIColor blackColor]];
			[[cell friendInfo ] setIsSelected:YES];
			[[cell selectDeselectButton] setImage:[UIImage imageNamed:@"tickSelected.png"] forState:UIControlStateNormal];
			
		}
	//	[[cell selectDeselectButton] setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateNormal];
		
	}
}

#pragma mark -
#pragma mark Private actions

- (void) sendTauntMessage:(NSNotification *)notification {
	//NSString * tauntText = [tauntTextView text];
	NSLog(@"TEST USER ID :: %d",userID);
	[self storeTauntMsgToDB];
}
	
- (void) storeTauntMsgToDB {
		NSString  * post;  
		post = @"userID=";
		//NSString * loginID = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
	
	    post = [post stringByAppendingString:[NSString stringWithFormat:@"%d", userID]];
		post = [post stringByAppendingString:@"&message="];
		post = [post stringByAppendingString:[tauntTextView text]];
	    NSLog(@"taunt urlString:%@",post);
	
	///
	//NSString * postStringData = [NSString stringWithString:_X_DATA];//:_X_DATA,@"com.codewalla.Infunitum",@"77a546737b18a62c6c16485b7e7415ef19fc02aa"];
	NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]; 
	
	NSMutableURLRequest * postRequest = [[NSMutableURLRequest alloc] init];
	NSString * str = [NSString stringWithFormat:STORE_TAUNT_TO_DB];
	NSLog(@"TEST : TAUNT URL %@", str);
	[postRequest setURL:[NSURL URLWithString:str]];
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setHTTPBody:postData];
	
    dataReceived = [[NSMutableData alloc] init];
	postConnection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];// sendSynchronousRequest:postRequest returningResponse:nil error:&error];
	////
}

#pragma mark -
#pragma mark Button Actions
-(IBAction) giveItToThemButtonAction:(id)sender {
	BOOL isFriendSelected = NO;
	
	//if (signInByUserName == FALSE) {
		[ self getUserIDForCurrentUser];  
	//}
	
	
	for( SMFBFriendsData * friendsData in savedFriends ){
		if( [friendsData isSelected] == YES ){
			isFriendSelected = YES;
			break;
		}
	}
	
	if( isFriendSelected == NO ){
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Please select a friend to taunt.",@"Please select a friend to taunt.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
		
	
	[self checkUploadPermission];
//	if([[[SMUserData sharedInstance] fbSession] isConnected]){
//		[self checkUploadPermission];
//	}
//	else {
//		[[SMUserData sharedInstance] loginIntoFaceBook];
//		[self checkUploadPermission];
//	}
	NSString * tauntText = [tauntTextView text];

	BOOL sendTauntToSelf = [[NSUserDefaults standardUserDefaults] boolForKey:SEND_TAUNT_MESSAGE];
	NSString * scoreTonesEmailId = [[SMUserData sharedInstance] getScoreTonesEmail];
	
	if( sendTauntToSelf == YES && scoreTonesEmailId != nil) {		
		MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc] init];
		NSArray * toRecipients = [[NSArray alloc] initWithObjects:scoreTonesEmailId,nil];
		[mailComposer setToRecipients:toRecipients];
		[mailComposer setSubject:@"Taunt Message"];
		[mailComposer setMessageBody:tauntText isHTML:NO];
		[mailComposer setMailComposeDelegate:self];
		[self presentModalViewController:mailComposer animated:YES];
		
		[toRecipients release];
	}
	
	tauntFriends = [[SMTauntFriends alloc] initWithNibName:@"SMTauntFriends" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:tauntFriends animated:YES];
	[tauntFriends release];
	
	//[self storeTauntMsgToDB];
	//NSString * scoreTonesEmailID = [[SMUserData sharedInstance] getScoreTonesEmail];
	//if( scoreTonesEmailID != nil && autoAppend ) {
	//NSString * urlString = [@"http://scoretones.com/users/" stringByAppendingFormat:@"%d",userID];
	//tauntText = [tauntText stringByAppendingString:urlString];
	//	}
	
}



- (IBAction) addFriendsButtonAction:(id)sender {
	NSLog(@"DEV TEST :: addFriendsButtonAction ");
	addressBook = [[SMAddressBook alloc] initWithNibName:@"SMAddressBook" bundle:[NSBundle mainBundle]];	
	[self.navigationController pushViewController:addressBook animated:YES];
	[addressBook release];
}

- (IBAction) cancelButtonAction:(id)sender{
	NSLog(@" DEV TEST :: cancelButtonAction ");
}
- (IBAction) editFriendListButtonAction:(id)sender {
	friends = [[SMFriends alloc] initWithNibName:@"SMFriends" bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:friends animated:YES];
	[friends release];
}

- (IBAction) txtViewReturnClicked:(id)sender{
	NSLog(@"Inside txtViewReturnClicked");
}

- (IBAction) autoAppendButtonAction:(id)sender {
	autoAppend = !autoAppend;
	if( autoAppend == TRUE ) {
		[autoAppendLink setImage:[UIImage imageNamed:@"checkBoxSelected.png"] forState:UIControlStateNormal];
	}
	else {
		[autoAppendLink setImage:[UIImage imageNamed:@"checkBoxDeselected.png"] forState:UIControlStateNormal];
	}
}


#pragma mark -
#pragma mark SMUserFBFriendsDelegate
- (void) didAddAFriendAtIndex:(NSNotification *)notification {
	NSArray * savedFriendst = [[SMUserData sharedInstance] getSavedFBFriends];
	if( [savedFriends count] == [savedFriendst count] - 1 ) {	
		savedFriends = savedFriendst;
		NSIndexPath * indexPath = [[notification object] objectForKey:@"SAVE_INDEX_PATH"];
		NSArray * indexpaths = [[NSArray alloc] initWithObjects:indexPath,nil];
		
		[smtableView beginUpdates];
		[smtableView insertRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationFade];
		[smtableView endUpdates];
		
		[indexpaths release];
	}
	else {
		savedFriends = savedFriendst;
		[smtableView reloadData];
	}
	
}

- (void) didDeleteAFriendAtIndex:(NSNotification *)notification {
	NSArray * savedFriendst = [[SMUserData sharedInstance] getSavedFBFriends];
	if( [savedFriendst count] == [savedFriends count] -1 ) {
		savedFriends = savedFriendst;
		NSIndexPath * indexPath = [[notification object] objectForKey:@"DELETE_INDEX_PATH"];
		NSArray * indexpaths = [[NSArray alloc] initWithObjects:indexPath,nil];
		
		[smtableView beginUpdates];
		[smtableView deleteRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationFade];
		[smtableView endUpdates];
		
		[indexpaths release];
	}
	else {
		savedFriends = savedFriendst;
		[smtableView reloadData];
	}
	
}

- (void) didSelectFriendsCountry:(NSNotification *)notification {
	SMFBFriendsData * friend = (SMFBFriendsData *)[notification object];
	SMFriendsTableCell * upFriendsTableCell = (SMFriendsTableCell *)
	[smtableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[savedFriends indexOfObject:friend] inSection:0]];
	
	[[upFriendsTableCell countryLiked] setText:[friend countryLiked]];
}

- (void) userDidLogin:(NSNotification *)notification {
	NSDictionary * loginstatus = [notification object];
	LoginType loginType = [[loginstatus objectForKey:LOGIN_TYPE] intValue];
	if( loginType == kFacebookLogin ) {
		BOOL loginStatus = [[loginstatus objectForKey:LOGIN_STATUS] boolValue];				
		if( loginStatus == YES ) {
			if( loginDidSuccedOnce == NO ) {
				savedFriends = [[SMUserData sharedInstance] getSavedFBFriends];
				[smtableView reloadData];
				loginDidSuccedOnce = YES;
			}
		}
		else {		
			loginDidSuccedOnce = NO;
			savedFriends = [[NSArray alloc] init];
			[smtableView reloadData];
		}
	}
}

#pragma mark -
#pragma mark UIMailComposerViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissModalViewControllerAnimated:YES];
	if( error != nil ) {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}


#pragma mark -
#pragma mark FBRequestDelegate
- (void)request:(FBRequest*)request didLoad:(id)result{
	NSLog(@"Request didLoad :: %@",result);
	int stringLenth = [result length];
	NSLog(@"strLength:%d",stringLenth);
	if(stringLenth == 0 || stringLenth == 1 ){
		if([result intValue] == 1) {
			[self postMessageToFriendsWall];
		}
		else {
			FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
			dialog.delegate = self;
			dialog.permission = @"publish_stream";
			[dialog show];
		}
	}
	else {
		requestCount-=1;
		//To be executed only when last request for message upload is completed.So need to write such condition over here
		if(requestCount == 0) {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your message has been posted to your friend's wall(s)",@"Your message has been posted to your friends’ wall(s)") message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	
	
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	NSLog(@"Request with error :: %@",error);
	requestCount-=1;
}


#pragma mark -
#pragma mark FBDialogDelegate

- (void)dialogDidSucceed:(FBDialog*)dialog {
	[self postMessageToFriendsWall];
}


	
- (void) postMessageToFriendsWall {
	NSString* sender = [[SMUserData sharedInstance] uid];
	NSArray* arrayOfFriends = [[SMUserData sharedInstance] getSavedFBFriends];
	
	NSString * tauntText = [tauntTextView text];
	NSString * scoreTonesEmailID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
	if( scoreTonesEmailID != nil && autoAppend ) {
			NSString * urlString = [@" http://scoretones.com/users/" stringByAppendingString:scoreTonesEmailID];
		tauntText = [tauntText stringByAppendingString:urlString];
	}
	
	for( SMFBFriendsData * friendsData in arrayOfFriends ) {
		if([friendsData isSelected]) {
			requestCount+=1;
			NSString* userId = [friendsData uid];
			NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:tauntText,@"message",sender,@"uid",userId,@"target_id",nil];
			fbRequest = [[FBRequest requestWithDelegate:self] retain];
			[fbRequest call:@"stream.publish" params:params];
		}	
	}
}

-(void) getUserIDForCurrentUser{
	NSString * getUserIDURLString = nil;
	isUserIDURL = TRUE;
	if (signInByUserName == TRUE) {
		getUserIDURLString = GET_USERID_WITH_USERNAME;
	}
	else{
		getUserIDURLString = GET_USERID_WITH_EMAIL_ID;
	}
	
	NSString * userLoginType = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_ID];
	getUserIDURLString = [NSString stringWithFormat:getUserIDURLString,userLoginType];
	NSLog(@"getUserIDURLString LIKE::%@",getUserIDURLString);
	
	if( getUserIDURLString != nil ) {
		NSURL * statusURL = [NSURL URLWithString:getUserIDURLString];
		NSURLRequest * therequest = [NSURLRequest requestWithURL:statusURL];
		dataReceived = [[NSMutableData alloc] init];
		teamsConnection = [[NSURLConnection alloc] initWithRequest:therequest delegate:self];
		[teamsConnection start];
	}
}

- (void) checkUploadPermission {
//	if([[[SMUserData sharedInstance] fbSession] isConnected]) {
		NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"publish_stream",@"ext_perm",nil];
		fbRequest = [[FBRequest requestWithDelegate:self] retain];
		[fbRequest call:@"users.hasAppPermission" params:params];
//	}
}


-(void)touchesEnded:(NSSet *)touches withEvent: (UIEvent *)event
{
	if(tauntTextView)
		[tauntTextView resignFirstResponder];
}	

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    dataReceived = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[dataReceived appendData:data];
}

- (void)connection:(NSURLConnection *)connection  didFailWithError:(NSError *)error{
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * jsonString = [[NSString alloc] initWithData:dataReceived  encoding:NSUTF8StringEncoding];
	//NSDictionary * stories = [jsonString JSONValue];
	if (isUserIDURL == TRUE) {
		userID = [self createUserDetailsWithDataReceived:jsonString]; 
		NSLog(@"************%d",userID);
		isUserIDURL = FALSE;
		[[NSUserDefaults standardUserDefaults] setInteger:userID forKey:@"UserID"];
		
		int scoreTonewTauntDisplayText = [[NSUserDefaults standardUserDefaults]  integerForKey:@"UserID"];
		NSLog(@"user id at link page:%d",scoreTonewTauntDisplayText);
		NSString * urlString = [@"http://scoretones.com/users/" stringByAppendingFormat:@"%d",scoreTonewTauntDisplayText];
		NSString *scoreTonesEmailID = [[NSUserDefaults standardUserDefaults]  objectForKey:LOGIN_ID];
		if([[NSUserDefaults standardUserDefaults] boolForKey:@"singInUserName"] == 1) {
			urlString = [@"http://scoretones.com/users/" stringByAppendingString:scoreTonesEmailID];
		}
		[[tauntFriends tauntLinkTextField ] setText:urlString]; 
													 
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SEND_TAUNT_MSG" object:nil];
	}
	
}

- (int)createUserDetailsWithDataReceived:(NSString *)jsonString {
	int currentUserID;
	XMLUtil * xmlUtil = [[XMLUtil alloc] initWithXml:jsonString];
	XMLXpathObject * lc_xpath = [xmlUtil evaluateXpath:[@"/" stringByAppendingString:@"xml"]];
	XMLNode * allTeamsNode = [[lc_xpath nodes] lastObject];
	NSMutableArray * allTeamsArray = [[NSMutableArray alloc] initWithArray:[allTeamsNode childrenNamed:@"item"]];
	
	for (XMLNode * node in allTeamsArray ){
		currentUserID = [[[node childNamed:@"userID"] value] intValue];
	}	
		return currentUserID;
}

- (void)dealloc {
	NSLog(@"%@ Released",[self class]);
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if( fbRequest != nil ) {
		[fbRequest cancel];
		[fbRequest release];
	}
	
    [super dealloc];
}


@end
