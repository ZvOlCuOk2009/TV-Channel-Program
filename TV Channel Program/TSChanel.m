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
    NSString *fieldPath = [NSString stringWithFormat:@"tvBase/%@", [FIRAuth auth].currentUser.uid];
    NSString *rootPath = [NSString stringWithFormat:@"%@/channels", fieldPath];
    FIRDataSnapshot *dataBase = [snapshot childSnapshotForPath:fieldPath];
    NSMutableArray *channels = nil;
    if ([snapshot hasChild:rootPath]) {
        FIRDataSnapshot *channelSnaphot = dataBase.value[@"channels"];
        NSArray *dataSnaphot = (NSArray *)channelSnaphot;
        channels = [NSMutableArray array];
        for (int i = 0; i < [dataSnaphot count]; i++) {
            TSChanel *channel = [[TSChanel alloc] init];
            NSDictionary *dataChannel = [dataSnaphot objectAtIndex:i];
            channel.name = [dataChannel objectForKey:@"name"];
            channel.pictures = [dataChannel objectForKey:@"picture"];
            channel.url = [dataChannel objectForKey:@"url"];
            channel.ID = [dataChannel objectForKey:@"id"];
            channel.category = [dataChannel objectForKey:@"category_id"];
            channel.favorite = [dataChannel objectForKey:@"favorite"];
            [channels addObject:channel];
        }
    }
    return channels;
}

+ (NSMutableArray *)initIndexFavoritWithSnapshot:(FIRDataSnapshot *)snapshot theIndex:(NSString *)index
{
    NSString *rootPath = [NSString stringWithFormat:@"tvBase/%@", [FIRAuth auth].currentUser.uid];
    FIRDataSnapshot *dataBase = [snapshot childSnapshotForPath:rootPath];
    FIRDataSnapshot *channelSnaphot = dataBase.value[@"channels"];
    NSArray *dataSnaphot = (NSArray *)channelSnaphot;
    NSMutableArray *updateChannels = [NSMutableArray array];
    for (int i = 0; i < [dataSnaphot count]; i++) {
        NSMutableDictionary *channel = [dataSnaphot objectAtIndex:i];
        id currentId = [channel objectForKey:@"id"];
        NSString *strCurentId = [NSString stringWithFormat:@"%@", currentId];
        if ([strCurentId isEqualToString:index]) {
            NSString *favorite = [channel objectForKey:@"favorite"];
            if (favorite) {
                [channel removeObjectForKey:@"favorite"];
            } else {
                [channel setObject:@"favorite" forKey:@"favorite"];
            }
        }
        [updateChannels addObject:channel];
    }
    return updateChannels;
}

@end
