//
//  TSCatigoryViewController.m
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSCategoryViewController.h"
#import "TSContentService.h"
#import "TSChannelCell.h"
#import "TSCategory.h"
#import "TSTransportService.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSCategoryViewController () <TSTransportServiceDelgate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categorys;
@property (strong, nonatomic) TSContentService *contentService;

@end

@implementation TSCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TSTransportService *transportService = [[TSTransportService alloc] init];
    transportService.delegate = self;
    self.contentService = [[TSContentService alloc] init];
    [self loadCatigory];
}

#pragma mark - request to server

- (void)loadCatigory
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD show];
        [self.contentService loadedCategorys:^(NSArray *categorys) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.categorys = [NSArray arrayWithArray:categorys];
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            });
        }];
    });
}

- (void)loadCategorysFromDatabase:(NSArray *)dataSource
{
    self.categorys = dataSource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categorys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    TSChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TSChannelCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    TSCategory *category = [self.categorys objectAtIndex:indexPath.row];
    cell.nameLabel.text = category.name;
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:category.pictures]]];
    [cell.pictures sd_setImageWithURL:[NSURL URLWithString:category.pictures]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    //cell.pictures.image = image;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
