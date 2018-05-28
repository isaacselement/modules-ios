#import <UIKit/UIKit.h>

@interface ImageHelper : NSObject

+(NSMutableArray*) converToContextImages: (NSArray*)array repository:(NSMutableArray*)repository ;

+(UIImage*) applyingAlphaToImage: (UIImage*)image alpha:(CGFloat)alpha ;

/**
 *  Resize & compress image
 *
 *  @param image       UIImage to process
 *  @param scale       scale factor
 *  @param compression compression factor
 *
 *  @return New image by NSData form
 */
+ (NSData *)resizeWithImage:(UIImage*)image scale:(CGFloat)scale compression:(CGFloat)compression;

+ (UIImage *)resizeImage:(UIImage*)image scale:(CGFloat)scale;


+(UIImage*)merge: (UIImage*)image with:(UIImage*)withImage;

@end


