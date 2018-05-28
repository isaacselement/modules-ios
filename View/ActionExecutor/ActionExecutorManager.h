#import <Foundation/Foundation.h>

#define KeyOfAction @"Action"

@class ActionExecutorBase;

@interface ActionExecutorManager : NSObject

#pragma mark - Public Methods 
-(void) registerActionExecutor: (NSString*)action executor:(ActionExecutorBase*)executor ;

-(void) removeActionExecutor: (NSString*)action ;
-(NSDictionary*) getActionExecutors;
-(ActionExecutorBase*) getActionExecutor: (NSString*)action ;

// actionsConfigs should be NSArray / NSDictionary
-(void) runActionExecutors: (id)actionsConfigs onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes;

-(void) runActionExecutor: (NSDictionary*)config onObjects:(NSArray*)objects values:(NSArray*)values baseTimes:(NSArray*)baseTimes ;


#pragma mark - Extra for Audio

-(void) runAudioActionExecutors: (id)actionsConfigs;

@end
