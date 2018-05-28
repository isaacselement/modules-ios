#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (id)safeObjectAtIndex:(NSUInteger)index ;

- (NSArray *)reversedArray ;

- (NSString *)sortedJsonString ;

@end


@interface NSArray (DeepCopy)

- (NSMutableArray *)deepCopy ;

- (void)deepCopyTo:(NSMutableArray*)destination ;

@end
