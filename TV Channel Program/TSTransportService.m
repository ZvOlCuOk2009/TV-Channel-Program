//
//  TSServerManager.m
//  TV Channel Program
//
//  Created by Mac on 02.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSTransportService.h"
#import "TSContentService.h"
#import "TSChanel.h"

#import <AFNetworking.h>

@import Firebase;
@import FirebaseDatabase;

@interface TSTransportService () 

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation TSTransportService

+ (TSTransportService *)sharedService
{
    static TSTransportService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[TSTransportService alloc] init];
    });
    return service;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.ref = [[FIRDatabase database] reference];
    }
    return self;
}

- (void)requestChannelsToServer
{
    [self.sessionManager GET:@"http://52.50.138.211:8080/ChanelAPI/chanels"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [self saveChannels:responseObject];
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"error %@", error.localizedDescription);
                     }];
}

- (void)requestCategorysToServer
{
    [self.sessionManager GET:@"http://52.50.138.211:8080/ChanelAPI/categories"
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         [self saveCatigorys:responseObject];
                         NSLog(@"responseObject %@", responseObject);
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"error %@", error.localizedDescription);
                     }];
}

- (void)saveChannels:(NSArray *)responseObject
{
    [[[self.ref child:@"tv"] child:@"channels"] setValue:responseObject];
}

- (void)saveCatigorys:(NSArray *)responseObject
{
    [[[self.ref child:@"tv"] child:@"categorys"] setValue:responseObject];
    [self.delegate loadCategorysFromDatabase:responseObject];
}

@end
