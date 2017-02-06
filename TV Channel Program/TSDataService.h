//
//  TSDataService.h
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSDataService : NSObject

+ (TSDataService *)sharedService;

- (void)loadedChanels:(void(^)(NSArray *channels))success;
- (void)loadedCategorys:(void(^)(NSArray *categorys))success;
- (void)loadedFavoritChannels:(NSArray *)indexFavoritChannels;
- (void)loadedIndexFavoritChannels:(NSString *)favoritIndex;

@end
