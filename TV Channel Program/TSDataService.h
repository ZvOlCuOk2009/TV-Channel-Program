//
//  TSDataService.h
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSDataServiceDelegate <NSObject>

- (void)loadDataFromDatabase:(NSArray *)dataSoure;

@end

@interface TSDataService : NSObject

@property (weak, nonatomic) id <TSDataServiceDelegate> delegate;

+ (TSDataService *)sharedService;

- (void)loadedChanels:(void(^)(NSArray *channels))success;
- (void)loadedCategorys:(void(^)(NSArray *categorys))success;
- (void)loadDataToDatabase:(NSArray *)responseObject;

@end
