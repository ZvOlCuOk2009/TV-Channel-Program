//
//  TSProgrammViewController.m
//  TV Channel Program
//
//  Created by Mac on 04.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSProgrammViewController.h"
#import "TSChannelCell.h"
#import "TSTransportService.h"

@interface TSProgrammViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tvProgramm;
@property (strong, nonatomic) TSTransportService *transportService;

@end

@implementation TSProgrammViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.transportService = [[TSTransportService alloc] init];
}

- (void)requestToServerTvProgramm
{
//    [self.transportService loadedChannels:^(NSArray *channels) {
//        self.tvProgramm = channels;
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tvProgramm count];
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
//    TSChanel *channel = [self.favoritChannels objectAtIndex:indexPath.row];
//    cell.nameLabel.text = channel.name;
//    [cell.pictures sd_setImageWithURL:[NSURL URLWithString:channel.pictures]
//                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
//    if (channel.favorite) {
//        [cell.favoriteButton setBackgroundImage:kSelectFavoritImage forState:UIControlStateNormal];
//    } else {
//        [cell.favoriteButton setBackgroundImage:kNoSelectFavoritImage forState:UIControlStateNormal];
//    }
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
