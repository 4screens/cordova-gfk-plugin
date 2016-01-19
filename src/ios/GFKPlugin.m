#import "GFKPlugin.h"

@interface GFKPlugin () {
  @property (nonatomic, strong) SSA *SSA;
  @property (nonatomic, strong) NSString *adId;
}

@implementation GFKPlugin

#pragma mark - Cordova Methods

- (void)initSSA:(CDVInvokedUrlCommand *)command {
  CDVPluginResult *pluginResult = nil;
  self.SSA = nil;

  self.adId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];

  if (self.adId != nil && [self.adId length]) {
    SSA = [[SSA alloc]
      initWithAdvertisingId: self.adId
      andConfigUrl: @"https://config.sensic.net/pl1-ssa-ios.json"
    ];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Inited"];
  } else{
    // No track
    SSA = [[SSA alloc] init];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Inited without Ad ID. No tracking!"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
