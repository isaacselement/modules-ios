#import <Foundation/Foundation.h>


@protocol ScheduledTaskProtocol <NSObject>

@required

-(void) scheduledTask ;

@end



@interface ScheduledTask : NSObject


@property (assign, atomic) float timeInterval;


-(id) initWithTimeInterval: (float)interval;

-(void) registerSchedule: (id)target timeElapsed:(float)timeElapsed repeats:(int)repeats;
-(void) unRegisterSchedule: (id)target;
-(BOOL) isRegisteredSchedule: (id)target;


-(void) start;
-(void) pause;
-(void) resume;


- (void)cancel;
- (BOOL)isCancelled;



#pragma mark - Class Methods

+(ScheduledTask*) sharedInstance;

+(void) setSharedInstance:(ScheduledTask*)instance;


@end


