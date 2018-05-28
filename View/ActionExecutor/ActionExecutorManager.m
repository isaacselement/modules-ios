#import "ActionExecutorManager.h"
#import "ActionExecutorBase.h"

@implementation ActionExecutorManager
{
    NSMutableDictionary* executors;
}

- (id)init {
    self = [super init];
    if (self) {
        executors = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) registerActionExecutor: (NSString*)action executor:(ActionExecutorBase*)executor {
    if (executor) {
        [executors setObject: executor forKey:action];
    }
}

-(void) removeActionExecutor: (NSString*)action {
    [executors removeObjectForKey: action];
}

-(NSDictionary*) getActionExecutors
{
    return [NSDictionary dictionaryWithDictionary: executors];
}

-(ActionExecutorBase*) getActionExecutor: (NSString*)action {
    return [executors objectForKey: action];
}

-(void) runActionExecutors: (id)actionsConfigs onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes {
    
    // NSArray is ordered , but NSDictionary is not.
    if ([actionsConfigs isKindOfClass:[NSArray class]]) {
        
        for (NSInteger i = 0; i < [actionsConfigs count]; i++) {
            [self runActionExecutor: actionsConfigs[i] onObjects: objects values:values baseTimes:baseTimes];
        }
        
    } else if ([actionsConfigs isKindOfClass:[NSDictionary class]]) {
        
        for (NSString* key in actionsConfigs) {
            [self runActionExecutor: actionsConfigs[key] onObjects: objects values:values baseTimes:baseTimes];
        }
        
    }
}

-(void) runActionExecutor: (NSDictionary*)config onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes {
    NSString* action = [config objectForKey: KeyOfAction];
    ActionExecutorBase* executor = [self getActionExecutor: action];
    [executor execute: config objects:objects values:values times:baseTimes];
}


#pragma mark - Extra for Audio

-(void) runAudioActionExecutors: (id)actionsConfigs
{
    [self runActionExecutors:actionsConfigs onObjects:@[@""] values:nil baseTimes:nil];
}


@end
