#import "ActionExecutorBase.h"

// label
#define JSON_TTF                    @"TTF"
#define JSON_FONT_NAME              @"FONT_NAME"
#define JSON_FONT_SIZE              @"FONT_SIZE"


// -- StrokeLabel
#define JSON_STROKE_MODE            @"STROKE.Mode"
#define JSON_STROKE_WIDTH           @"STROKE.Width"
#define JSON_STROKE_COLOR           @"STROKE.Color"


// -- GradientLabel
#define JSON_GRADIENT_COUNT         @"GRADIENT.count"

#define JSON_GRADIENT_ENDCOLOR      @"GRADIENT.endColor"
#define JSON_GRADIENT_STARTCOLOR    @"GRADIENT.startColor"

#define JSON_GRADIENT_ENDPOINT      @"GRADIENT.endPoint"
#define JSON_GRADIENT_STARTPOINT    @"GRADIENT.startPoint"


@interface TextFormatter : ActionExecutorBase


+(TextFormatter*) sharedInstance;


@end
