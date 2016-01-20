#import "GFKPlugin.h"
#import "Agent.h"
#import "SSA.h"
#import "SST.h"

@interface GFKPlugin ()
@property (nonatomic, strong) SSA *SSA;
@property (nonatomic, strong) Agent *agent;

- (NSString *) createSSAObjectWithAdId:(NSString *)adId andWithConfigUrl:(NSString *)configUrl;
- (BOOL) createSSAAgentForMediaId:(NSString *)mediaId;
- (NSString *) notifyLoadedSSAWithContentId:(NSString *)contentId andCustomParams:(NSDictionary *)customParams;

@end

@implementation GFKPlugin

- (void)initSST:(CDVInvokedUrlCommand *)command {

}

#pragma mark - Cordova Methods
/**
 * Inits the SSA tracker for GFK
 *
 * Cordova args:
 * arg1 (string) - Media Identificator
 * arg2 (string) - Advertising ID
 * arg3 (string) - Configuration URL
 */
- (void) initSSA:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = nil;
    NSString *logMessage = nil;

    NSString *adId = nil;
    NSString *configUrl = nil;
    NSString *mediaId = nil;

    self.SSA = nil;
    self.agent = nil;

    mediaId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];
    adId = [command argumentAtIndex:1 withDefault:@"" andClass:[NSString class]];
    configUrl = [command argumentAtIndex:2 withDefault:@"" andClass:[NSString class]];

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
- (void) startSSA:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = nil;
    NSString *message = nil;

    NSString *contentId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];

    NSDictionary *customParams = [command argumentAtIndex:1 withDefault:@{} andClass:[NSDictionary class]];

    if (contentId != nil && [contentId length]) {
        message = [self notifyLoadedSSAWithContentId:contentId andCustomParams:customParams];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    } else {
        message = @"[SSA] No content ID. Can't notify";

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Helpers
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
