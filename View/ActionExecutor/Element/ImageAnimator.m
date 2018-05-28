#import <UIKit/UIKit.h>

#import "ImageAnimator.h"

@implementation ImageAnimator

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object {
    if ([object isKindOfClass: [UIImageView class]]){
        UIImageView* imageView = (UIImageView*)object;
        NSNumber* duration = [config objectForKey: @"element_totalTransitTime"] ;
        NSNumber* repeatCount = [config objectForKey: @"repeatCount"] ;
        
        imageView.animationDuration = (duration != NULL) ? [duration floatValue] : 0.05 ;
        imageView.animationRepeatCount = (repeatCount != NULL) ? [repeatCount intValue] : 1;   // if is "0" , it will repeat all the times
        [imageView startAnimating];
    } 
}

@end
