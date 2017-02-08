
//
//  TSTVSelectedProgramm.m
//  TV Channel Program
//
//  Created by Mac on 08.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSTVSelectedProgramm.h"

@implementation TSTVSelectedProgramm

- (id)initSelectedProgrammResponse:(NSDictionary *)responseObject
{
    self = [super init];
    if (self) {
        self.title = [responseObject objectForKey:@"title"];
        self.time = [responseObject objectForKey:@"time"];
        self.date = [responseObject objectForKey:@"date"];
        self.channelID = [responseObject objectForKey:@"channel_id"];
    }
    return self;
}

@end
