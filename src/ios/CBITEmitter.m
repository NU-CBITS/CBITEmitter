/********* CBITEmitter.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

// Provides a method for transmitting JSON-formatted data to a service. Uses a background session
// so that requests will complete even if the application is suspended or crashes.
@interface CBITEmitter : CDVPlugin {
}

- (void)emitData:(CDVInvokedUrlCommand*)command;

@end

@implementation CBITEmitter

- (void)emitData:(CDVInvokedUrlCommand*)command
{
  NSString* serverURI = [command.arguments objectAtIndex:0];
  NSString* json = [command.arguments objectAtIndex:1];
  NSLog(@"%@", json);
  NSURL* url = [NSURL URLWithString:serverURI];

  // Convert data and store in a file.
  NSData *requestData = [NSData dataWithBytes:[json UTF8String]
                                       length:[json length]];
  NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docsDir = [dirPaths objectAtIndex:0];
  NSURL *dataURL = [[NSURL alloc] initFileURLWithPath: [docsDir stringByAppendingPathComponent:@"cbit.data"]];

  if ([requestData writeToURL:dataURL atomically:YES]) {
    NSLog(@"%@", dataURL);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];

    // Make a background session and kick it off.
    NSURLSessionConfiguration *backgroundConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"edu.northwestern.cbits.cbitemitter"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:backgroundConfiguration
                                                          delegate:(id)self
                                                     delegateQueue:nil];
    NSURLSessionTask *task = [session uploadTaskWithRequest:request
                                                   fromFile:dataURL];
    [task resume];
  }
  else {
    NSLog(@"%@", @"not written!");
  }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    //handle data here
    NSLog(@"%@", @"data");
}

- (void)URLSession:(NSURLSession *)session
                    task:(NSURLSessionTask *)task
    didCompleteWithError:(NSError *)error
{
  //Called when the data transfer is complete
  //Client side errors are indicated with the error parameter
  NSLog(@"%@", @"complete");
}

@end
