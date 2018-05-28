#import "AudioHandler.h"
#import "MXAudioPlayerFadeOperation.h"

@implementation AudioHandler

- (void) fade
{
    MXAudioPlayerFadeOperation *fadeOperation = [[MXAudioPlayerFadeOperation alloc] initFadeWithAudioPlayer:self toVolume:self.fadeToVolume overDuration:self.fadeOverDuration];
    [fadeOperation setDelay: self.fadeDelay];
    [[AudioHandler audioCrossFadeQueue] addOperation:fadeOperation];
}

- (void) fadeToStop
{
    MXAudioPlayerFadeOperation *fadeOperation = [[MXAudioPlayerFadeOperation alloc] initFadeWithAudioPlayer:self toVolume:self.fadeToVolume overDuration:self.fadeOverDuration];
    [fadeOperation setDelay: self.fadeDelay];
    fadeOperation.stopAfterFade = YES;
    [[AudioHandler audioCrossFadeQueue] addOperation:fadeOperation];
}


#pragma mark - Class Methods


NSOperationQueue *audioFaderQueue;

+(NSOperationQueue *) audioCrossFadeQueue
{
    if (! audioFaderQueue) {
        audioFaderQueue = [[NSOperationQueue alloc] init];
        [audioFaderQueue setMaxConcurrentOperationCount:1];
    }
    return audioFaderQueue;
}


// http://stackoverflow.com/questions/13390039/playing-a-sound-in-ios-pauses-background-music
+(void) setupAudioSession {
    // AVAudioSessionCategoryOptionMixWithOthers is the key point
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError* categoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&categoryError];
    NSError* activeError = nil;
    [session setActive:YES error:&activeError];
}


@end
