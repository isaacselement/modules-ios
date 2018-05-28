#import "QueueIndexPathParser.h"
#import "_ActionExecutor_.h"

@implementation QueueIndexPathParser


#pragma mark - Static Properties
NSMutableArray* indexPathsRepository = nil;
+(void) setIndexPathsRepository: (int)dimension
{
    // set up the indexPath array
    if (! indexPathsRepository) {
        indexPathsRepository = [NSMutableArray array];
    }
    
    // square ' max * max ' , here check if need extension, then extend it
    for (int i = 0; i < dimension; i++) {
        NSMutableArray* innerIndexPaths = [indexPathsRepository safeObjectAtIndex: i];
        if (!innerIndexPaths) {
            innerIndexPaths = [NSMutableArray arrayWithCapacity: dimension];
            [indexPathsRepository addObject: innerIndexPaths];
        }
        for (int j = 0; j < dimension; j++) {
            NSArray* coordinate = [innerIndexPaths safeObjectAtIndex: j];
            if (! coordinate) {
                coordinate = @[@(i), @(j)];
                [innerIndexPaths addObject:coordinate];
            }
        }
    }

}
+(NSArray*) indexPathsRepository
{
    // if nil , i give you the default
    if (! indexPathsRepository) {
        [self setIndexPathsRepository: 11];
    }
    return indexPathsRepository;
}




#pragma mark - Replace The Config's IndexPaths

+(void) replaceIndexPathsWithExistingIndexPathsRepositoryInDictionary: (NSMutableDictionary*)dictionary
{
    for (NSString* key in dictionary) {
        id obj = dictionary[key];
        
        if ([obj isKindOfClass: [NSDictionary class]]) {
            [self replaceIndexPathsWithExistingIndexPathsRepositoryInDictionary: obj];
        } else if ([obj isKindOfClass: [NSArray class]]) {
            [self replaceIndexPathsWithExistingIndexPathsRepositoryInArray: obj];
        }
    }
}
+(void) replaceIndexPathsWithExistingIndexPathsRepositoryInArray: (NSMutableArray*)array
{
    BOOL isTwoDimension = [ArrayHelper isTwoDimension: array];
    if (isTwoDimension) {
        [self replaceElementsWithExistingIndexPathsRepository: array];
    } else {
        for (id obj in array) {
            if ([obj isKindOfClass: [NSDictionary class]]) {
                [self replaceIndexPathsWithExistingIndexPathsRepositoryInDictionary: obj];
            } else if ([obj isKindOfClass: [NSArray class]]) {
                [self replaceIndexPathsWithExistingIndexPathsRepositoryInArray: obj];
            }
        }
    }
}
+(void) replaceElementsWithExistingIndexPathsRepository: (NSMutableArray*)indexPaths
{
    for (NSUInteger i = 0; i < indexPaths.count; i++) {
        
        NSArray* coordinate = indexPaths[i];
        if( ![coordinate isKindOfClass:[NSArray class]] || coordinate.count != 2) continue;
        
        NSNumber* xNum = [coordinate firstObject];
        NSNumber* yNum = [coordinate lastObject];
        if(![xNum isKindOfClass:[NSNumber class]] || ![yNum isKindOfClass:[NSNumber class]]) continue;
        
        int x = [xNum intValue];
        int y  = [yNum intValue];
        NSArray* reusedElement = [[indexPathsRepository safeObjectAtIndex: x] safeObjectAtIndex: y];
        if (reusedElement) {
            [indexPaths replaceObjectAtIndex: i withObject: reusedElement];
        }
    }
}




#pragma mark - Get Indexes Paths

+(NSMutableArray*) getIndexPathsIn: (NSArray*)lines elements:(NSArray*)elements
{
    NSMutableArray* results = [NSMutableArray array];
    
    for (int i = 0; i < elements.count; i++) {
        NSArray* element = elements[i];
        NSArray* array = [self getIndexPathsIn: lines element:element];
        [results addObjectsFromArray: array];
    }
    
    return results;
}


// array is two dimension, this array can be contained the element more than one, then then element can be in many coordinates , so ,return the array .
+(NSMutableArray*) getIndexPathsIn: (NSArray*)array element:(id)element
{
    NSMutableArray* results = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSMutableArray* innerArray = array[i];
        
        for (int j = 0; j < innerArray.count; j++) {
            id value = innerArray[j];
            if (value == element /* __Look At Me___*/ || [self isValue: value equal:element] /* */) {
                [results addObject:[[indexPathsRepository objectAtIndex: i] objectAtIndex: j]];
            }
        }
        
    }
    return results;
}


// __Look At Me___ :
// if have already ' Replace The Config's IndexPaths '(replaceIndexPathsWithExistingIndexPathsRepositoryInDictionary:) , this method is no need to use
+(BOOL) isValue: (id)coordinate equal:(id)withCoordinate
{
    if ([coordinate isKindOfClass:[NSArray class]] && [withCoordinate isKindOfClass:[NSArray class]]) {
        NSNumber* rowNumber = [(NSArray*) coordinate firstObject];
        NSNumber* columnNumber = [(NSArray*) coordinate lastObject];
        
        NSNumber* withRowNumber = [(NSArray*) withCoordinate firstObject];
        NSNumber* withColumnNumber = [(NSArray*) withCoordinate lastObject];
        
        if ( (rowNumber == withRowNumber) && (columnNumber == withColumnNumber) ) {
            return YES;
        }
        

        int row = [rowNumber intValue];
        int column = [columnNumber intValue];
        
        int withRow = [withRowNumber intValue];
        int withColumn = [withColumnNumber intValue];
        
        return (row == withRow) && (column == withColumn);
    }
    return NO;
}









+(NSMutableArray*) groupNullIndexPaths: (NSArray*)nullIndexPaths isNullIndexPathsBreakWhenNotCoterminous:(BOOL)isNullIndexPathsBreakWhenNotCoterminous isColumnBase:(BOOL)isColumnBase
{
    NSMutableArray* keys = [NSMutableArray array];
    NSMutableDictionary* groupedResult = [NSMutableDictionary dictionary];
    
    // then do group job
    for (int i = 0; i < nullIndexPaths.count; i++) {
        NSArray* indexPath = [nullIndexPaths objectAtIndex: i];
        NSString* key = isColumnBase ? [[indexPath lastObject] stringValue] : [[indexPath firstObject] stringValue];
        
        if (!groupedResult[key]) {
            [groupedResult setObject: [NSMutableArray array] forKey:key];
            [keys addObject: key];
        }
        [groupedResult[key] addObject: indexPath];
    }
    
    // for maintain the order
    NSMutableArray* results = [NSMutableArray array];
    for (int i = 0; i < keys.count; i++) {
        NSString* key = keys[i];
        NSArray* oneGroupedNullIndexPaths = groupedResult[key];
        if (isNullIndexPathsBreakWhenNotCoterminous) {
            [results addObjectsFromArray:[self breakWhenNotCoterminous: oneGroupedNullIndexPaths isColumnBase:isColumnBase]];
        } else {
            [results addObject: oneGroupedNullIndexPaths];
        }
    }
    return results;
}



// isColumnBase , isBackward , isReverse. assemble the indexPaths sequence
+(NSMutableArray*) assembleIndexPaths:(NSArray*)lines groupedNullIndexpaths:(NSArray*)groupedNullIndexpaths isBackward:(BOOL)isBackward isColumnBase:(BOOL)isColumnBase isReverse:(BOOL)isReverse
{
    NSMutableArray* outterIndexPaths = [NSMutableArray array];
    int outterNullCount = (int)groupedNullIndexpaths.count;
    for (int i = 0; i < outterNullCount; i++) {
        NSMutableArray* innerIndexPaths = [NSMutableArray array];
        NSArray* innerGropedIndexPaths = groupedNullIndexpaths[i];
        
        // for get the row or column
        NSArray* anyPath = [innerGropedIndexPaths firstObject];
        int baseIndex = isColumnBase ? [[anyPath lastObject] intValue] : [[anyPath firstObject] intValue]; // current index Row or Column , when isColumn == YES , it's index Column , otherwise is index Row
        
        // get startIndex and endIndex
        int endIndex = [self getEndIndex:innerGropedIndexPaths isBackward:isBackward isColumnBase:isColumnBase];
        int startIndex = [self getStartIndex: lines currentRowOrColumn:baseIndex isBackward:isBackward isColumnBase:isColumnBase];
        
        for (int j = startIndex; isBackward ? j >= endIndex : j <= endIndex ; isBackward ? j-- : j++) {
            
            NSArray* indexPath = isColumnBase ? [[indexPathsRepository safeObjectAtIndex: j] safeObjectAtIndex: baseIndex] : [[indexPathsRepository safeObjectAtIndex: baseIndex] safeObjectAtIndex: j];
            
            if (indexPath) {
                [innerIndexPaths addObject: indexPath];
            }
        }
        
        // reverse or not
        if (isReverse) {
            [innerIndexPaths reverse];
        }
        
        [outterIndexPaths addObject: innerIndexPaths];
    }
    return outterIndexPaths;
}






#pragma mark - Utilities Methods

+(int) getEndIndex: (NSArray*)indexPaths isBackward:(BOOL)isBackward isColumnBase:(BOOL)isColumnBase
{
    int criticalIndex = -1;
    for (int i = 0; i < indexPaths.count; i++) {
        NSArray* values = indexPaths[i];
        
        int comparedIndex = isColumnBase ? [[values firstObject] intValue ]: [[values lastObject] intValue];
        
        // init compare
        if (criticalIndex == -1) {
            criticalIndex = comparedIndex;
            continue;
        }
        
        // do compare
        if (isBackward) {
            if (comparedIndex < criticalIndex) criticalIndex = comparedIndex; // find the minimal
        } else {
            if (comparedIndex > criticalIndex) criticalIndex = comparedIndex; // find the maximal
        }
    }
    
    return criticalIndex;
}
+(int) getStartIndex: (NSArray*)lines currentRowOrColumn:(int)currentRowOrColumn isBackward:(BOOL)isBackward isColumnBase:(BOOL)isColumnBase
{
    int startIndex = 0 ;
    if (isBackward) {
        startIndex = isColumnBase ? (int)lines.count - 1 : (int)[[lines objectAtIndex: currentRowOrColumn] count] - 1;
    } else {
        startIndex = 0 ;
    }
    return startIndex;
}

// oneGroupedIndexPaths : [[1,2], [1,3], [1,5], [1,6]] -> results : [   [ [1,2], [1,3] ],  [ [1,5],[1,6] ]     ]
+(NSArray*) breakWhenNotCoterminous: (NSArray*)oneGroupedNullIndexPaths isColumnBase:(BOOL)isColumnBase
{
    NSMutableArray* results = [NSMutableArray array];
    NSMutableArray* coterminousPiece = nil;
    
    coterminousPiece = [NSMutableArray array];
    [results addObject: coterminousPiece];
    
    // make sure have the ASC OR DESC
    NSUInteger count = oneGroupedNullIndexPaths.count;
    for (NSUInteger i = 0; i < count; i++) {
        NSArray* element = oneGroupedNullIndexPaths[i];
        
        // not the first one
        if (i != 0) {
            NSArray* preElement = oneGroupedNullIndexPaths[i-1];
            
            int a = isColumnBase ? [[element firstObject] intValue ]: [[element lastObject] intValue];
            int b = isColumnBase ? [[preElement firstObject] intValue ]: [[preElement lastObject] intValue];
            
            [coterminousPiece addObject: preElement];
            if (abs(a - b) != 1) {
                coterminousPiece = [NSMutableArray array];
                [results addObject: coterminousPiece];
            }
            
        }
        
        // the last one , or count == 0 , the first one
        if (i == count-1) {
            [coterminousPiece addObject: element];
        }
    }
    
    return results;
}

@end
