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
#import "TSPrefixHeader.pch"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSChannelViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TSContentService *contentService;
@property (strong, nonatomic) NSArray *channels;
@property (strong, nonatomic) NSArray *pictures;
@property (strong, nonatomic) NSArray *indexFavorit;
@property (strong, nonatomic) NSMutableArray *favoriteChannels;
@property (strong, nonatomic) NSMutableArray *favoriteButtons;

@end

@implementation TSChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentService = [[TSContentService alloc] init];
    self.favoriteChannels = [NSMutableArray array];
    self.favoriteButtons = [NSMutableArray array];
    syncDatabase = 0;
    [self startLoadChannels];
    self.pictures = @[@"pictures1", @"pictures2", @"pictures3", @"pictures4", @"pictures5",@"pictures6",@"pictures7"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)startLoadChannels
{
    [self loadChannels];
}

#pragma mark - request to server

- (void)loadChannels
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

#pragma mark - Actions

- (IBAction)syncPressedBarButtonItem:(id)sender
{
    syncDatabase = 1;
    [self loadChannels];
}

- (IBAction)favoritPressedButton:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD show];
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        NSString *indexFavoriteChannel = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        firstCall = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentService loadFavoritChannelsInDatabase:indexFavoriteChannel];
            [SVProgressHUD dismiss];
        });
    });
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
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Configure Cell

- (void)configureCell:(TSChannelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TSChanel *channel = [self.channels objectAtIndex:indexPath.row];
    cell.nameLabel.text = channel.name;
    [cell.pictures sd_setImageWithURL:[NSURL URLWithString:channel.pictures]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    if (channel.favorite) {
        [cell.favoriteButton setBackgroundImage:kSelectFavoritImage forState:UIControlStateNormal];
    } else {
        [cell.favoriteButton setBackgroundImage:kNoSelectFavoritImage forState:UIControlStateNormal];
    }
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
