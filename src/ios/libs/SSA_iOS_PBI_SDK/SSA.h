//
//  SSA.h
//  SSA
//
//  Created by Michael Johannhanwahr on 06.07.15.
//  Copyright (c) 2015 GfK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Agent;
@class Event;


@interface SSA : NSObject

- (instancetype)initWithAdvertisingId:(NSString *)advertisingId andConfigUrl:(NSString *)configUrl;

- (Agent *)agentWithMediaId:(NSString *)mediaId;

- (Agent *)agentWithMediaId:(NSString *)mediaId andPlayerId:(NSNumber *)playerId;

- (void)notifyAllAgentsIdle;

- (void)trackEvent:(Event *)event;
@end