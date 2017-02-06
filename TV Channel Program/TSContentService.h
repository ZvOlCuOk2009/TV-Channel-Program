//
//  TSContentService.h
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger syncDatabase;
extern NSInteger firstCall;

@interface TSContentService : NSObject

- (void)loadedChannels:(void(^)(NSArray *channels))success;
- (void)loadedCategorys:(void(^)(NSArray *catigorys))success;
- (void)loadListOfChannelsInCategoryes:(NSInteger)indexPath
                             onSuccess:(void(^)(NSMutableArray *listChannels))success;
- (void)loadedSelectedFavoritChannels:(void(^)(NSArray *selectedChannels))success;
- (void)loadFavoritChannelsInDatabase:(NSString *)index;

@end
