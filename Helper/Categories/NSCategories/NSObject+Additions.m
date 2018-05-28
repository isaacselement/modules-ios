
#import "NSObject+Additions.h"

#import <objc/runtime.h>

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation NSObject (Additions)


-(NSMutableDictionary *)dictionaryWithPropertiesValues {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dictionary setObject: [self valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return dictionary;
}


-(void) logProperties {
    
    NSLog(@"----------------------------------------------- Properties & Values for object %@", self);
    
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
        for (NSUInteger i = 0; i < numberOfProperties; i++) {
            objc_property_t property = propertyArray[i];
            NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
            
// just print if in simulator, no error occurs
//#if TARGET_IPHONE_SIMULATOR
            NSLog(@"Property: %@ - Value: %@", propertyName, [self valueForKey:propertyName]);
//            return;
//#endif
            
            /*
            NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];    // "T{CGPoint=ff},N"
            NSArray * attributesArray = [propertyAttributes componentsSeparatedByString:@","];
            NSString * typeAttribute = [attributesArray firstObject];                                           // "T{CGPoint=ff}"
            NSString * propertyType = [typeAttribute substringFromIndex:1];                                     // "{CGPoint=ff}"
            
            id value = [self valueForKey:propertyName];
            const char* rawType = [propertyType UTF8String];
            if (strcmp(rawType, @encode(CGRect)) == 0) {
                
            } else if (strcmp(rawType, @encode(CGPoint)) == 0) {
                
            } else if (strcmp(rawType, @encode(CGSize)) == 0) {
                
            } else if (strcmp(rawType, @encode(short)) == 0
                       || strcmp(rawType, @encode(int)) == 0
                       || strcmp(rawType, @encode(unsigned int)) == 0) {
                
                NSLog(@"Property: %@ - Value: %d", propertyName, (int)value);
                
            } else if (strcmp(rawType, @encode(long)) == 0
                       || strcmp(rawType, @encode(unsigned long)) == 0
                       || strcmp(rawType, @encode(long long)) == 0
                       || strcmp(rawType, @encode(unsigned long long)) == 0) {
                
                NSLog(@"Property: %@ - Value: %ld", propertyName, (long)value);
                
            } else if (strcmp(rawType, @encode(Boolean)) == 0
                       || strcmp(rawType, @encode(_Bool)) == 0
                       || strcmp(rawType, @encode(BOOL)) == 0) {
                
                NSLog(@"Property: %@ - Value: %d", propertyName, (BOOL)value);
                
            } else {
                
                NSLog(@"Property: %@ - Value: %@", propertyName, value);
                
            }
            */
        
        }
        free(propertyArray);
    }
    NSLog(@"-----------------------------------------------");
}


@end







@implementation NSArray (AdditionsEx)


-(NSMutableArray *)dictionaryWithPropertiesValues {
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < self.count; i++) {
        id obj = [self objectAtIndex:i];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        unsigned count;
        objc_property_t *properties = class_copyPropertyList([obj class], &count);
        
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            [dictionary setObject: [obj valueForKey:key] forKey:key];
        }
        
        free(properties);
        
        [result addObject:dictionary];
    }
    
    return result;
    
}

@end


