#import <Cordova/CDV.h>

@interface GFKSSTPlugin : CDVPlugin

- (void) initTraffic:(CDVInvokedUrlCommand*)command;
- (void) sendImpression:(CDVInvokedUrlCommand *)command;

@end
