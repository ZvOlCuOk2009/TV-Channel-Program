//
//  TSTVProgramm.m
//  TV Channel Program
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSTVProgramm.h"

@implementation TSTVProgramm

+ (NSMutableArray *)initWithSnapshot:(FIRDataSnapshot *)snapshot
{
    NSString *fieldPath = [NSString stringWithFormat:@"tvBase/%@", [FIRAuth auth].currentUser.uid];
    NSString *rootPath = [NSString stringWithFormat:@"%@/tvProgramm", fieldPath];
    FIRDataSnapshot *dataBase = [snapshot childSnapshotForPath:fieldPath];
    NSMutableArray *tvProgramms = nil;
    if ([snapshot hasChild:rootPath]) {
        FIRDataSnapshot *channelSnaphot = dataBase.value[@"tvProgramm"];
        NSArray *dataSnaphot = (NSArray *)channelSnaphot;
        tvProgramms = [NSMutableArray array];
        for (int i = 0; i < [dataSnaphot count]; i++) {
            TSTVProgramm *tvProgramm = [[TSTVProgramm alloc] init];
            NSDictionary *dataChannel = [dataSnaphot objectAtIndex:i];
            tvProgramm.title = [dataChannel objectForKey:@"title"];
            tvProgramm.tvDescription = [dataChannel objectForKey:@"tvDescription"];
            tvProgramm.date = [dataChannel objectForKey:@"date"];
            tvProgramm.time = [dataChannel objectForKey:@"time"];
            tvProgramm.channelID = [dataChannel objectForKey:@"channel_id"];
            [tvProgramms addObject:tvProgramm];
        }
    }
    return tvProgramms;
}

@end
