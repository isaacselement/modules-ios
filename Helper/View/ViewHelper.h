#import <UIKit/UIKit.h>

@interface ViewHelper : NSObject




#pragma mark - Public Methods


+(void) logViewsRecursive: (UIView*)view;

+(void) setShadowWithCorner: (UIView*)view config:(NSDictionary*)config ;


+(void) sortedSubviewsByXCoordinate: (UIView*)view;
+(void) sorteByXCoordinate: (NSMutableArray*)array;
+(void) sorteByYCoordinate: (NSMutableArray*)array;

+(void) resignFirstResponserOnView: (UIView*)containerView;


+(void) tableViewRowInsert:(UITableView*)tableView insertIndexPaths:(NSArray*)insertIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion;


+(void) tableViewRowDelete:(UITableView*)tableView deleteIndexPaths:(NSArray*)deleteIndexPaths animation:(UITableViewRowAnimation)animation completion:(void (^)(BOOL finished))completion;


#pragma mark - About Width
+(void) resizeSizeBySubviewsOccupiedSize: (UIView*)view;
+(void) resizeWidthBySubviewsOccupiedWidth: (UIView*)view;
+(void) resizeHeightBySubviewsOccupiedHeight: (UIView*)view;
+(CGFloat) getSubViewsOccupiedLongestWidth: (UIView*)view;
+(CGFloat) getSubViewsOccupiedLongestHeight: (UIView*)view;

#pragma mark - About Subviews
+(void) iterateSubView: (UIView*)superView handler:(BOOL (^)(id subView))handler;
+(void) iterateSubView: (UIView*)superView class:(Class)clazz handler:(BOOL (^)(id subView))handler ;
+(void) iterateSubView: (UIView*)superView classes:(NSArray*)clazzes handler:(BOOL (^)(id subView))handler;



+(void) iterateSuperView: (UIView*)subView handler:(BOOL (^)(id superView))handler;
+(BOOL) isSuperview: (UIView*)superView forView:(UIView*)view;



+(UIView*) getSubview: (UIView*)view clazz:(Class)clazz;
+(UIView*) getSuperView: (UIView*)view clazz:(Class)clazz;

#pragma mark -
+(UIActivityIndicatorView*) getIndicatorInView: (UIView*)containerView;



#pragma mark -


+ (UIImage *)imageFromView: (UIView*) view;
+ (UIImage *)imageFromView: (UIView *)view atRect:(CGRect)rect;
+ (UIImage *)imageFromLayer: (CALayer*) layer;
+ (UIImage *)imageFromLayer: (CALayer *)layer atRect:(CGRect)rect;


#pragma mark - 

+(void) printView: (UIView*)view completeHandler:(void(^)(UIPrintInteractionController *controller, BOOL completed, NSError *error))completeHandler;

+(void) print: (id)content completeHandler:(void(^)(UIPrintInteractionController *controller, BOOL completed, NSError *error))completeHandler;

@end
