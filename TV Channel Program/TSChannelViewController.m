//
//  TSChannelViewController.m
//  TV Channel Program
//
//  Created by Mac on 02.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSChannelViewController.h"
#import "TSContentService.h"
#import "TSDataService.h"
#import "TSChanel.h"
#import "TSChannelCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSChannelViewController () <TSDataServiceDelegate>

@property (strong, nonatomic) TSContentService *contentService;
@property (strong, nonatomic) NSArray *channels;
@property (strong, nonatomic) NSArray *pictures;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TSChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentService = [[TSContentService alloc] init];
    TSDataService *dataService = [[TSDataService alloc] init];
    dataService.delegate = self;
    [self loadChanels];
    self.pictures = @[@"pictures1", @"pictures2", @"pictures3", @"pictures4", @"pictures5",@"pictures6",@"pictures7"];
}

#pragma mark - request to server

- (void)loadChanels
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD show];
        [self.contentService loadedChannels:^(NSArray *channels) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.channels = [NSArray arrayWithArray:channels];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        }];
    });
}

#pragma mark - delegate

- (void)loadDataFromDatabase:(NSArray *)dataSoure
{
    self.channels = dataSoure;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    TSChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TSChannelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    TSChanel *channel = [self.channels objectAtIndex:indexPath.row];
    cell.nameLabel.text = channel.name;
    
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:channel.pictures]]];
    cell.pictures.image = [UIImage imageNamed:[self.pictures objectAtIndex:arc4random_uniform(7)]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
