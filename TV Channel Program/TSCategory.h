//
//  TSCatigory.h
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseDatabase;

@interface TSCategory : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *pictures;
@property (strong, nonatomic) NSString *ID;

+ (NSMutableArray *)initWithSnapshot:(FIRDataSnapshot *)snapshot;

@end
