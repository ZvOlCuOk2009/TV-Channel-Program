//
//  TSContentService.m
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSContentService.h"
#import "TSTransportService.h"
#import "TSDataService.h"

@interface TSContentService ()

@end

@implementation TSContentService

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadedChannels:(void(^)(NSArray *channels))success
{
    [[TSDataService sharedService] loadedChanels:^(NSArray *channels) {
        if (channels) {
            success(channels);
        } else {
            [[TSTransportService sharedService] requestChannelsToServer];
        }
    }];
}

- (void)loadedCategorys:(void(^)(NSArray *catigorys))success
{
    [[TSDataService sharedService] loadedCategorys:^(NSArray *categorys) {
        if (categorys) {
            success(categorys);
        } else {
            [[TSTransportService sharedService] requestCategorysToServer];
        }
    }];
}

@end
