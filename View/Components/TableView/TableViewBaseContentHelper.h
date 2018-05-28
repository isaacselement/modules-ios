#import <Foundation/Foundation.h>


@class TableViewBase;

@interface TableViewBaseContentHelper : NSObject

+(NSString*) getStringValue: (id)value;


#pragma mark - Handler Real Content Dictionary
/**
 *
 *  @param objects objects are three dimension
 *  @param keys    the outtest dimension of objects against tho keys
 *
 *  @return realContentsDictionary
 */
+(NSMutableDictionary*) assembleToRealContentDictionary: (NSArray*)objects keys:(NSArray*)keys ;






#pragma mark - Iterate Contents

+(void) iterateContents: (NSDictionary*)contents handler:(BOOL (^)(id key, int section, id cellContent))handler;





#pragma mark - Util - iterate and return the new contents dictionary

+(NSMutableDictionary*) iterateContentsToSection: (NSDictionary*)contents handler:(void (^)(int, int, NSString*, NSArray*, NSMutableArray*))handler;

+(NSMutableDictionary*) iterateContentsToCell: (NSDictionary*)contents handler:(void (^)(int, int, int, NSString*, id, NSMutableArray*))handler;


#pragma mark - Insert Content

// To Be Extended
+(void) insertToFirstRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSArray*)contents realContent:(id)realContent;


@end
