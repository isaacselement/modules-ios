#import "FontHelper.h"
#import "KeyValueHelper.h"
#include <CoreText/CoreText.h>

@implementation FontHelper


// Just For Bold and Italic situation
// http://iphonedevwiki.net/index.php/UIFont

+(void) listAllFontNames
{
    NSArray* familiesNames = [UIFont familyNames];
    NSLog(@"%@", familiesNames);
    for (NSString* family in familiesNames) {
        NSArray* array = [UIFont fontNamesForFamilyName: family];
        NSLog(@"%@ : %@", family, array);
    }
    
    UIFont* font1 = [UIFont systemFontOfSize: [UIFont systemFontSize]];
    NSLog(@"%@ - %f", font1.fontName, font1.pointSize);
    
    UIFont* font2 = [UIFont boldSystemFontOfSize: [UIFont labelFontSize]];
    NSLog(@"%@ - %f", font2.fontName, font2.pointSize);
    
    UIFont* font3 = [UIFont italicSystemFontOfSize: [UIFont buttonFontSize]];
    NSLog(@"%@ - %f", font3.fontName, font3.pointSize);
    
}


// need CoreText.framework, path is true type font file path
+(UIFont*) getFontFromTTFFile: (NSString*)path withSize:(int)fontSize {
    NSString* ttfPath = [KeyValueHelper getResourcePath: path];
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([ttfPath UTF8String]);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    
    // get the font name
    NSString *fontName = (__bridge_transfer NSString *)CGFontCopyPostScriptName(fontRef);
    CTFontManagerRegisterGraphicsFont(fontRef, nil);
    CGFontRelease(fontRef);
    
    // instance a UIFont
    UIFont* font = [UIFont fontWithName: fontName size:fontSize];
    return font;
}


@end
