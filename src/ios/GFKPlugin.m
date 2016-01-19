#import "GFKPlugin.h"
#import "Agent.h"
#import "SSA.h"
#import "SST.h"

@interface GFKPlugin ()
  @property (nonatomic, strong) SSA *SSA;
  @property (nonatomic, strong) Agent *agent;

  - (NSString *) createSSAObjectWithAdId:(NSString *)adId andWithConfigUrl:(NSString *)configUrl;
  - (BOOL) createSSAAgentForMediaId:(NSString *)mediaId;

@end

@implementation GFKPlugin

- (void)initSST:(CDVInvokedUrlCommand *)command {

}

#pragma mark - Cordova Methods
/**
* Inits the SSA tracker for GFK
*
* Cordova args:
* arg1 (string) - Advertising ID
* arg2 (string) - Configuration URL
* arg3 (string) - Media Identificator
*/
- (void)initSSA:(CDVInvokedUrlCommand *)command {
  CDVPluginResult *pluginResult = nil;
  NSString *logMessage = nil;

  NSString *adId = nil;
  NSString *configUrl = nil;
  NSString *mediaId = nil;

  self.SSA = nil;
  self.agent = nil;

  adId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
  configUrl = [command argumentAtIndex:1 withDefault:@"" andClass:[NSString class]];
  mediaId = [command argumentAtIndex:2 withDefault:@"" andClass:[NSString class]];

  logMessage = [self createSSAObjectWithAdId:adId andWithConfigUrl:configUrl];

  if ([self createSSAAgentForMediaId:mediaId]) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:logMessage];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No Media ID :/ How I should send stats..?"];
  }

  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Helpers

/**
* Creates SSA object
*
* @param adId - Advertising ID
* @param configUrl - Configuration URL
* @return NSString - Result message
*/
- (NSString *) createSSAObjectWithAdId:(NSString *)adId andWithConfigUrl:(NSString *)configUrl {
  if (adId != nil && [adId length] && configUrl != nil && [configUrl length]) {
    self.SSA = [[SSA alloc]
      initWithAdvertisingId: adId
      andConfigUrl: configUrl
    ];

    return @"Inited with Ad ID and Configuration URL.";
  } else{
    // No track
    self.SSA = [[SSA alloc] init];

    return @"Inited without Ad ID. Ad ID or Configuration URL is missing.";
  }
}

/**
* Creates SSA Agent which should be attached to object
*
* @param mediaId - Media ID for data that should be send
* @return BOOL - Status of created Agent
*/
- (BOOL) createSSAAgentForMediaId:(NSString *)mediaId {
  if (mediaId != nil && [mediaId length]) {
      self.agent = [self.SSA agentWithMediaId:mediaId];

      return YES;
  } else {
      return NO;
  }
}
@end
