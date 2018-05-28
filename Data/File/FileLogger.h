#import <Foundation/Foundation.h>

@interface FileLogger : NSObject


@property (nonatomic, strong) NSString *logFilePath;


+ (FileLogger *)getInstance;


- (void)startLogging;

- (void)stopLogging;

- (BOOL)deleteLogFile;

- (NSString *)contents;


@end
