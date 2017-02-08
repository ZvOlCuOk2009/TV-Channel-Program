//
//  TSDataService.m
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSDataService.h"
#import "TSContentService.h"
#import "TSChanel.h"
#import "TSCategory.h"
#import "TSTVProgramm.h"
#import "TSChannelViewController.h"

@import Firebase;
@import FirebaseDatabase;

@interface TSDataService ()

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSDataService

+ (TSDataService *)sharedService
{
    static TSDataService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[TSDataService alloc] init];

    });
    return service;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

#pragma mark - parsing

//получение каналов, категорий и ТВ программ

- (void)loadedChanels:(void(^)(NSArray *chanels))success
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *chanels = [TSChanel initWithSnapshot:snapshot];
        if (success) {
            success(chanels);
        }
    }];
}

- (void)loadedCategorys:(void(^)(NSArray *categorys))success
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *categorys = [TSCategory initWithSnapshot:snapshot];
        if (success) {
            success(categorys);
        }
    }];
}

//получение программы на сегодня

- (void)loadedTvProgramm:(void(^)(NSArray *programms))success
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *tvProgramm = [TSTVProgramm initWithSnapshot:snapshot];
        if (success) {
            success(tvProgramm);
        }
    }];
}

//сохранение индексов выбранных каналов в базу

- (void)loadedIndexFavoritChannels:(NSString *)favoritIndex
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *updateChanels = [TSChanel initIndexFavoritWithSnapshot:snapshot theIndex:favoritIndex];
        if (updateChanels) {
            [self loadedFavoritChannels:updateChanels];
        }
    }];
}

- (void)loadedFavoritChannels:(NSArray *)indexFavoritChannels
{
    if (firstCall == 0) {
        [[[[self.ref child:@"tvBase"] child:[FIRAuth auth].currentUser.uid] child:@"channels"] setValue:indexFavoritChannels];
        firstCall = 1;
    }
}

//синхронизация базы по запросу пользователя. Избранные каналы в базе остаются

- (void)syncReceivedDatabase:(NSArray *)responseObject
{
    [self.ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSArray *channels = [TSChanel initWithSnapshot:snapshot];
        if (channels && syncReceived == YES) {
            NSMutableArray *updateChannels = [NSMutableArray array];
            for (int i = 0; i < [channels count]; i++) {
                TSChanel *channelFromTheBase = [channels objectAtIndex:i];
                NSDictionary *newChannel = [responseObject objectAtIndex:i];
                NSMutableDictionary *updateChannel = [NSMutableDictionary dictionary];
                [updateChannel setObject:[newChannel objectForKey:@"id"] forKey:@"id"];
                [updateChannel setObject:[newChannel objectForKey:@"name"] forKey:@"name"];
                [updateChannel setObject:[newChannel objectForKey:@"url"] forKey:@"url"];
                [updateChannel setObject:[newChannel objectForKey:@"picture"] forKey:@"picture"];
                [updateChannel setObject:[newChannel objectForKey:@"category_id"] forKey:@"category_id"];
                if (channelFromTheBase.favorite) {
                    [updateChannel setObject:@"favorite" forKey:@"favorite"];
                }
                [updateChannels addObject:updateChannel];
            }
            if ([updateChannels count] > 0) {
                [[[[self.ref child:@"tvBase"] child:[FIRAuth auth].currentUser.uid] child:@"channels"] setValue:updateChannels];
                syncReceived = NO;
            }
        }
    }];
}

@end
