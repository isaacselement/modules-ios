#import "ScheduledTask.h"
#import "TaskObjectList.h"

@implementation ScheduledTask
{
    bool isStarted;
    bool isDispatching;
    float timeDuration;
    
    NSThread* scheduledThread;
    NSCondition* condition;
    bool isPause;
    
    LinkList* taskObjectList;    // TO BE OPTIMIZED , NOT THREAD SAFE
    
    NSOperationQueue* _operationQueue;
}


@synthesize timeInterval;


-(id) init {
    self = [super init];
    if (self) {
        timeDuration = 0.0;
        timeInterval = 0.1;
        isStarted = NO;
        isDispatching = NO;
        scheduledThread = [[NSThread alloc] initWithTarget: self selector:@selector(messageDispatcher) object:nil];
        condition = [[NSCondition alloc] init];
        
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(id) initWithTimeInterval: (float)interval {
    self = [self init] ;
    if (self) {
        timeInterval = interval;
    }
    return self;
}

-(void) messageDispatcher {
    while (isDispatching) {
        
        [condition lock];
        if (isPause || !taskObjectList) {
            isPause = YES;
            [condition wait];
        }
        [condition unlock];
        
        timeDuration += timeInterval;
        TaskObject* p1 = NULL , *p0 = NULL;
        p1 = taskObjectList;
        
        while (taskObjectList && p1 && timeDuration >= p1->timeInvoke) {
            id target = (__bridge id)(p1->target);
            
            if ([target conformsToProtocol: @protocol(ScheduledTaskProtocol)] || [target respondsToSelector: @selector(scheduledTask)]) {
                [_operationQueue addOperationWithBlock:^{
                    [target scheduledTask];
                }];
            }
            
            // < 0 , loop every timeElapsed
            if (p1->repeats < 0) {
                p1->timeInvoke += p1->timeElapsed;
                
                // > 0 , do accurate repeat times
            } else if (p1->repeats > 0) {
                p1->repeats -- ;
                p1->timeInvoke += p1->timeElapsed;
                
                // == 0 , remove from task list
            } else {
                if (p1 == taskObjectList) {
                    taskObjectList  = taskObjectList -> next;
                } else {
                    p0->next = p1->next;
                }
                free(p1);
                p1 = p0;
            }
            
            p0 = p1;
            p1 = p1->next;
        }
        
        [NSThread sleepForTimeInterval: timeInterval];
    }
}

/*
 
 1.
 repeats =< 0 : loop every timeElapsed ：
 < 0 : perform immediately  , loop
 = 0 : perform after one timeElapsed , loop
 
 2.
 repeats > 0 : repeat accurate repeat times , and perform after one timeElapsed
 
 */
-(void) registerSchedule: (id)target timeElapsed:(float)timeElapsed repeats:(int)repeats {
    TaskObject* taskObject = CreateTaskObject((__bridge void*)target, timeElapsed, repeats);
    if (taskObject->timeElapsed < 0.05) taskObject->timeElapsed = 0.05;
    float invokeTime = repeats < 0 ? timeDuration : timeDuration + timeElapsed;
    taskObject->timeInvoke = invokeTime;
    taskObject->next = NULL;
    
    taskObjectList = InsertList(taskObjectList, taskObject);
    if (isStarted && isPause && taskObjectList != NULL) {
        [self resume];
    }
}

-(void) unRegisterSchedule: (id)target {
    taskObjectList = ListDelete(taskObjectList, (__bridge void *)(target));
}

-(BOOL) isRegisteredSchedule: (id)target {
    return isListContains(taskObjectList, (__bridge void *)(target));
}


-(void) start {
    if (! isStarted) {
        isDispatching = YES;
        [scheduledThread start];
        isStarted = YES;
    }else {
        [self resume];
    }
}


-(void) cancel {
    isDispatching = NO;
    
    // ....
    [self pause];
    taskObjectList = ClearList(taskObjectList);
}
-(BOOL) isCancelled
{
    return isStarted && !isDispatching;
}


-(void) pause {
    isPause = YES;
}

-(BOOL) isPause {
    return isPause;
}


-(void) resume {
    [condition lock];
    isPause = NO;
    [condition signal];
    [condition unlock];
}







#pragma mark - Class Methods

static ScheduledTask* sharedInstance = nil;

+(ScheduledTask*) sharedInstance
{
    if (! sharedInstance) {
        sharedInstance = [[ScheduledTask alloc] init];
    }
    return sharedInstance;
}

+(void) setSharedInstance:(ScheduledTask*)instance
{
    sharedInstance = instance;
}

@end
