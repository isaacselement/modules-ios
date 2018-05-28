#import <Foundation/Foundation.h>
#import "QueueExecutorBase.h"

@interface QueueTimeCalculator : NSObject <QueueExecutorDelegate>


#pragma mark - Public Methods

-(void) clear;
-(double) take;

-(void) justClearOnePhase;
-(double) justTakeOnePhase;

#pragma mark - Class Methods

+(NSMutableArray*) getBaseTimesAccordingToViews: (NSArray*)views delay:(double)delay;



@end
