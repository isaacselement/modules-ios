#import "NSMutableArray+Additions.h"

@implementation NSMutableArray (Move)

-(void) moveFirstObjectToLast
{
    id firstObj = [self firstObject];
    if (! firstObj) return;
    [self removeObjectAtIndex: 0];
    [self addObject: firstObj];
}

-(void) moveLastObjectToFirst
{
    id lastObj = [self lastObject];
    if (! lastObj) return;                      // just the case self.count == 0
    [self removeObjectAtIndex: self.count - 1];
    [self insertObject: lastObj atIndex:0];
}

-(void) reverse {
    if ([self count] == 0) return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;
        j--;
    }
}

@end


@implementation NSMutableArray (Replace)

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object {
    [self safeReplaceObjectAtIndex:index withObject:object placeHolder:nil];
}

- (void)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)object placeHolder:(id)placeHolder {
    if (index >= self.count) {
        for (NSInteger i = self.count; i <= index; i++) {
            if (placeHolder) {
                [self addObject: placeHolder];
            } else {
                [self addObject:[NSNull null]];
            }
        }
    }
    [self replaceObjectAtIndex:index withObject:object];
}

@end


@implementation NSMutableArray (Remove)

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    return index >= self.count ? nil : [self removeObjectAtIndex: index];
}

- (void)removeObjectUsingComparator:(BOOL(^)(int index, id obj))comparator {
    for (int i = 0; i < self.count; i++) {
        if (comparator(i, self[i])) {
            [self removeObjectAtIndex: i];
            i--;
        }
    }
}

@end
