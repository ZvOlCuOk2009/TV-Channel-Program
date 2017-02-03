//
//  TSListChanels.m
//  TV Channel Program
//
//  Created by Mac on 02.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSChanel.h"

@implementation TSChanel

+ (NSMutableArray *)initWithSnapshot:(FIRDataSnapshot *)snapshot
{
    FIRDataSnapshot *dataBase = [snapshot childSnapshotForPath:@"tv"];
    FIRDataSnapshot *channelSnaphot = dataBase.value[@"channels"];
    NSArray *dataSnaphot = (NSArray *)channelSnaphot;
    NSMutableArray *channels = nil;
    if (dataSnaphot) {
        channels = [NSMutableArray array];
        for (int i = 0; i < [dataSnaphot count]; i++) {
            TSChanel *channel = [[TSChanel alloc] init];
            NSDictionary *datChannel = [dataSnaphot objectAtIndex:i];
            channel.name = [datChannel objectForKey:@"name"];
            channel.pictures = [datChannel objectForKey:@"picture"];
            channel.url = [datChannel objectForKey:@"url"];
            channel.ID = [datChannel objectForKey:@"id"];
            channel.category = [datChannel objectForKey:@"category_id"];
            [channels addObject:channel];
        }
    }
    return channels;
}

@end
