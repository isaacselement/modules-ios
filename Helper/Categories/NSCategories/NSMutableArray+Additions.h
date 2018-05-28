#import <Foundation/Foundation.h>

@interface NSMutableArray (Move)

-(void) moveLastObjectToFirst;
-(void) moveFirstObjectToLast;
-(void) reverse ;

@end


@interface NSMutableArray (Replace)

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object placeHolder:(id)placeHolder ;

@end


@interface NSMutableArray (Remove)

- (void)safeRemoveObjectAtIndex:(NSUInteger)index ;

- (void)removeObjectUsingComparator:(BOOL(^)(int index, id obj))comparator ;

@end
