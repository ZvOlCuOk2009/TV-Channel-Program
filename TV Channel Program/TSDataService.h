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
- (void)loadedTvProgramm:(void(^)(NSArray *programms))success;

//- (void)loadedTvProgrammByTimestamp:(NSString *)timestamp
//                          byChannel:(NSInteger)channelID
//                          insuccess:(void(^)(NSArray *programms))success;

- (void)loadedFavoritChannels:(NSArray *)indexFavoritChannels;
- (void)loadedIndexFavoritChannels:(NSString *)favoritIndex;
- (void)syncReceivedDatabase:(NSArray *)responseObject;
@end
