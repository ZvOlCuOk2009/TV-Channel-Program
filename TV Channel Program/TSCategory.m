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
    NSString *fieldPath = [NSString stringWithFormat:@"tvBase/%@", [FIRAuth auth].currentUser.uid];
    NSString *rootPath = [NSString stringWithFormat:@"%@/categorys", fieldPath];
    FIRDataSnapshot *dataBase = [snapshot childSnapshotForPath:fieldPath];
    NSMutableArray *catigorys = nil;
    if ([snapshot hasChild:rootPath]) {
        FIRDataSnapshot *categorySnaphot = dataBase.value[@"categorys"];
        NSArray *dataSnaphot = (NSArray *)categorySnaphot;
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
