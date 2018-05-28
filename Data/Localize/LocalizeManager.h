#import <Foundation/Foundation.h>


#define LANGUAGE_en         @"en"
#define LANGUAGE_zh         @"zh"

#define LANGUAGE_zh_HK      @"HK"
#define LANGUAGE_zh_TW      @"TW"

#define LANGUAGE_zh_Hans    @"zh-Hans"
#define LANGUAGE_zh_Hant    @"zh-Hant"


#define I18N(_key) [LocalizeManager getLocalized: _key]

#define I18NS(_key, args...) [LocalizeManager connect: _key, ##args, nil]

#define I18NFormat(_key, args...) [NSString stringWithFormat: I18N(_key), ##args]



@interface LocalizeManager : NSObject


+(NSString*) currentLanguage ;

+(void) setCurrentLanguage: (NSString*)language ;


+(void) setStringsFileSanboxPath: (NSString*)path ;


+(NSString*) getLocalized: (NSString*)key ;

+(NSString*) getLocalized:(NSString *)key language:(NSString*)language;


#pragma mark - Helper Methods

+(NSString*) connect: (NSString*)key, ... NS_REQUIRES_NIL_TERMINATION;

@end
