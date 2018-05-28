#import <UIKit/UIKit.h>

@interface ActionExecutorBase : NSObject {    
    @private
    @protected
}

#pragma mark - Public Properties

#pragma mark - Public Methods
-(void) execute:(NSDictionary*)config objects:(NSArray*)objects values:(NSArray*)values times:(NSArray*)times ;

#pragma mark - Protected Methods

-(void) execute: (NSDictionary*)config onObject:(NSObject*)object;

#pragma mark - Private Methods

@end
