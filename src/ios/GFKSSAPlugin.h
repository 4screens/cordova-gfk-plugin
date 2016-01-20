#import <Cordova/CDV.h>

@interface GFKSSAPlugin : CDVPlugin

- (void) initStream:(CDVInvokedUrlCommand*)command;
- (void) startStream:(CDVInvokedUrlCommand *)command;
- (void) playEvent:(CDVInvokedUrlCommand *)command;
- (void) idleEvent:(CDVInvokedUrlCommand *)command;

@end
