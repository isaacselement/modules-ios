#import "HTTPPostRequest.h"
#import "NSString+URLEncode.h"

@implementation HTTPPostRequest

#pragma mark - Overwrite Methods
-(void) applyRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters {
    [request setHTTPMethod:@"POST"];
    
    if (!request.HTTPBody) {
        request.HTTPBody = [NSMutableData data];
    }
    NSMutableData* httpBody = (NSMutableData*)request.HTTPBody;
    
    NSDictionary* formParameters = parameters[POST_Form_Parameters];
    NSData* postNSData = parameters[POST_Body_Data];
    
    // if no POST_Body_Data & POST_Form_Parameters specified , regard it as  formParameters;
    if (! formParameters && ! postNSData) {
        formParameters = parameters;
    }
    
    // form data format should be "key1=value1&key2=value2&key3=value3"
    if (formParameters) {
        [HTTPPostRequest setFormParameters: request parameters:formParameters];
    }
    
    // post data
    if (postNSData) {
        [httpBody appendData: postNSData];
    }
    
}



+(void) setFormParameters: (NSMutableURLRequest*)request parameters:(NSDictionary*)parameters
{
    if (!request.HTTPBody) {
        request.HTTPBody = [NSMutableData data];
    }
    NSMutableData* httpBody = (NSMutableData*)request.HTTPBody;
    NSString* string = [HTTPPostRequest translateFormParametersToString: parameters];
    [httpBody appendData: [string dataUsingEncoding: NSUTF8StringEncoding]];
    
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];    // @"text/plain" (in java end , u need get Reader or InputStream to read byte[])
}

+(NSString*) translateFormParametersToString:(NSDictionary*)parameters
{
    NSMutableArray* formsArray = [NSMutableArray array];
    for(NSString* key in parameters) {
        NSString* value = [HTTPPostRequest getValue: parameters[key]];
        NSString* element = [[key stringByAppendingString:@"="] stringByAppendingString:value];
        [formsArray addObject: element];
    }
    NSString* string = [formsArray componentsJoinedByString: @"&"];
    return string;
}

+(NSMutableDictionary*) translateStringToFormParameters:(NSString*)string
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    NSArray* formsArray = [string componentsSeparatedByString: @"&"];
    for (NSString* element in formsArray) {
        NSArray* keyValue = [element componentsSeparatedByString:@"="];
        NSString* key = [keyValue firstObject];
        NSString* value = [keyValue lastObject];
        [parameters setObject: value forKey:key];
    }
    return parameters;
}

+(NSString*) getValue: (id)value
{
    NSString* string = nil;
    if ([value isKindOfClass: [NSString class]]) {
        string = value;
    } else {
        string = [NSString stringWithFormat:@"%@", value];  // NSNumber , or something else
    }
    return [string URLEncode];
}





@end
