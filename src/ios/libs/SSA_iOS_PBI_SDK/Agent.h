//
// Created by Marcus Terasa on 27.08.15.
// Copyright (c) 2015 GfK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSA;


@interface Agent : NSObject
- (instancetype)initWithSsa:(SSA *)ssa mediaId:(NSString *)mediaId playerId:(NSNumber *)playerId;

+ (instancetype)agentWithSsa:(SSA *)ssa mediaId:(NSString *)mediaId playerId:(NSNumber *)playerId;


- (void)notifyLoadedWithContentId:(NSString *)contentId;

- (void)notifyLoadedWithContentId:(NSString *)contentId andCustomParameters:(NSDictionary *)customParameters;

- (void)notifyPlay;

- (void)notifyIdle;

- (NSString *)mediaId;

- (NSNumber *)playerId;

@end