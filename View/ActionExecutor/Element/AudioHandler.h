#import <AVFoundation/AVFoundation.h>

@interface AudioHandler : AVAudioPlayer

@property(assign) float fadeDelay;
@property(assign) float fadeToVolume;
@property(assign) float fadeOverDuration;

#pragma mark - Class Methods

+(NSOperationQueue *) audioCrossFadeQueue;

+(void) setupAudioSession;

@end
