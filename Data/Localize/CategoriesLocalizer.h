#import <Foundation/Foundation.h>
#import "LocalizeManager.h"


#define LOCALIZE_KEYS_PREFIX     @"KEYS."

#define LOCALIZE_KEY(_key) [CategoriesLocalizer getCategoriesLocalized: _key]
#define LOCALIZE_MESSAGE(_key) [CategoriesLocalizer getCategoriesLocalized: _key kind:@"MESSAGE"]
#define LOCALIZE_DESCRIPTION(_key) [CategoriesLocalizer getCategoriesLocalized: _key kind:@"DESCRIPTION"]


#define LOCALIZE_KEY_CONNECTOR @"."
#define LOCALIZE_CONNECT_KEYS(_item, _attr) [CategoriesLocalizer connectKeys:_item attribute:_attr]
#define LOCALIZE_MESSAGE_FORMAT(_key, args...) [NSString stringWithFormat: LOCALIZE_MESSAGE(_key), ##args]


// Convention:

// Table name should be : Localize_[Kind]_[Category]_{en|zh-Hans...}.stringa
// ie : i18n_message_HumanResource_en.strings


// First :
// categories forbid that two different keys have the same value . i.e.
// @{@"HumanResource":[@"item_A", @"item_B"], @"Finance":[@"item_A",@"item_C"]}
// the @"item_A" is duplicated , avoid that !!! importmant .

// Second :
// in .strings files , key and localize value do not use the same charachters. i.e.

@interface CategoriesLocalizer : LocalizeManager

+(NSDictionary*) categories;
+(void) setCategories: (NSDictionary*)categories;




+(NSString*) getCategoriesLocalized: (NSString*)key;
+(NSString*) getCategoriesLocalized: (NSString*)key kind:(NSString*)kind;


#pragma mark -
+(NSString*) connectKeys: (NSString*)item attribute:(NSString*)attribute;
+(NSString*) getCategoryByItem: (NSString*)item;


#pragma mark -
+(NSString*) getCategoriesLocalized: (NSString*)key kind:(NSString*)kind category:(NSString*)category;
+(NSString*) getCategoriesLocalized: (NSString*)key kind:(NSString*)kind category:(NSString*)category language:(NSString*)language;
+(NSString*) getTableName: (NSString*)kind category:(NSString*)category language:(NSString*)language;


#pragma mark - Helper

+(NSString*) connect: (NSString*)key, ... NS_REQUIRES_NIL_TERMINATION;

+(NSString*) connectKeys: (NSArray*)keys;

+(NSMutableArray*) localize: (NSArray*)array;

@end
