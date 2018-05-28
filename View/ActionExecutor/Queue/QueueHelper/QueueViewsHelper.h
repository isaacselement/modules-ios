#import <UIKit/UIKit.h>

@interface QueueViewsHelper : NSObject


+(void) setViewsRepository: (NSArray*)matrixs viewClass:(Class)viewClass;
+(NSArray*) viewsRepository;

+(void) setViewsInVisualArea: (CGRect)bounds;
+(NSMutableArray*) viewsInVisualArea;

+(void) replaceViewsInVisualAreaWithNull;

+(BOOL) isViewsInVisualAreaContains: (id)obj;

+(NSMutableArray*) getViewsInVisualAreaFromViewsRepository: (CGRect)bounds;


#pragma mark -

+(NSMutableArray*) getViewsQueuesIn:(NSArray*)views lines:(NSArray*)lines indexPaths:(NSArray*)indexPaths;


#pragma mark -

+(NSMutableArray*) getUselessViews;

+(NSMutableArray*) getUselessViews: (int)count;

+(BOOL) checkIsWholeViewsNull:(NSArray*)views;

+(void) removeAnimations: (NSArray*)views;

@end
