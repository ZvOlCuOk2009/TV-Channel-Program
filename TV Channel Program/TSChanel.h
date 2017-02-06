//
//  TSListChanels.h
//  TV Channel Program
//
//  Created by Mac on 02.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSChanel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *pictures;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *favorite;

+ (NSMutableArray *)initWithSnapshot:(FIRDataSnapshot *)snapshot;
+ (NSMutableArray *)initIndexFavoritWithSnapshot:(FIRDataSnapshot *)snapshot theIndex:(NSString *)index;

@end
