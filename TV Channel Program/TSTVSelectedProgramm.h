//
//  TSTVSelectedProgramm.h
//  TV Channel Program
//
//  Created by Mac on 08.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTVSelectedProgramm : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *channelID;

- (id)initSelectedProgrammResponse:(NSDictionary *)responseObject;

@end
