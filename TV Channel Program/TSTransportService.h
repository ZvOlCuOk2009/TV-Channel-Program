//
//  TSServerManager.h
//  TV Channel Program
//
//  Created by Mac on 02.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTransportService : NSObject

+ (TSTransportService *)sharedService;

- (void)requestChannelsToServer;
- (void)requestCategorysToServer;
- (void)requestTvProgrammToServer:(NSString *)timestamp;

- (void)loadedTvProgrammByTimestamp:(NSString *)timestamp
                          insuccess:(void(^)(NSArray *programms))success;

@end
