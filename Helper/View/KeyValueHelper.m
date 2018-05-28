#import "KeyValueHelper.h"

#import "ColorHelper.h"
#import "RectHelper.h"
#import "FrameTranslater.h"

#import <objc/runtime.h>

#define TYPE_UICOLOR            @"UIColor"
#define TYPE_UIIMAGE            @"UIImage" 

#define TYPE_CATRANSFORM3D      @"CATransform3D"
#define TYPE_CGAFFINETRANSFORM  @"CGAffineTransform"


@implementation KeyValueHelper
{
    KeyValueCodingTranslator translateValueHandler;
}
-(KeyValueCodingTranslator) translateValueHandler
{
    return translateValueHandler;
}

-(void) setTranslateValueHandler:(KeyValueCodingTranslator)handler
{
    translateValueHandler = handler;
}

#pragma mark - Public Methods

-(void) setValues:(NSDictionary*)config object:(NSObject*)object
{
    NSDictionary* propertiesTypes = [KeyValueHelper getClassPropertieTypes: [object class]];
    for (NSString* key in config) {
        id value = config[key];
        [self setValue: value keyPath:key object:object propertiesTypes:propertiesTypes];
    }
}

-(void) setValue:(id)value keyPath:(NSString*)keyPath object:(NSObject*)object
{
    [self setValue:value keyPath:keyPath object:object propertiesTypes:nil];
}

-(void) setValue:(id)value keyPath:(NSString*)keyPath object:(NSObject*)object propertiesTypes:(NSDictionary*)propertiesTypes
{
    if (!propertiesTypes) {
        propertiesTypes = [KeyValueHelper getClassPropertieTypes: [object class]];
    }
    NSString* propertyType = propertiesTypes[keyPath];
    id translatedValue = [self translateValue:value type:propertyType object:object keyPath:keyPath];
    
    // i.e. override the "-(void) setValue:(id)value forUndefinedKey:(NSString *)key" method
    [object setValue:translatedValue forKeyPath: keyPath];
}

-(id) translateValue:(id)value type:(NSString*)type object:(NSObject*)object keyPath:(NSString*)keyPath
{
    if (translateValueHandler) {
        return translateValueHandler(object, value, type, keyPath);
    } else {
        return [KeyValueHelper translateValue: value type:type];
    }
}

#pragma mark - Class Methods

static KeyValueHelper* sharedInstance = nil;

+(KeyValueHelper*) sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[KeyValueHelper alloc] init];
    }
    return sharedInstance;
}

+(void) setSharedInstance:(KeyValueHelper*)obj
{
    sharedInstance = obj;
}

// http://imapisit.com/post/18508442936/programmatically-get-property-name-type-value-with
// if you want a list of what will be returned for these primitives, search online for
// "objective-c" "Property Attribute Description Examples"
// apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
// http://blog.csdn.net/icmmed/article/details/17298961
// http://stackoverflow.com/questions/16861204/property-type-or-class-using-reflection
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
+(NSMutableDictionary *)getClassPropertieTypes:(Class)clazz
{
    if (clazz == NULL) return nil;
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    while (clazz != NULL) {
        
        unsigned int count, i;
        
        objc_property_t *properties = class_copyPropertyList(clazz, &count);
        
        for (i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            const char *attributes = property_getAttributes(property);
            
            NSString *propertyName = [NSString stringWithUTF8String:name];
            
            NSString* propertyAttributes = [NSString stringWithUTF8String:attributes];              // "T{CGPoint=ff},N"
            NSArray * attributesArray = [propertyAttributes componentsSeparatedByString:@","];
            NSString * typeAttribute = [attributesArray firstObject];                               // "T{CGPoint=ff}"
            NSString * propertyType = [typeAttribute substringFromIndex:1];                         // "{CGPoint=ff}"
            
            [results setObject:propertyType forKey:propertyName];                                   // Cause @encode(CGPoint) = "{CGPoint=ff}"
        }
        free(properties);
        
        clazz = [clazz superclass];
    }
    return results;
}

// TODO ... UIFont , UIEdgeInset ... and so on
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html
+(id) translateValue:(id)value type:(NSString*)type
{
    if (!type) return value;
    
    id result = value;
    const char* rawType = [type UTF8String];
    
    if (strcmp(rawType, @encode(CGColorRef)) == 0) {
        result = (id)[ColorHelper parseColor: value].CGColor;
        
    } else if (strcmp(rawType, @encode(CGRect)) == 0) {
        result = [NSValue valueWithCGRect: CanvasCGRect([RectHelper parseRect: value])];
        
    } else if (strcmp(rawType, @encode(CGPoint)) == 0) {
        result = [NSValue valueWithCGPoint: CanvasCGPoint([RectHelper parsePoint: value])];
        
    } else if (strcmp(rawType, @encode(CGSize)) == 0) {
        result = [NSValue valueWithCGSize: CanvasCGSize([RectHelper parseSize: value])];
        
    } else if ([self isType:TYPE_UICOLOR keyPathType:type]) {
        result = (id)[ColorHelper parseColor: value];
        
    } else if ([self isType:TYPE_UIIMAGE keyPathType:type]) {
        if ([value isKindOfClass:[NSString class]]) {
            result = [self getUIImageByPath: value];
        }
    }
    
    return result;
}

#pragma mark - Utilities Methods

#define kRootDirectoryString @"/"
#define kHomeDirectoryString @"~"

+(UIImage*) getUIImageByPath: (NSString*)path
{
    if ([path hasPrefix:kRootDirectoryString]) {
        return [UIImage imageWithContentsOfFile: path];
        
    } else if ([path hasPrefix:kHomeDirectoryString]) {
        return [UIImage imageWithContentsOfFile: [path stringByReplacingOccurrencesOfString:kHomeDirectoryString withString:NSHomeDirectory()]];
        
    } else {
        return [UIImage imageNamed: path];
    }
    return nil;
}

+(NSString*) getResourcePath: (NSString*)path
{
    NSString* result = path;
    if ([path hasPrefix:kRootDirectoryString]) {
        // do nothing
        
    } else if ([path hasPrefix:kHomeDirectoryString]) {
        result = [path stringByReplacingOccurrencesOfString:kHomeDirectoryString withString:NSHomeDirectory()];
        
    } else {
        result = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: path];
        
    }
    
    return result;
}

+(BOOL) isType:(NSString*)type keyPathType:(NSString*)keyPathType
{
    if (! keyPathType) return false;
    
    return [keyPathType rangeOfString:type].location != NSNotFound;
}

@end
