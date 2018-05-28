#import "ImageHelper.h"

@implementation ImageHelper

+(NSMutableArray*) converToContextImages: (NSArray*)array repository:(NSMutableArray*)repository {
    if (!repository) repository = [NSMutableArray array];
    for (int i = 0 ; i < array.count ; i++){
        UIImage* image = [array objectAtIndex: i];
        UIGraphicsBeginImageContext(image.size);
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
        [image drawInRect: rect];
        UIImage* symbolImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (symbolImage)[repository addObject: symbolImage];
    }
    return repository;
}

// apply alpha to image , note that the image is another new instance
+(UIImage*) applyingAlphaToImage: (UIImage*)image alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSData *)resizeWithImage:(UIImage*)image scale:(CGFloat)scale compression:(CGFloat)compression
{
    UIImage* newImage = [self resizeImage: image scale:scale];
    return UIImageJPEGRepresentation(newImage, compression);
}


+ (UIImage *)resizeImage:(UIImage*)image scale:(CGFloat)scale
{
    CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+(UIImage*)merge: (UIImage*)image with:(UIImage*)withImage
{
    CGSize imageSize = image.size;
    CGSize withImageSize = withImage.size;
    CGSize size = CGSizeMake(imageSize.width + withImageSize.width, MAX(imageSize.height, withImageSize.height));
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, (CGRect){{0,0},size});
    
    [image drawAtPoint: CGPointMake(0, size.height - imageSize.height)];
    [withImage drawAtPoint: CGPointMake(imageSize.width, size.height - withImageSize.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end


