//
//  TSCatigory.m
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSCategory.h"

@implementation TSCategory

+ (NSMutableArray *)initWithSnapshot:(FIRDataSnapshot *)snapshot
{
    FIRDataSnapshot *dataBase = [snapshot childSnapshotForPath:@"tv"];
    FIRDataSnapshot *categorySnaphot = dataBase.value[@"categorys"];
    NSArray *dataSnaphot = (NSArray *)categorySnaphot;
    NSMutableArray *catigorys = nil;
    if (dataSnaphot) {
        catigorys = [NSMutableArray array];
        for (int i = 0; i < [dataSnaphot count]; i++) {
            TSCategory *catigory = [[TSCategory alloc] init];
            NSDictionary *datChannel = [dataSnaphot objectAtIndex:i];
            catigory.name = [datChannel objectForKey:@"title"];
            catigory.pictures = [datChannel objectForKey:@"picture"];
            catigory.ID = [datChannel objectForKey:@"id"];
            [catigorys addObject:catigory];
        }
    }
    return catigorys;
}

@end
