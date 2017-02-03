//
//  TSContentService.h
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSContentService : NSObject

- (void)loadedChannels:(void(^)(NSArray *channels))success;
- (void)loadedCategorys:(void(^)(NSArray *catigorys))success;

@end
