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

//получение каналов и категорий

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


@end
