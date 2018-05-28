#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (NSString *)sortedJsonString ;

@end


@interface NSDictionary (DeepCopy)

- (NSMutableDictionary *)deepCopy ;

- (void)deepCopyTo:(NSMutableDictionary*)destination ;

@end
