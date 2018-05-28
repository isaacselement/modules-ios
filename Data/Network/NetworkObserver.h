#import <Foundation/Foundation.h>


typedef enum : NSInteger {
    NetworkNotAvalible = 0,
    NetworkViaWiFi,
    NetworkViaWWAN
} NetworkViaStatus;


@class Reachability;
@class NetworkObserver;


typedef void (^NetworkObserverCallback)(NetworkObserver* observer);


@interface NetworkObserver : NSObject

@property (copy) NetworkObserverCallback networkStatusUpdatedCallback;


+(NetworkObserver*) sharedInstance;


-(void) registerStatusUpdatedNotification;
-(void) unregisterStatusUpdatedNotification;

-(NetworkViaStatus) currentNetworkStatus;



@end
