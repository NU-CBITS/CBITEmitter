#import <Cordova/CDV.h>

// Provides a method for transmitting JSON-formatted data to a service. Uses a background session
// so that requests will complete even if the application is suspended or crashes.
@interface CBITEmitter : CDVPlugin {}

- (void)emitData:(CDVInvokedUrlCommand*)command;
@end
