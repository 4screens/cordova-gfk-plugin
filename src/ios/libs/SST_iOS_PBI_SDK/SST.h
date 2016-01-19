//
//  SST.h
//  SST
//
//  Created by Michael Johannhanwahr on 03.07.15.
//  Copyright (c) 2015 GfK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SST : NSObject

- (instancetype)initWithMediaId:(NSString*)mediaId andAdvertisingId:(NSString*)advId;

- (void)sendPageImpressionWithContentId:(NSString*)contentId;

@end
