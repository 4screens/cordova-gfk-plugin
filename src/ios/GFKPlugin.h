#import <Cordova/CDV.h>

@interface GFKPlugin : CDVPlugin

- (void) initSSA:(CDVInvokedUrlCommand*)command;
- (void) initSST:(CDVInvokedUrlCommand*)command;
- (void) startSSA:(CDVInvokedUrlCommand *)command;
- (void) playSSA:(CDVInvokedUrlCommand *)command;
- (void) idleSSA:(CDVInvokedUrlCommand *)command;

@end
