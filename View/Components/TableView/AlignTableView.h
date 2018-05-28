#import "FilterTableView.h"

#define ALIGNTABLE_CELL_LABEL_TAG(_index) (_index + 505)
#define ALIGNTABLE_HEADER_LABEL_TAG(_index) (_index + 202)

/**
 *  
 *  Note , for more than one sections , the header will be the same 
 *
 *  So , for multi sections, pass the two dimensions array of headers and valuesXcoordinates, against to contentsDictionary
 *
 */


// import !!! Just for section header
@interface AlignTableView : FilterTableView

// array of string @[@"1H",@"2H"] or @[@[@"1H",@"2H"],@[@"1H",@"2H"]]
@property (strong) NSArray* headers ;

// here , tow dimension array of number @[@(50),@(250)] or @[@[@(50),@(250)], @[@(50),@(250)]]
@property (strong) NSArray* headersXcoordinates;
@property (strong) NSArray* valuesXcoordinates;

@property (strong) NSArray* headersYcoordinates;
@property (strong) NSArray* valuesYcoordinates;


#pragma mark - AlignTableView Class Object Methods

+ (void)setAlignHeaders: (Class)labelClass headerView:(UIView*)headerView headers:(NSArray*)headers headersXcoordinates:(NSArray*)headersXcoordinates headersYcoordinates:(NSArray*)headersYcoordinates;

+ (void)separateCellTextToAlignHeaders: (TableViewBase*)tableView cell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath valuesXcoordinates:(NSArray*)valuesXcoordinates valuesYcoordinates:(NSArray*)valuesYcoordinates;

@end
