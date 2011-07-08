#import "SoundManager.h"

@implementation SoundManager

@synthesize delegate;
@synthesize ptrAVAudioPlayer;
@synthesize ptrAVPlayerForMusicalLoop;
static SoundManager * sharedInstance = nil;

+(SoundManager *)sharedInstance {
	@synchronized( self ) {
		if( sharedInstance == nil ) {
			sharedInstance = [[SoundManager alloc] init];
		}
	}
	return sharedInstance;
}

- (id)init {
	if(self = [super init]){
		ptrAVAudioPlayer = nil;
		ptrAVPlayerForMusicalLoop = nil;
		bRunning = YES;
		timer = nil;  
	}
	return self;
}

- (void) playMusicalLoopWithFile:(NSString *)filename {
 @try 
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"aifc"];
		NSURL *url = [NSURL fileURLWithPath:path];
		ptrAVPlayerForMusicalLoop = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		[ptrAVPlayerForMusicalLoop setDelegate:self];
		[ptrAVPlayerForMusicalLoop setNumberOfLoops:-1];
		[ptrAVPlayerForMusicalLoop setVolume:BACKGROUND_MUSIC_VOLUME];
		[ptrAVPlayerForMusicalLoop play];
	}
	@catch (NSException * e)
	{
		NSLog(@"%@ Sound file not present:%@ , %@",strFileName, [e name], [e reason] );
    }
}



- (void)stopMusicalLoopWithFade {
	fadeMusicalLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(fadeOutMusicalLoop) object:nil];
	[fadeMusicalLoopThread start];
}

- (void)fadeOutMusicalLoop {
	//NSLog(@"Fade out of musical loop started");
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	while ([ptrAVPlayerForMusicalLoop volume]) {
		float volume = [ptrAVPlayerForMusicalLoop volume] - 0.25f;
		[ptrAVPlayerForMusicalLoop setVolume:volume];
		[NSThread sleepForTimeInterval:0.125f];
	}
	
	[self stopMusicalLoop];
	
	[pool release];
	[fadeMusicalLoopThread release];
	//NSLog(@"Fade out of musical loop ended");
}

- (void)stopMusicalLoop {
	if(ptrAVPlayerForMusicalLoop){
		if([ptrAVPlayerForMusicalLoop isPlaying])
			[ptrAVPlayerForMusicalLoop stop];
		
		[ptrAVPlayerForMusicalLoop release];
		ptrAVPlayerForMusicalLoop = nil;
	}
}

- (void)play:(id)in_sender {
	[timer invalidate];
	timer = nil;
	
	@try {
		NSString *path = [[NSBundle mainBundle] pathForResource:strFileName ofType:nil];
		NSURL *url = [NSURL fileURLWithPath:path];
			
		ptrAVAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		[ptrAVAudioPlayer setDelegate:self];
		[ptrAVAudioPlayer setVolume:SFX_VOLUME];
	
		[ptrAVAudioPlayer play];
		if(delegate){
			[delegate soundManager:self didBeginPlaying:strFileName];
		}

		bRunning = YES;	
	}
	@catch(NSException *e){
		NSLog(@"%@ Sound file not present:%@ , %@",strFileName, [e name], [e reason] );
	}		
}


- (void)playSound:(NSString *)fileName delay:(float)delay
{
	//[ fileName retain ];
	@try {
		
		//NSLog(@"Sound file name : %@, delay : %f",fileName,delay);
		if(ptrAVAudioPlayer!=nil){
			if([ptrAVAudioPlayer isPlaying])
				[ptrAVAudioPlayer stop];
			
			[ptrAVAudioPlayer release];
			ptrAVAudioPlayer = nil;
		}
		
		if(strFileName!=nil) {
			[strFileName release];
			strFileName = nil;
		}
		
		if(timer) {
			[timer invalidate];
		}
		
		strFileName = [[NSString alloc] initWithString:fileName];
		fFileDelay = delay;
		timer = [NSTimer scheduledTimerWithTimeInterval:fFileDelay target:self selector:@selector(play:) userInfo:nil repeats:NO];
	}
	@catch (NSException * exception){
		NSLog(@"ptrAVAudioPlayer not found: %@ ,%@", [exception name], [exception reason]);
	}	
	//[ fileName release ];
}



- (int)randomNumberTill:(int)number {
	unsigned int rand = arc4random();
	int num = ( rand % number );
	return num;
}
		
- (void)dealloc {
	NSLog(@" *********** %@ dealloced",self);
	
	delegate = nil;
	
	if(timer){
		[timer invalidate];
	}
	
	if(ptrAVPlayerForMusicalLoop)	{
		[ptrAVPlayerForMusicalLoop stop];
		[ptrAVPlayerForMusicalLoop release];
	}
	
	if(ptrAVAudioPlayer != nil ) {
		[ptrAVAudioPlayer stop];
		[ptrAVAudioPlayer release];
	}
	
	if( strFileName )
	{
		[ strFileName release ];
	}
	sharedInstance = nil;	
	[super dealloc ];
}

#pragma mark == AVAudioPlayerDelegate ==
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	@try
	{
		if([player isEqual:ptrAVAudioPlayer] && flag == YES){
			if(delegate){
				[delegate soundManager:self didFinishPlaying:strFileName];
			}
		}
	}
	@catch (NSException *exception) 
	{
		NSLog(@"Sound finished %@ , %@:", [exception name] , [exception reason]);
	}
}

- (void) stopSoundManager {
	[ptrAVAudioPlayer stop];
}

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
//	if([player isEqual:ptrAVPlayerForMusicalLoop]){
//		NSLog(@"Interruption reecived and playing bg music loop");
//		if([player isPlaying]){
//			[player pause];
//		}
//	}
} 

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player {
//	if([player isEqual:ptrAVPlayerForMusicalLoop]){
//		NSLog(@"Interruption reecived and playing bg music loop");
//	}
}

@end
