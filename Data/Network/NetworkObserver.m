#import "NetworkObserver.h"
#import "Reachability.h"


@implementation NetworkObserver
{
    Reachability* internetReachability;

    NetworkViaStatus _currentNetworkViaStatus;
}


static NetworkObserver* sharedInstance = nil;

+(NetworkObserver*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkObserver alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self registerStatusUpdatedNotification];
        });
    }
    return self;
}

- (void)dealloc
{
    [self unregisterStatusUpdatedNotification];
}

#pragma mark -

-(void) registerStatusUpdatedNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    if (!internetReachability) internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    [self updateReachabilityStatus: internetReachability];
}
         
-(void) unregisterStatusUpdatedNotification
{
    [internetReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}


-(NetworkViaStatus) currentNetworkStatus
{
    return _currentNetworkViaStatus;
}


#pragma mark - Reachability

-(void) reachabilityChanged:(NSNotification*)note
{
    [self updateReachabilityStatus: note.object];
}

-(void) updateReachabilityStatus:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            _currentNetworkViaStatus = NetworkNotAvalible;
            break;
        case ReachableViaWWAN:
            _currentNetworkViaStatus = NetworkViaWWAN;
            break;
        case ReachableViaWiFi:
            _currentNetworkViaStatus = NetworkViaWiFi;
            break;
        default:
            break;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(invokeNetworkCallback) object:nil];
    [self performSelector:@selector(invokeNetworkCallback) withObject:nil afterDelay:0.2];
}

-(void) invokeNetworkCallback
{
    if (self.networkStatusUpdatedCallback) {
        self.networkStatusUpdatedCallback(self);
    }
}


@end
