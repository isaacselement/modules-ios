#import "AudiosExecutor.h"

#import "AudioHandler.h"
#import "NSArray+Additions.h"
#import "KeyValueHelper.h"

@interface AudiosExecutor() <AVAudioPlayerDelegate>

@end


@implementation AudiosExecutor

@synthesize systemSounds;
@synthesize audiosPlayers;


-(void)execute:(NSDictionary *)config objects:(NSArray *)objects values:(NSArray *)values times:(NSArray *)times durationsRep:(NSMutableArray *)durationsQueue beginTimesRep:(NSMutableArray *)beginTimesQueue
{
    id value = [values firstObject];
    if (!value) value = config[@"values"];
    
    double inactivityTime = [[times firstObject] doubleValue];
    if (inactivityTime > 0) {
        [self performSelector:@selector(playAudioDelay:) withObject:@[config, value] afterDelay:inactivityTime];
    } else {
        [self playAudio: config value:value];
    }
}

-(void) playAudioDelay: (NSArray*)configValue
{
    [self playAudio: [configValue firstObject] value:[configValue lastObject]];
}

-(void) playAudio: (NSDictionary*)config value:(id)value 
{
    if (self.disableAudio) return;
    if (![value isKindOfClass:[NSString class]]) return;
    
    BOOL isSystemSound = [config[@"isSystemSound"] boolValue];
    
    if (isSystemSound) {
        
        if (!systemSounds) {
            systemSounds = [NSMutableDictionary dictionary];
        }
      
#if __LP64__
        SystemSoundID soundID = [systemSounds[value] unsignedIntValue];
#else
        SystemSoundID soundID = [systemSounds[value] unsignedLongValue];
#endif
        if (soundID == 0) {
            
            NSString* path = [KeyValueHelper getResourcePath: value];
            NSURL* soundURL = [NSURL fileURLWithPath:path];
            AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)soundURL, &soundID);
            
#if __LP64__
            NSNumber* soundIDNumber = [NSNumber numberWithUnsignedInt:soundID];
#else
            NSNumber* soundIDNumber = [NSNumber numberWithUnsignedInteger:soundID];
#endif
            [systemSounds setObject:soundIDNumber forKey:value];
            
        }
        AudioServicesPlaySystemSound(soundID);
        
        
    } else {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [AudioHandler setupAudioSession];
        });
        
        // get the AVAudioPlayer instance
        if (!audiosPlayers) {
            audiosPlayers = [NSMutableDictionary dictionary];
        }
        AudioHandler* audio_player = [audiosPlayers objectForKey: value];
        if (! audio_player) {
            NSString* path = [KeyValueHelper getResourcePath: value];
            NSError* error = nil;
            audio_player = [[AudioHandler alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error: &error];
            if (error) return;
            audio_player.delegate = self;
            [audiosPlayers setObject: audio_player forKey:value];
            [audio_player prepareToPlay];
        }
        
        // the AudioHandler properties values
        if (config[@"player"]) {
            [[KeyValueHelper sharedInstance] setValues: config[@"player"] object:audio_player];
        }
        
        // the AudioHandler selectors
        SEL selector = @selector(play);
        if (config[@"selector"]) {
            selector = NSSelectorFromString(config[@"selector"]);
        }
        [audio_player performSelectorInBackground:selector withObject:nil];
    }
}

-(void) clearCaches
{
    // clear systemSounds
    for (NSString* value in systemSounds) {
#if __LP64__
        SystemSoundID soundID = [systemSounds[value] unsignedIntValue];
#else
        SystemSoundID soundID = [systemSounds[value] unsignedLongValue];
#endif
        AudioServicesDisposeSystemSoundID(soundID);
    }
    [systemSounds removeAllObjects];
    
    // clear audiosPlayers
    for (NSString* value in audiosPlayers) {
        AudioHandler* audioPlayer = audiosPlayers[value];
        [audioPlayer stop];
    }
    [audiosPlayers removeAllObjects];
}


#pragma mark - AVAudioPlayerDelegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.playFinishAction) {
        self.playFinishAction((AudioHandler*)player);
    }
}


@end
