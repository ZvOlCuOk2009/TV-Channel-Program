//
//  TSServerManager.h
//  TV Channel Program
//
//  Created by Mac on 02.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSTransportServiceDelgate <NSObject>

@optional;

- (void)loadChannelsFromDatabase:(NSArray *)dataSource;
- (void)loadCategorysFromDatabase:(NSArray *)dataSource;

@end

@interface TSTransportService : NSObject

@property (weak, nonatomic) id <TSTransportServiceDelgate> delegate;

+ (TSTransportService *)sharedService;

- (void)requestChannelsToServer;
- (void)requestCategorysToServer;

@end
