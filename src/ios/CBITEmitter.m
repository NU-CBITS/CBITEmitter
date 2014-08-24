/********* CBITEmitter.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "CBITEmitter.h"

@implementation CBITEmitter

- (void)emitData:(CDVInvokedUrlCommand *)command
{
  NSString *serverURI = [command.arguments objectAtIndex:0];
  NSString *json = [command.arguments objectAtIndex:1];
  NSLog(@"emitData called with payload: %@", json);
  NSURL *url = [NSURL URLWithString:serverURI];
  NSData *requestData = [NSData dataWithBytes:[json UTF8String]
                                       length:[json length]];
  NSURL *dataURL = [self dataPath];

  if ([requestData writeToURL:dataURL atomically:YES]) {
    NSLog(@"POSTING to URL: %@", dataURL);
    NSMutableURLRequest *request = [self formRequest:url
                                            withData:requestData];
    NSURLSessionTask *task = [self createBackgroundUrlSessionTask:request
                                                     fromDataFile:dataURL];
    [task resume];
  }
  else {
    NSLog(@"%@", @"request data file not written!");
  }
}

/* Session delegate methods */

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"%@", @"data received");
}

- (void)URLSession:(NSURLSession *)session
                    task:(NSURLSessionTask *)task
    didCompleteWithError:(NSError *)error
{
  NSLog(@"%@", @"request complete");
}

/* Private methods */

- (NSURL *)dataPath
{
  NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docsDir = [dirPaths objectAtIndex:0];

  return [[NSURL alloc] initFileURLWithPath: [docsDir stringByAppendingPathComponent:@"cbit.data"]];
}

- (NSMutableURLRequest *)formRequest:(NSURL *)url
                            withData:(NSData *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];

    return request;
}

- (NSURLSessionTask *)createBackgroundUrlSessionTask:(NSMutableURLRequest *)request
                                        fromDataFile:(NSURL *)dataURL
{
    NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"edu.northwestern.cbits.cbitemitter"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:backgroundConfiguration
                                                          delegate:(id)self
                                                     delegateQueue:nil];

    return [session uploadTaskWithRequest:request
                                 fromFile:dataURL];
}
@end
