#import "TableViewBaseContentHelper.h"

// _Helper.h
#import "IterateHelper.h"
#import "DictionaryHelper.h"

// _View.h
#import "AlignTableView.h"

@implementation TableViewBaseContentHelper


+(NSString*) getStringValue: (id)value
{
    NSString* text = nil;
    
    if ([value isKindOfClass: [NSString class]]) text = value;
    
    else if ([value isKindOfClass: [NSNumber class]]) text = [value stringValue];
    
    return text;
}


#pragma mark - Handler Real Content Dictionary

+(NSMutableDictionary*) assembleToRealContentDictionary: (NSArray*)objects keys:(NSArray*)keys {
    NSMutableDictionary* realContentsDictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < objects.count; i++) {
        NSArray* modelObjects = [objects objectAtIndex: i];
        NSArray* contents = [self assembleToSectionContents: modelObjects];
        [realContentsDictionary setObject: contents forKey:keys[i]];
    }
    return realContentsDictionary;
}
+(NSMutableArray*) assembleToSectionContents: (NSArray*)modelObjects {
    NSMutableArray* contents = [NSMutableArray array];
    for (int j = 0; j < modelObjects.count; j++) {
        NSArray* fieldValues = [modelObjects objectAtIndex: j];
        NSArray* cellValues = [self assembleToCellValues: fieldValues];
        [contents addObject: cellValues];
    }
    return contents;
}
+(NSMutableArray*) assembleToCellValues: (NSArray*)fieldValues {
    NSMutableArray* cellValues = [NSMutableArray array];
    for (int e = 0; e < fieldValues.count; e++) {
        id atom = [fieldValues objectAtIndex: e];
        [cellValues addObject: atom];
    }
    return cellValues;
}

#pragma mark - Iterate Contents

/**
 *  @param dictionary the dic with nsarray in it
 *  @param handler               inner handler
 */
+(void) iterateContents: (NSDictionary*)contents handler:(BOOL (^)(id key, int section, id cellContent))handler
{
    for (NSString* key in contents) {
        NSArray* sections = contents[key];
        for (int i = 0; i < sections.count; i++) {
            id cellContent = sections[i];                 // maybe nsarray , may be nsstring, or anything , decide by u pass the dictionary
            if(handler(key, i, cellContent)) return;
        }
    }
}




#pragma mark - Util - iterate and return the new contents dictionary

// handler: int index, int outterCount, NSString* section, NSArray* cellValues, NSMutableArray* sectionRep
+(NSMutableDictionary*) iterateContentsToSection: (NSDictionary*)contents handler:(void (^)(int, int, NSString*, NSArray*, NSMutableArray*))handler
{
    NSArray* keys = [DictionaryHelper getSortedKeys: contents];
    NSMutableDictionary* newDictionary = [NSMutableDictionary dictionary];
    [IterateHelper iterate: keys handler:^BOOL(int index, id section, int count) {
        NSArray* sectionContents = [contents objectForKey: section];
        NSMutableArray* newSectionContents = [NSMutableArray array];
        [IterateHelper iterate: sectionContents handler:^BOOL(int index, id obj, int count) {
            if (handler) handler(index, count, section,  obj, newSectionContents);
            return NO;
        }];
        [newDictionary setObject: newSectionContents forKey:section];
        return NO;
    }];
    return newDictionary;
}


// handler:  int index, int innerCount, int outterCount, NSString* section, id obj, NSMutableArray* cellRep
+(NSMutableDictionary*) iterateContentsToCell: (NSDictionary*)contents handler:(void (^)(int, int, int, NSString*, id, NSMutableArray*))handler
{
    return [self iterateContentsToSection:contents handler:^(int index, int outterCount, NSString* section, NSArray *cellValues, NSMutableArray *sectionRep) {
        
        NSMutableArray* newCellValues = [NSMutableArray array];
        [IterateHelper iterate: cellValues handler:^BOOL(int index, id cellValue, int count) {
            if (handler) handler(index, count, outterCount, section, cellValue, newCellValues);
            return NO;
        }];
        [sectionRep addObject: newCellValues];
        
    }];
}



#pragma mark - Insert Content

// To Be Extended
+(void) insertToFirstRowWithAnimation: (TableViewBase*)tableView section:(int)section content:(NSArray*)contents realContent:(id)realContent
{
    if (! tableView.contentsDictionary) {
        tableView.contentsDictionary = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@""];
        tableView.realContentsDictionary = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@""];
        [tableView reloadData];
    }
    
    // insert data
    NSMutableArray* sectionsContents = [tableView contentsForSection: section];
    NSMutableArray* realSectionsContents = [tableView realContentsForSection: section];
    
    // check if already has this content
    if ([sectionsContents containsObject: contents]) {
        NSUInteger row = [sectionsContents indexOfObject: contents];
        NSIndexPath* containsIndexPath = [NSIndexPath indexPathForRow: row inSection:section];
        [tableView selectRowAtIndexPath:containsIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
    } else {
        
//        NSUInteger row = sectionsContents.count ? sectionsContents.count - 1 : 0;      // get the last row
        
        NSUInteger row =  0;
        [sectionsContents insertObject: contents atIndex: row ];
        [realSectionsContents insertObject: realContent atIndex:row];
        NSIndexPath* insertIndexPath = [NSIndexPath indexPathForRow: row inSection:section];
        [tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        // scroll to the position of inserted indexPath
        [tableView scrollToRowAtIndexPath: insertIndexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
    
}


@end
