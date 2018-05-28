#import "FileLogger.h"

@implementation FileLogger

+ (FileLogger *)getInstance {
    static FileLogger *sharedFileLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFileLogger = [[FileLogger alloc] init];
    });
    return sharedFileLogger;
}

- (NSString *)logFilePath
{
    if (!_logFilePath) {
        _logFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[[[NSDate date] description] stringByAppendingPathComponent:@".log"]];
    }
    return _logFilePath;
}

#pragma mark -

int saved_stdout;
int saved_stderr;
- (void)startLogging
{
    NSString *logFilePath = self.logFilePath;
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
        [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }
    
    saved_stdout = dup(STDOUT_FILENO);
    saved_stderr = dup(STDERR_FILENO);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (void)stopLogging
{
    dup2(saved_stdout, STDOUT_FILENO);
    close(saved_stdout);
    dup2(saved_stderr, STDERR_FILENO);
    close(saved_stderr);
}

- (BOOL)deleteLogFile
{
    NSError *error = nil;
    return [[NSFileManager defaultManager] removeItemAtPath:self.logFilePath error:&error];
}

- (NSString *)contents
{
    return [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:self.logFilePath] encoding:NSUTF8StringEncoding];
}

@end