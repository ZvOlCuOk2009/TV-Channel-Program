//
//  TSTVProgramm.h
//  TV Channel Program
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@import FirebaseAuth;
@import FirebaseDatabase;

@interface TSTVProgramm : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *tvDescription;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *channelID;

+ (NSMutableArray *)initWithSnapshot:(FIRDataSnapshot *)snapshot;

@end
