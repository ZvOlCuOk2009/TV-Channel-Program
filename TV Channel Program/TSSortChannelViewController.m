//
//  TSSortChennelViewController.m
//  TV Channel Program
//
//  Created by Mac on 04.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSSortChannelViewController.h"
#import "TSChannelCell.h"
#import "TSChanel.h"
#import "TSContentService.h"
#import "TSPrefixHeader.pch"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSSortChannelViewController ()

@property (strong, nonatomic) TSContentService *contentService;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger counter;

@end

@implementation TSSortChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.contentService = [[TSContentService alloc] init];
    self.counter = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.nameCategory;
}

#pragma mark - Actions

- (IBAction)favoritPressedButton:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD show];
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        TSChanel *channel = [self.sortChannels objectAtIndex:indexPath.row];
        NSString *indexFavoriteChannel = [NSString stringWithFormat:@"%@", channel.ID];
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
    return [self.sortChannels count];
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
    TSChanel *channel = [self.sortChannels objectAtIndex:indexPath.row];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
