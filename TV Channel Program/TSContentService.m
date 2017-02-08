//
//  TSContentService.m
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSContentService.h"
#import "TSTransportService.h"
#import "TSDataService.h"
#import "TSChanel.h"
#import "TSTVProgramm.h"
#import "TSTVSelectedProgramm.h"
#import "TSChannelViewController.h"

NSInteger syncDatabase;
NSInteger firstCall;

@interface TSContentService ()

@end

@implementation TSContentService

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

//проверяю если есть данные в базе, отображаю. Если нету, прошу TSTransportService подгрузить с сервера, сохранить и отобразить

- (void)loadedChannels:(void(^)(NSArray *channels))success
{
    [[TSDataService sharedService] loadedChanels:^(NSArray *channels) {
        if (channels && syncDatabase == 0) {
            success(channels);
        } else {
            [[TSTransportService sharedService] requestChannelsToServer];
        }
    }];
}

- (void)loadedCategorys:(void(^)(NSArray *catigorys))success
{
    [[TSDataService sharedService] loadedCategorys:^(NSArray *categorys) {
        if (categorys) {
            success(categorys);
        } else {
            [[TSTransportService sharedService] requestCategorysToServer];
        }
    }];
}

//запрос с ервера, сохранение и сортировка программ по каналам. Осуществляется при каждом входе открытии приложения

- (void)loadedTvProgrammCurrentTimestamp:(NSString *)timestamp byChannel:(NSInteger)channelID
                   inSuccess:(void(^)(NSArray *tvProgramm))success
{
    if (saveTvProgramm == 0) {
        [[TSTransportService sharedService] requestTvProgrammToServer:timestamp];
    }
    [[TSDataService sharedService] loadedTvProgramm:^(NSArray *programms) {
        if (programms) {
            NSMutableArray *sortProgramm = [NSMutableArray array];
            for (TSTVProgramm *programm in programms) {
                if (channelID == [programm.channelID integerValue]) {
                    [sortProgramm addObject:programm];
                }
            }
            success(sortProgramm);
        }
    }];
}

- (void)loadedTvProgrammSelectedTimestamp:(NSString *)timestamp byChannel:(NSInteger)channelID
                                inSuccess:(void(^)(NSArray *tvProgramm))success
{
    [[TSTransportService sharedService] loadedTvProgrammByTimestamp:timestamp insuccess:^(NSArray *programms) {
        NSMutableArray *selectedProgramm = nil;
        if (programms) {
            selectedProgramm = [NSMutableArray array];
            for (NSDictionary *programm in programms) {
                NSString *ID = [programm objectForKey:@"channel_id"];
                if ([ID integerValue] == channelID) {
                    TSTVSelectedProgramm *programmDict =
                    [[TSTVSelectedProgramm alloc] initSelectedProgrammResponse:programm];
                    [selectedProgramm addObject:programmDict];
                }
            }
        }
        if (selectedProgramm) {
            success(selectedProgramm);
        }
    }];
}

//сортировка каналов по категориям

- (void)loadListOfChannelsInCategoryes:(NSInteger)indexPath onSuccess:(void(^)(NSMutableArray *listChannels))success
{
    [[TSDataService sharedService] loadedChanels:^(NSArray *channels) {
        NSMutableArray *sortChannels = nil;
        if (channels) {
            sortChannels = [NSMutableArray array];
            for (int i = 0; i < [channels count]; i++) {
                TSChanel *channel = [channels objectAtIndex:i];
                if ([channel.category integerValue] == indexPath) {
                    [sortChannels addObject:channel];
                }
            }
            if (sortChannels) {
                success(sortChannels);
            }
        }
    }];
}

//отбор избранных каналов из базы

- (void)loadedSelectedFavoritChannels:(void(^)(NSArray *selectedChannels))success
{
    [[TSDataService sharedService] loadedChanels:^(NSArray *channels) {
        NSMutableArray *selectedChannels = [NSMutableArray array];
        for (TSChanel *channel in channels) {
            if (channel.favorite) {
                [selectedChannels addObject:channel];
            }
        }
        if (selectedChannels) {
            success(selectedChannels);
        }
    }];
}

//добавление индексов избанных каналов в массив

- (void)loadFavoritChannelsInDatabase:(NSString *)index;
{
    [[TSDataService sharedService] loadedIndexFavoritChannels:index];
}

//обновленного мвссива со свойствами избранных каналов

- (void)loadedFavoritChannels:(NSArray *)indexFavoritChannels
{
    [[TSDataService sharedService] loadedFavoritChannels:indexFavoritChannels];
}

@end
