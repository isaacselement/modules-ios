#import <Foundation/Foundation.h>

@interface QueueIndexPathParser : NSObject


#pragma mark - Static Properties

+(void) setIndexPathsRepository: (int)dimension;
+(NSArray*) indexPathsRepository;


#pragma mark - Public Methods

+(void) replaceIndexPathsWithExistingIndexPathsRepositoryInArray: (NSMutableArray*)array;
+(void) replaceIndexPathsWithExistingIndexPathsRepositoryInDictionary: (NSMutableDictionary*)dictionary;


// array is two dimension
+(NSMutableArray*) getIndexPathsIn: (NSArray*)array element:(id)element;
+(NSMutableArray*) getIndexPathsIn: (NSArray*)lines elements:(NSArray*)elements;

+(NSMutableArray*) groupNullIndexPaths: (NSArray*)nullIndexPaths isNullIndexPathsBreakWhenNotCoterminous:(BOOL)isNullIndexPathsBreakWhenNotCoterminous isColumnBase:(BOOL)isColumnBase;



+(NSMutableArray*) assembleIndexPaths:(NSArray*)lines groupedNullIndexpaths:(NSArray*)groupedNullIndexpaths isBackward:(BOOL)isBackward isColumnBase:(BOOL)isColumnBase isReverse:(BOOL)isReverse;



@end
