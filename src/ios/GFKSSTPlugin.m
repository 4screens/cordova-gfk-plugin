#import "AdSupport/AdSupport.h"
#import "SST.h"
#import "GFKSSTPlugin.h"

@interface GFKSSTPlugin ()
@property (nonatomic, strong) SST *SST;
@end

@implementation GFKSSTPlugin

#pragma mark - Cordova Methods
/**
 * Inits the SST tracker for GFK
 *
 * Cordova args:
 * arg1 (string) - Media ID
 */
- (void) initTraffic:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = nil;

    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *mediaId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];

    self.SST = nil;

    if (adId != nil && [adId length] && mediaId != nil && [mediaId length]) {
        self.SST = [[SST alloc] initWithMediaId:mediaId andAdvertisingId:adId];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"[SSA] Inited with provided Media ID and Ad ID."];
    } else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"[SSA] No Media ID :/ How I should send stats..?"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
 * Sends page impression event to GFK
 *
 * Cordova args:
 * arg1 (string) - Content ID
 */
- (void) sendImpression:(CDVInvokedUrlCommand *)command {
    CDVPluginResult *pluginResult = nil;
    NSString *contentId = [command argumentAtIndex:0 withDefault:@"" andClass:[NSString class]];

    if (contentId != nil && [contentId length]) {
        [self.SST sendPageImpressionWithContentId:contentId];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"[SST] Sent impression %@", contentId]];
    } else{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"[SST] No Content ID :/ How I should send stats..?"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Helpers
@end
