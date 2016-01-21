#import "AdSupport/AdSupport.h"
#import "Agent.h"
#import "SSA.h"
#import "GFKSSAPlugin.h"

typedef NSString * (^EventBlock)();

@interface GFKSSAPlugin ()
@property (nonatomic, strong) SSA *SSA;
@property (nonatomic, strong) Agent *agent;

- (NSString *) createSSAObjectWithAdId:(NSString *)adId andWithConfigUrl:(NSString *)configUrl;
- (BOOL) createSSAAgentForMediaId:(NSString *)mediaId;
- (NSString *) notifyLoadedSSAWithContentId:(NSString *)contentId andCustomParams:(NSDictionary *)customParams;
- (void) fireBlock:(EventBlock)block ifAgentExistsForCommand:(CDVInvokedUrlCommand *)command;
- (BOOL) isAgentExist;

@end

@implementation GFKSSAPlugin

#pragma mark - Cordova Methods
/**
 * Sends event on play start
 * No params
 */
- (void) playEvent:(CDVInvokedUrlCommand *)command {
  [self fireBlock:^{
          [self.agent notifyPlay];
          return @"[SSA] Play Event fired";
        }
        ifAgentExistsForCommand:command];
}

/**
 * Sends event on idle state
 * No params
 */
- (void) idleEvent:(CDVInvokedUrlCommand *)command {
    [self fireBlock:^{
            [self.agent notifyIdle];
            return @"[SSA] Idle Event fired";
          }
          ifAgentExistsForCommand:command];
}

/**
 * Inits the SSA tracker for GFK
 *
 * Cordova args:
 * arg1 (string) - Media Identificator
 * arg2 (string) - Advertising ID
 * arg3 (string) - Configuration URL
 */
- (void) initStream:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = nil;
    NSString *logMessage = nil;

    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
    NSString *configUrl = @"https://config.sensic.net/pl1-ssa-ios.json";
    NSString *mediaId = nil;

    self.SSA = nil;
    self.agent = nil;

    mediaId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];

    logMessage = [self createSSAObjectWithAdId:adId andWithConfigUrl:configUrl];

    if ([self createSSAAgentForMediaId:mediaId]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:logMessage];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"[SSA] No Media ID :/ How I should send stats..?"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
 * Send data to GFK that player has been loaded
 *
 * Cordova args:
 * arg1 (string) - Content ID
 * arg2 (dictionary) - Custom Params
 */
- (void) startStream:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = nil;

    NSString *contentId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    NSDictionary *customParams = [command argumentAtIndex:1 withDefault:@{} andClass:[NSDictionary class]];

    if (contentId != nil && [contentId length] && [self isAgentExist]) {
        NSString *message = [self notifyLoadedSSAWithContentId:contentId andCustomParams:customParams];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    } else if(![self isAgentExist]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"[SSA] No Agent. Please init the SSA."];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"[SSA] No content ID. Can't notify"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Helpers
/**
 * Fires code from provided block if agent exists with sending all the cordova callbacks
 *
 * @param block - block with event fire. Check the private interface for definition
 * @param command - cordova command
 */
- (void) fireBlock:(EventBlock)block ifAgentExistsForCommand:(CDVInvokedUrlCommand *)command {
   CDVPluginResult *pluginResult = nil;

   if ([self isAgentExist]) {
     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:block()];
   } else {
     pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"[SSA] No Agent inited. Please init and start the SSA"];
   }

   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
 * Checks if agent instance exists
 *
 * @return - status of Agent existing
 */
- (BOOL) isAgentExist {
    return self.agent != nil;
}

/**
 * Sends request to GFK with player loaded notify
 *
 * @param contentId - Content Identificator with which GFK should be notified
 * @param customParams - Custom Params to be sended with notification to GFK
 * @return - State message
 */
- (NSString *) notifyLoadedSSAWithContentId:(NSString *)contentId andCustomParams:(NSDictionary *)customParams {
    if((int)[customParams count] == 0) {
        [self.agent notifyLoadedWithContentId:contentId];

        return @"[SSA] Notified loaded with content id.";
    } else {
        [self.agent notifyLoadedWithContentId:contentId andCustomParameters:customParams];

        return @"[SSA] Notified loaded with content id and custom parameters.";
    }
}

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

        return @"[SSA] Inited with Ad ID and Configuration URL.";
    } else{
        // No track
        self.SSA = [[SSA alloc] init];

        return @"[SSA] Inited without Ad ID. Ad ID or Configuration URL is missing.";
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
