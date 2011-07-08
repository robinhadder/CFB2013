#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@protocol SoundManagerDelegate;

@interface SoundManager : NSObject<AVAudioPlayerDelegate>
{
	id<SoundManagerDelegate> delegate;
	
	NSString *strFileName;
	float fFileDelay;
	
	AVAudioPlayer * ptrAVAudioPlayer;	
	AVAudioPlayer * ptrAVPlayerForMusicalLoop;
	
	BOOL bRunning;
	NSTimer *timer;
	
	NSThread * fadeMusicalLoopThread;
	
}
@property(nonatomic, assign) id<SoundManagerDelegate> delegate;
@property(readonly, retain) AVAudioPlayer *ptrAVAudioPlayer;
@property(readonly, retain) AVAudioPlayer *ptrAVPlayerForMusicalLoop;

+(SoundManager *)sharedInstance;

- (void)playSound:(NSString *)fileName delay:(float)delay;
- (void)play:(NSTimer *)theTimer;
- (void)playMusicalLoopWithFile:(NSString *)filename;
//- (void)playMusicalLoopWithFade:(NSString *)fileName;
- (void)stopMusicalLoop;
- (int)randomNumberTill:(int)number;
- (void)stopMusicalLoopWithFade;
- (void)fadeOutMusicalLoop;
- (void) stopSoundManager;

@end

@protocol SoundManagerDelegate

- (void)soundManager:(SoundManager *)SoundManager didBeginPlaying:(NSString *)fileName;
- (void)soundManager:(SoundManager *)SoundManager didFinishPlaying:(NSString *)fileName;

@end