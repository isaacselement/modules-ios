#import "HTTPRequestBase.h"

#define POST_Body_Data          @"POST_Body_Data"
#define POST_Form_Parameters    @"POST_Form_Parameters"

@interface HTTPPostRequest : HTTPRequestBase


+(NSString*) translateFormParametersToString:(NSDictionary*)parameters;
+(NSMutableDictionary*) translateStringToFormParameters:(NSString*)string;

+(void) setFormParameters: (NSMutableURLRequest*)request parameters:(NSDictionary*)parameters;



@end
