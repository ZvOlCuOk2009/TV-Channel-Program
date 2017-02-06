//
//  TSLikedViewController.m
//  TV Channel Program
//
//  Created by Mac on 04.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSLikedViewController.h"
#import "TSChannelCell.h"
#import "TSChanel.h"
#import "TSContentService.h"
#import "TSPrefixHeader.pch"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSLikedViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *favoritChannels;
@property (strong, nonatomic) TSContentService *contentService;
@property (assign, nonatomic) NSInteger activeController;

@end

@implementation TSLikedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentService = [[TSContentService alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadFavoritChannels];
    self.activeController = 1;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.activeController = 0;
}

#pragma mark - Actions

- (IBAction)favoritPressedButton:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD show];
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        TSChanel *channel = [self.favoritChannels objectAtIndex:indexPath.row];
        NSString *indexFavoriteChannel = [NSString stringWithFormat:@"%@", channel.ID];
        firstCall = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentService loadFavoritChannelsInDatabase:indexFavoriteChannel];
            [SVProgressHUD dismiss];
        });
    });
}

#pragma mark - request to data base

- (void)loadFavoritChannels
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD show];
        [self.contentService loadedSelectedFavoritChannels:^(NSArray *selectedChannels) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.favoritChannels = selectedChannels;
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
            });
            if ([selectedChannels count] == 0) {
                [self alertController];
            }
        }];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.favoritChannels count];
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
    TSChanel *channel = [self.favoritChannels objectAtIndex:indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Alert

- (void)alertController
{
    if (self.activeController == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Здесь появятся избранные каналы"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ок"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
