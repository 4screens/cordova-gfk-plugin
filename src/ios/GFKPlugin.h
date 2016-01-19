#import <Cordova/CDV.h>
#import "BrightcovePluginViewController.h"

@interface GFKPlugin : CDVPlugin

- (void)initSSA:(CDVInvokedUrlCommand*)command;
- (void)initSST:(CDVInvokedUrlCommand*)command;

@end
