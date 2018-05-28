#import "CategoriesLocalizer.h"


#ifndef LOCALIZE_i18n_PREFIX
#define LOCALIZE_i18n_PREFIX @"i18n"
#endif

#ifndef LOCALIZE_TABLE_FORMAT
#define LOCALIZE_TABLE_FORMAT @"_%@"
#endif

// dic with array in it
static NSDictionary* categories;

@implementation CategoriesLocalizer


+(void) setCategories: (NSDictionary*)_categories
{
    categories = _categories;
}

+(NSDictionary*) categories
{
    return categories;
}


/**
 *
 *  @param key key with format "Employee.employeeNO"
 *
 *  @return the localize values
 */
+(NSString*) getCategoriesLocalized: (NSString*)key
{
    return [self getCategoriesLocalized: key kind:nil];
}

+(NSString*) getCategoriesLocalized: (NSString*)key kind:(NSString*)kind
{
    NSString* result = key;
    
    if ([key rangeOfString: LOCALIZE_KEY_CONNECTOR].location == NSNotFound) {
        result = [CategoriesLocalizer getCategoriesLocalized: key kind:kind category:nil];
        
    } else {
        
        NSArray* array = [key componentsSeparatedByString:LOCALIZE_KEY_CONNECTOR];
        NSString* item = [array firstObject];
        NSString* attr = [array lastObject];
        
        // get category by item
        NSString* category = [CategoriesLocalizer getCategoryByItem:item];
        // search : 1 i18n_[kind]_Finance_en.strings with key , 2 i18n_[kind]_Finance_en.stringw with attr, 3 i18n_[kind]_en.strings with key , 4 i18n_[kind]_en.strings with attr
        // finally : not find , retur the key as result
        
        if (category) result = [CategoriesLocalizer getCategoriesLocalized: key kind:kind category:category];
        if ([result isEqualToString: key]) [CategoriesLocalizer getCategoriesLocalized: attr kind:kind category:category];
        
        if ([result isEqualToString: attr]) result = [CategoriesLocalizer getCategoriesLocalized:key kind:kind category:nil];
        if ([result isEqualToString: key]) result = [CategoriesLocalizer getCategoriesLocalized:attr kind:kind category:nil];
        if ([result isEqualToString: attr]) result = key;
    }
    
    return result;
}


#pragma mark -

+(NSString*) connectKeys: (NSString*)item attribute:(NSString*)attribute
{
    if (item) {
        return [NSString stringWithFormat:@"%@%@%@", item, LOCALIZE_KEY_CONNECTOR, attribute];
    }
    return attribute;
}
+(NSString*) getCategoryByItem: (NSString*)item
{
    for (NSString* category in categories) {
        NSArray* items = [categories objectForKey: category];
        for (NSString* atom in items)  if ([atom isEqualToString: item]) return category;
    }
    return nil;
}


#pragma mark - 

+(NSString*) getCategoriesLocalized: (NSString*)key kind:(NSString*)kind category:(NSString*)category {
    return [self getCategoriesLocalized: key kind:kind category:category language:super.currentLanguage];
}

+(NSString*) getCategoriesLocalized: (NSString*)key kind:(NSString*)kind category:(NSString*)category language:(NSString*)language  {
    NSString* table = [CategoriesLocalizer getTableName:kind category:category language:language];
    NSString* value = [super getLocalized: key language: table];
    return value;
}

+(NSString*) getTableName: (NSString*)kind category:(NSString*)category language:(NSString*)language
{
    NSString* table = LOCALIZE_i18n_PREFIX;
    
    if (kind)       table = [table stringByAppendingFormat:LOCALIZE_TABLE_FORMAT,   kind];
    if (category)   table = [table stringByAppendingFormat:LOCALIZE_TABLE_FORMAT,   category];
    if (language)   table = [table stringByAppendingFormat:LOCALIZE_TABLE_FORMAT,   language];
    
    return table;
}


#pragma mark - Helper

+(NSString*) connect: (NSString*)key, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray* keys = [NSMutableArray array];
    
    va_list list;
    va_start(list, key);
    do {
        [keys addObject: key];
        key = va_arg(list, NSString*);
    } while (key);
    va_end(list);
    
    return [self connectKeys: keys];
}

+(NSString*) connectKeys: (NSArray*)keys
{
    return [LOCALIZE_KEYS_PREFIX stringByAppendingString: [keys componentsJoinedByString: LOCALIZE_KEY_CONNECTOR]];
}

// array with key
+(NSMutableArray*) localize: (NSArray*)array
{
    NSInteger count = array.count;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity: count];
    for (int i = 0; i < count; i++) {
        NSString* key = array[i];
        NSString* localizeValue = LOCALIZE_KEY(key);
        [results addObject: localizeValue];
    }
    return results;
}

@end
