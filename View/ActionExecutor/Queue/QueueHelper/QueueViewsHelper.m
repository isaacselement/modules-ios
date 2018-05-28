#import "QueueViewsHelper.h"
#import "_ActionExecutor_.h"

#import "QueuePositionsHelper.h"



@implementation QueueViewsHelper



NSMutableArray* viewsRepository     = nil;

// Views Repository == nil or != nil situation , make its structure same as matrix
+(void) setViewsRepository: (NSArray*)matrixs viewClass:(Class)viewClass
{
    // if viewsRepository != nil , convert to one dimension
    NSMutableArray* wholeElements = [NSMutableArray array];
    for (NSUInteger i = 0; i < viewsRepository.count; i++) {
        [wholeElements addObjectsFromArray: [viewsRepository objectAtIndex: i]];
    }
    int index = 0;
    
    if (! viewsRepository) {
        viewsRepository = [NSMutableArray arrayWithCapacity: matrixs.count];
    } else {
        [viewsRepository removeAllObjects];
    }
    
    NSInteger outerCount = matrixs.count;
    for (int i = 0; i < outerCount; i++) {
        NSArray* innerMatrixs = [matrixs objectAtIndex: i] ;
        NSInteger innerCount = [innerMatrixs count];
        NSMutableArray* innerRepository = [NSMutableArray arrayWithCapacity: innerCount];
        for (NSInteger j = 0; j < innerCount; j++) {
            
            // Get the view, if have , or not alloc it
            UIView* view = [wholeElements safeObjectAtIndex: index];
            index++;
            if (! view) {
               view = [[viewClass alloc] init];
            }
            
            [innerRepository addObject: view];
        }
        [viewsRepository addObject: innerRepository];
    }
}

+(NSArray*) viewsRepository
{
    return viewsRepository;
}



NSMutableArray* viewsInVisualArea   = nil;

// Views At Container
// Vbounds is the container bounds
+(void) setViewsInVisualArea: (CGRect)bounds
{
    if (! viewsInVisualArea) {
        viewsInVisualArea = [NSMutableArray array];
    } else {
        [viewsInVisualArea removeAllObjects];
    }
    
    NSArray* rectsRepository = [QueuePositionsHelper rectsRepository];
    NSArray* viewsRepository = [QueueViewsHelper viewsRepository];
    
    for (int i = 0; i < rectsRepository.count; i++) {
        NSArray* innerRepository = [rectsRepository objectAtIndex:i];
        NSMutableArray* innerViews = [NSMutableArray array];
        for (int j = 0; j < innerRepository.count; j++) {
            NSValue* rectValue = [innerRepository objectAtIndex: j];
            if ([QueuePositionsHelper isRectExtrude:[rectValue CGRectValue] inRect:bounds]) continue;           // NOT IN THE VISUAL RECT
            
            [innerViews addObject:[[viewsRepository objectAtIndex: i] objectAtIndex: j]];
        }
        if (innerViews.count) [viewsInVisualArea addObject: innerViews];
    }
}

+(NSMutableArray*) viewsInVisualArea
{
    return viewsInVisualArea;
}

+(void) replaceViewsInVisualAreaWithNull
{
    for (NSMutableArray* innerArray in viewsInVisualArea) {
        for (int i = 0; i < innerArray.count; i++) {
            [innerArray replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
}

// obj could be UIView or NSNull
+(BOOL) isViewsInVisualAreaContains: (id)obj
{
    for (NSMutableArray* innerArray in viewsInVisualArea) {
        for (int i = 0; i < innerArray.count; i++) {
            BOOL isContains = [innerArray containsObject: obj];
            if (isContains) {
                return YES;
            }
        }
    }
    return NO;
}


+(NSMutableArray*) getViewsInVisualAreaFromViewsRepository: (CGRect)bounds
{
    NSMutableArray* outterViews = [NSMutableArray array];
    NSArray* rectsRepository = [QueuePositionsHelper rectsRepository];
    for (int i = 0; i < rectsRepository.count; i++) {
        NSMutableArray* innerViews = [NSMutableArray array];
        NSArray* innerRectsRepository = rectsRepository[i];
        
        for (int j = 0; j < innerRectsRepository.count; j++) {
            CGRect rect = [[innerRectsRepository objectAtIndex:j] CGRectValue];
            
            if ([QueuePositionsHelper isRectExtrude: rect inRect:bounds]) continue;
            
            __block BOOL isHasViewInRect = NO;
            [IterateHelper iterateTwoDimensionArray: [QueueViewsHelper viewsRepository] handler:^BOOL(NSUInteger outterIndex, NSUInteger innerIndex, id obj, NSUInteger outterCount, NSUInteger innerCount) {
                if ([QueuePositionsHelper isPointInclude: ((UIView*)obj).center inRect:rect]) {
                    [innerViews addObject: obj];
                    isHasViewInRect = YES;
                    return YES;
                }
                return NO;
            }];
            if (!isHasViewInRect) {
                [innerViews addObject:[NSNull null]];
            }
        }
        
        if (innerViews.count) [outterViews addObject: innerViews];
    }
    return outterViews;
}


#pragma mark - 


+(NSMutableArray*) getViewsQueuesIn:(NSArray*)views lines:(NSArray*)lines indexPaths:(NSArray*)indexPaths
{
    // the structure or dimension should be same as indexPaths
    NSMutableArray* outterViews = [NSMutableArray array];
    for (int i = 0; i < indexPaths.count; i++) {
        NSMutableArray* innerViews = [NSMutableArray array];
        NSArray* innerIndexPaths = indexPaths[i];
        for (int j = 0 ; j < innerIndexPaths.count; j++) {
            NSArray* indexPath = innerIndexPaths[j];
            int x = [[indexPath firstObject] intValue];
            int y = [[indexPath lastObject] intValue];
            
            NSArray* cellValue = [[lines objectAtIndex: x] objectAtIndex:y];
            int row = [[cellValue firstObject] intValue];
            int column = [[cellValue lastObject] intValue];
            
            id obj = [[views safeObjectAtIndex: row] safeObjectAtIndex: column] ;
            if (obj) {
                [innerViews addObject: obj];
            }
        }
        if (innerViews.count) [outterViews addObject: innerViews];
    }
    return outterViews;
    
}


#pragma mark -


+(NSMutableArray*) getUselessViews: (int)count
{
    NSMutableArray* results = [self getUselessViews];
    
    [ArrayHelper removeElements: results afterIndex: count - 1];
    
    return results;
}

+(NSMutableArray*) getUselessViews
{
    NSMutableArray* results = [NSMutableArray arrayWithCapacity: 1];
    [IterateHelper iterateTwoDimensionArray: viewsRepository handler:^BOOL(NSUInteger outterIndex, NSUInteger innerIndex, id obj, NSUInteger outterCount, NSUInteger innerCount) {
        [results addObject: obj];
        return NO;
    }];
    
    [IterateHelper iterateTwoDimensionArray: viewsInVisualArea handler:^BOOL(NSUInteger outterIndex, NSUInteger innerIndex, id obj, NSUInteger outterCount, NSUInteger innerCount) {
        [results removeObject: obj];
        return NO;
    }];
    
    return results;
}

+(void) removeAnimations: (NSArray*)views
{
    for (NSArray* innerViews in views) {
        for (UIView* view in innerViews) {
            [view.layer removeAllAnimations];
        }
    }
}

// views is two dimension array
+(BOOL) checkIsWholeViewsNull:(NSArray*)views
{
    for (NSArray* innerViews in views) {
        for (id view in innerViews) {
            if (view != [NSNull null]) {
                return NO;
            }
        }
    }
    return YES;
}

@end
