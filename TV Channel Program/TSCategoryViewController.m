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
#import "TSSortChannelViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSCategoryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *categorys;
@property (strong, nonatomic) TSContentService *contentService;
@property (assign, nonatomic) NSInteger counter;

@end

@implementation TSCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentService = [[TSContentService alloc] init];
    [self loadCategory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Категории";
    self.counter = 0;
}

#pragma mark - request to server

- (void)loadCategory
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
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Configure Cell

- (void)configureCell:(TSChannelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TSCategory *category = [self.categorys objectAtIndex:indexPath.row];
    cell.nameLabel.text = category.name;
    [cell.pictures sd_setImageWithURL:[NSURL URLWithString:category.pictures]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [SVProgressHUD show];
            [self.contentService loadListOfChannelsInCategoryes:indexPath.row + 1 onSuccess:^(NSMutableArray *listChannels) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.counter == 0) {
                    TSSortChannelViewController *controller =
                    [self.storyboard instantiateViewControllerWithIdentifier:@"TSSortChannelViewController"];
                    controller.sortChannels = listChannels;
                    TSCategory *category =
                    [self.categorys objectAtIndex:indexPath.row];
                    controller.nameCategory = category.name;
                    [self.navigationController pushViewController:controller animated:YES];
                    [SVProgressHUD dismiss];
                    NSLog(@"TSCategoryViewController %ld", (long)self.counter);
                    ++self.counter;
                }
            });
        }];
    });
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
