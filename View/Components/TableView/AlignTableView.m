#import "AlignTableView.h"
#import "TableViewBaseContentHelper.h"
#import "ViewHelper.h"

#import "_Frame.h"
#import "FrameHelper.h"
#import "FrameTranslater.h"

#import "ArrayHelper.h"

#import "_Label.h"

@implementation AlignTableView

@synthesize headers;

@synthesize headersXcoordinates;
@synthesize valuesXcoordinates;

@synthesize headersYcoordinates;
@synthesize valuesYcoordinates;


#pragma mark - UITableViewDelegate
// this header is for sections, not for the whole table
// for the whole table , use HeaderTableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (! self.headers) return nil; // return nil , indicate that use the default section view.
    
    // we create the header view
    NSArray* sectionsHeaders = [ArrayHelper isTwoDimension: headers] ? [headers objectAtIndex: section] : headers;
    NSArray* sectionsHeaderXCoordinates = [ArrayHelper isTwoDimension: headersXcoordinates] ? [headersXcoordinates objectAtIndex: section] : headersXcoordinates;
    NSArray* sectionsHeaderYCoordinates = [ArrayHelper isTwoDimension: headersYcoordinates] ? [headersYcoordinates objectAtIndex: section] : headersYcoordinates;
    
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5];
    [AlignTableView setAlignHeaders:nil headerView:headerView headers:sectionsHeaders headersXcoordinates:sectionsHeaderXCoordinates headersYcoordinates:sectionsHeaderYCoordinates];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    valuesXcoordinates = valuesXcoordinates ? valuesXcoordinates : headersXcoordinates;
    NSArray* valueXCoordinates = [ArrayHelper isTwoDimension: valuesXcoordinates] ? [valuesXcoordinates objectAtIndex: indexPath.section] : valuesXcoordinates;
    NSArray* valueYCoordinates = [ArrayHelper isTwoDimension: valuesYcoordinates] ? [valuesYcoordinates objectAtIndex: indexPath.section] : valuesYcoordinates;
    
    [AlignTableView separateCellTextToAlignHeaders: self cell:cell indexPath:indexPath  valuesXcoordinates:valueXCoordinates valuesYcoordinates:valueYCoordinates];
    
    [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}







#pragma mark - AlignTableView Class Object Methods

+ (void)setAlignHeaders: (Class)labelClass headerView:(UIView*)headerView headers:(NSArray*)headers headersXcoordinates:(NSArray*)headersXcoordinates headersYcoordinates:(NSArray*)headersYcoordinates
{
    NSUInteger count = headers.count;
    if (!labelClass) labelClass = [UILabel class];
    // set up contents & labels with x coordinate
    for (int i = 0; i < count; i++) {
        NSString* labelText = [headers objectAtIndex:i];
        
        // init label
        UILabel* label = (UILabel*)[headerView viewWithTag:ALIGNTABLE_HEADER_LABEL_TAG(i)];
        if (!label) {
            label = [[labelClass alloc] initWithText:labelText];
            [self setLabelDefaultProperties: label];
            label.tag = ALIGNTABLE_HEADER_LABEL_TAG(i);
            [headerView addSubview:label];
        }
        
        
        // set frame
        CGRect labelCanvas = [self getLabelCanvas:i xCoordinates:headersXcoordinates yCoordinates:headersYcoordinates];
        label.frame = [FrameTranslater convertCanvasRect: labelCanvas];
        
        // adjust width by text content
        label.text = labelText;
        [label adjustWidthToFontText];
    }
}


+ (void)separateCellTextToAlignHeaders: (TableViewBase*)tableView cell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath valuesXcoordinates:(NSArray*)valuesXcoordinates valuesYcoordinates:(NSArray*)valuesYcoordinates
{
    id texts = [tableView contentForIndexPath: indexPath];  // may be string , may be array
    
    // is string
    if ([texts isKindOfClass: [NSString class]]) {
        // the text is apply to cell.textLabel
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    // is array
    } else if ([texts isKindOfClass:[NSArray class]]) {
        
        cell.textLabel.hidden = YES;        // hide the original text
        NSUInteger count = [texts count];        // == headers count
        
        // if not label , initialize the label
        for (int i = 0; i < count;  i++) {
            UILabel* label = (UILabel*)[cell viewWithTag:ALIGNTABLE_CELL_LABEL_TAG(i)] ;
            if (!label) {
                label = [[UILabel alloc] initWithText:nil];
                [self setLabelDefaultProperties: label];
                label.tag = ALIGNTABLE_CELL_LABEL_TAG(i);
                [cell.contentView addSubview:label];
                
                // set frame
                CGRect labelCanvas = [self getLabelCanvas:i xCoordinates:valuesXcoordinates yCoordinates:valuesYcoordinates];
                label.frame = [FrameTranslater convertCanvasRect: labelCanvas];
                if (! valuesYcoordinates) {
                    [label setCenterY: [tableView.delegate tableView: tableView heightForRowAtIndexPath:[tableView indexPathForCell: cell]] / 2];
                }
            }
        }
        
        // ios 7 [cell addSubview:label], the label add to the firstObject is [UITableViewCellScrollerView]
        // ios 6 no  problem ,add to cell , and its firstObject is [UITableViewCellContentView]
        
        // Pair A . first hidden , set the text to empty
        [ViewHelper iterateSubView:cell.contentView class:[UILabel class] handler:^BOOL(id subView) {
            UILabel* label = (UILabel*)subView;
            if (label != cell.textLabel) {
                label.text = nil;
            }
            return NO;
        }];
        
        // Pair B . second show , set the content
        for (int i = 0; i < count; i++) {
            UILabel* label = (UILabel*)[cell viewWithTag:ALIGNTABLE_CELL_LABEL_TAG(i)];
            
            id value = texts[i];
            label.text = [TableViewBaseContentHelper getStringValue: value];
            // adjust width by text content
            [label adjustWidthToFontText];
        }
        
    }
    
}


#pragma mark - Private Methods

+ (void)setLabelDefaultProperties: (UILabel*)label
{
    label.textAlignment = NSTextAlignmentLeft;
    // set font size
    float size = [FrameTranslater convertFontSize: 20];
    label.font = [UIFont systemFontOfSize: size];
}

+ (CGRect)getLabelCanvas: (int)index xCoordinates:(NSArray*)xCoordinates yCoordinates:(NSArray*)yCoordinates {
    NSNumber* xNum = xCoordinates.count > index ? [xCoordinates objectAtIndex: index] : nil;
    float coordinateX = xNum ? [xNum floatValue] : 200 * index;             // default interval 200
    
    int temp = index;
    NSNumber* yNum = nil;
    while (temp >= 0 && !yNum) {
        yNum = yCoordinates.count > temp ? [yCoordinates objectAtIndex: temp] : nil;
        temp--;
    }
    float coordinateY = yNum ? [yNum floatValue] : 0;                       // default get the last one
    
    CGRect labelCanvas = CGRectMake(coordinateX, coordinateY, 25, 25);
    return labelCanvas;
}

@end
