#import "QueuePositionsHelper.h"
#import "_ActionExecutor_.h"


@implementation QueuePositionsHelper


/**
 *  First , you have to know about the following concepts deeply
 *
 *
 *  (coordinate is the index of outter and inner array . i.e. [['a','b'],['c','d']], 'a' coordinate is [0,0], 'd' coordinate is [1,1] )
 *
 *  Coordinate  :   Generally,  You can see it as index of array
 *
 *
 *  Matrix      :   The array of actual frame
 *
 *  Lines       :   The array of Coordinate that reflect the Matrix , it defined in config. (So, essentially , it is IndexPaths too .)
 *
 *  IndexPaths  :   The array of Coordinate relfect to the Lines, or Views, or Other Two Dimension Array.
 *
 *
 *
 *  Position    :   the element of Matrix, tha have been Frame Translated
 *  Positions   :   the array Position
 *
 */


#pragma mark - Static Properties
#pragma mark - Basic Repository

NSMutableArray* rectsRepository        = nil;
NSMutableArray* positionsRepository    = nil;

// matrixs is the canvas array
+(void) setRectsRepository: (NSArray*)matrixs
{
    NSMutableArray* repository = [NSMutableArray array];
    NSInteger outerCount = matrixs.count;
    for (int i = 0; i < outerCount; i++) {
        NSArray* innerMatrixs = [matrixs objectAtIndex: i] ;
        NSInteger innerCount = [innerMatrixs count];
        NSMutableArray* innerRepository = [NSMutableArray arrayWithCapacity: innerCount];
        for (NSInteger j = 0; j < innerCount; j++) {
            NSArray* elements = [innerMatrixs objectAtIndex: j];
            CGRect canvas = [RectHelper parseRect: elements];
            CGRect rect = [FrameTranslater convertCanvasRect: canvas];
            NSValue* rectValue = [NSValue valueWithCGRect: rect] ;
            [innerRepository addObject: rectValue];
        }
        [repository addObject: innerRepository];
    }
    
    if (! rectsRepository) {
        rectsRepository = [NSMutableArray array];
    } else {
        [rectsRepository removeAllObjects];
    }
    [rectsRepository setArray: repository];
    
    // after update the rectsRepository , then refresh the positionsRepository
    [self setPositionsRepository];
}
+(NSArray*) rectsRepository
{
    return rectsRepository;
}


+(void) setPositionsRepository
{
    if (! positionsRepository) {
        positionsRepository = [NSMutableArray array];
    } else {
        [positionsRepository removeAllObjects];
    }
    NSArray* centers = [self getCentersValuesFromRectsValues: rectsRepository];
    [positionsRepository setArray: centers];
    
}

+(NSArray*) positionsRepository
{
    return positionsRepository;
}


#pragma mark - Public Methods
// move the outside of bounds to outside of screen
// position repository's rect is against to container
+(void) refreshRectsPositionsRepositoryWhenClipsToBoundsIsNO: (CGRect)containerRect
{
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation);
    CGFloat screenHeight = 0;
    CGFloat screenWidth = 0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (isPortrait) {
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
    } else {
        screenHeight = screenRect.size.width;
        screenWidth = screenRect.size.height;
    }
    
    CGFloat containerX = containerRect.origin.x ;
    CGFloat containerY = containerRect.origin.y ;
    CGFloat containerWidth = containerRect.size.width;
    CGFloat containerHeight = containerRect.size.height;
    
    CGRect bounds = CGRectMake(0, 0, containerWidth, containerHeight);
    
    CGFloat gapLeftX = containerX ;  // + -
    CGFloat gapRightX = screenWidth - (containerX + containerWidth);   // + -
    CGFloat gapUpY = containerY ;   // + -
    CGFloat gapDownY = screenHeight - (containerY + containerHeight);   // + -
    
    
    NSInteger outerCount = rectsRepository.count;
    for (int i = 0; i < outerCount; i++) {
        NSMutableArray* innerRepository = [rectsRepository objectAtIndex: i];
        NSInteger innerCount = [innerRepository count];
        for (NSInteger j = 0; j < innerCount; j++) {
            NSValue* rectValue = [innerRepository objectAtIndex: j];
            CGRect rect = [rectValue CGRectValue];
            
            // check if out of sight
            if (! [self isRectExtrude: rect inRect:bounds]) continue;
            
            CGFloat rx = rect.origin.x ;
            CGFloat ry = rect.origin.y ;
            
            // move it out of the screen
            if (rect.origin.x < 0) {
                rx -= gapLeftX ;    //- 3; to see it right or not ?
            } else if (rect.origin.y < 0) {
                ry -= gapUpY ;      //- 3;
            } else if (rect.origin.x >= containerWidth) {
                rx += gapRightX ;   // - 3;
            } else if (rect.origin.y >= containerHeight) {
                ry += gapDownY ;    // - 3;
            }
            
            CGRect newRect = CGRectMake(rx, ry, rect.size.width, rect.size.height);
            NSValue* newRectValue = [NSValue valueWithCGRect: newRect];
            [innerRepository replaceObjectAtIndex:j withObject:newRectValue];
        }
    }
    
    // after update the rectsRepository , then refresh the positionsRepository
    [self setPositionsRepository];
}



#pragma mark - Positions Sequences


// here , nothing about isColumnBase and isForward . According to the IndexPaths for assemble the Positions
+(NSMutableArray*) getPositionsQueues: (NSArray*)lines indexPaths:(NSArray*)indexPaths linesConfig:(NSDictionary*)linesConfig
{
    // the outter result
    NSMutableArray* outerPositionsArray = [NSMutableArray array];
    for (int i = 0; i < indexPaths.count; i++) {
        // the inner result
        NSMutableArray* innerPositionsArray = [NSMutableArray array];
        
        NSArray* innerIndexPaths = indexPaths[i];
        for (int j = 0; j < innerIndexPaths.count; j++) {
            NSArray* indexPath = innerIndexPaths[j];
            
            int x = [[indexPath firstObject] intValue];
            int y = [[indexPath lastObject] intValue];
            
            
            // then assemble the positions
            NSArray* cellValue = [[lines objectAtIndex: x] objectAtIndex:y];
            
            int row = [[cellValue firstObject] intValue];
            int column = [[cellValue lastObject] intValue];
            
            // CGPoint Value
            // const char* valueType = [[transitionValues firstObject] objCType];
            // BOOL isCGPointValue = strcmp(@encode(CGPoint), valueType) == 0;
            // In old Version , i use the rectsRepository to get CGRect Value , and give to PositionExecutor, then let
            // it to check and translate , i found that is a bad solution
            NSValue* value = [[positionsRepository objectAtIndex: row] objectAtIndex:column];
            
            // HALTS
            int haltCount = [self getHaltsCount: linesConfig[@"COPY"] counts:linesConfig[@"COPY.COUNTS"] row:row column:column];
            for (int k = 0; k < haltCount; k++)  [innerPositionsArray addObject: value];
            
            // SKIPS
            if ([self isSkip: linesConfig[@"SKIPS"] row:row column:column]) continue;
            
            [innerPositionsArray addObject: value];
            
        }
        [outerPositionsArray addObject: innerPositionsArray];
    }
    return outerPositionsArray;
}




#pragma mark - Util Methods

// point and rect not the same level , rect is the point container
+(BOOL) isPointInContainerRect: (CGPoint)point rect:(CGRect)rect
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    CGFloat containerWidth = rect.size.width;
    CGFloat containerHeight = rect.size.height;
    
    return !((x < 0 || y < 0) || (x >= containerWidth || y >= containerHeight));
}

// in the same level
+(BOOL) isRectExtrude: (CGRect)rect inRect:(CGRect)bounds
{
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    return ((x < bounds.origin.x || y < bounds.origin.y) || (x >= bounds.size.width || y >= bounds.size.height));  // the area out of inRect
}



// in the same level
+(BOOL) isPointInclude: (CGPoint)point inRect:(CGRect)rect
{
    CGSize size = rect.size;
    CGPoint origin = rect.origin;
    float xGap = point.x - origin.x ;
    float yGap = point.y - origin.y ;
    return (xGap >= 0) && (xGap < size.width) && (yGap >= 0) && (yGap < size.height) ;
}




// two dimenstion
+(NSMutableArray*) getCentersValuesFromRectsValues: (NSArray*)values {
    NSInteger count = values.count;
    NSMutableArray* array = [NSMutableArray arrayWithCapacity: count];
    for (int i = 0; i < count; i ++) {
        [array addObject:[self getCenterValuesFromRectValues: values[i]]];
    }
    return array;
}
// one dimenstion
+(NSMutableArray*) getCenterValuesFromRectValues: (NSArray*)values {
    NSInteger count = values.count;
    NSMutableArray* array = [NSMutableArray arrayWithCapacity: count];
    for (int i = 0; i < count; i ++) {
        [array addObject: [self getCenterValueFromRectValue: values[i]]];
    }
    return array;
}
// value to value
+(NSValue*) getCenterValueFromRectValue: (NSValue*)rectValue
{
    CGRect rect = [rectValue CGRectValue];
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    NSValue* centerValue = [NSValue valueWithCGPoint: center];
    return centerValue;
}




#pragma mark - Private Methods
/*
 *  Point       : the element of Lines
 *  Points      : the array of Point
 */
+(int) getHaltsCount: (NSArray*)points counts:(NSArray*)counts row:(int)row column:(int)column
{
    for (int i = 0; i < points.count; i++) {
        NSArray* point = points[i];
        if ([[point firstObject] intValue] == row && [[point lastObject] intValue] == column) {
            return [[counts safeObjectAtIndex: i] intValue];
        }
    }
    return 0;
}
+(BOOL) isSkip: (NSArray*)points row:(int)row column:(int)column
{
    for (NSInteger index = 0; index < points.count; index++) {
        NSArray* point = [points objectAtIndex: index];
        if ([[point firstObject] intValue] == row && [[point lastObject] intValue] == column) {       // check
            return YES;
        }
    }
    return NO;
}



@end
