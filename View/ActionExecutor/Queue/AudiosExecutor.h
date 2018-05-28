#import "QueueExecutorBase.h"

@class AudioHandler;

@interface AudiosExecutor : QueueExecutorBase

@property (assign) BOOL disableAudio;
@property (strong, readonly) NSMutableDictionary* systemSounds;
@property (strong, readonly) NSMutableDictionary* audiosPlayers;

@property(copy) void(^playFinishAction)(AudioHandler*);


-(void) clearCaches;

@end
