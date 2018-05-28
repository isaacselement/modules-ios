#import <UIKit/UIKit.h>

@interface QueuePositionsHelper : NSObject


#pragma mark - Static Properties
#pragma mark - Basic Repository

+(void) setRectsRepository: (NSArray*)matrixs;
+(NSArray*) rectsRepository;
+(NSArray*) positionsRepository;


#pragma mark - Public Methods

+(void) refreshRectsPositionsRepositoryWhenClipsToBoundsIsNO: (CGRect)containerRect;


#pragma mark - Positions Sequences

+(NSMutableArray*) getPositionsQueues: (NSArray*)lines indexPaths:(NSArray*)indexPaths linesConfig:(NSDictionary*)linesConfig;





#pragma mark - Util Methods

+(BOOL) isPointInContainerRect: (CGPoint)point rect:(CGRect)rect;


+(BOOL) isRectExtrude: (CGRect)rect inRect:(CGRect)bounds;
+(BOOL) isPointInclude: (CGPoint)point inRect:(CGRect)rect;

@end
