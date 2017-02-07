//
//  TSProgrammChannelViewController.m
//  TV Channel Program
//
//  Created by Mac on 07.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSProgrammChannelViewController.h"
#import "TSChannelCell.h"
#import "TSProgrammCell.h"
#import "TSContentService.h"
#import "TSTVProgramm.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSProgrammChannelViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TSContentService *contentService;
@property (strong, nonatomic) NSArray *tvProgramms;

@end

@implementation TSProgrammChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.contentService = [[TSContentService alloc] init];
    [self loadTvProgramm];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 185, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setImage:[UIImage imageNamed:@"back"]];
    [backItem setTarget:self];
    [backItem setAction:@selector(cancelInteraction)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.nameChannel;
}

- (void)cancelInteraction
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers firstObject]
                                          animated:YES];
}

#pragma mark - request to server

- (void)loadTvProgramm
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD show];
        NSString * timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
        [self.contentService loadedTvProgrammById:timestamp byChannel:self.idChannel inSuccess:^(NSArray *tvProgramm) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tvProgramms = tvProgramm;
                [self.tableView reloadData];
                [SVProgressHUD dismiss];
                if ([self.tvProgramms count] <= 1) {
                    [self alertController];
                }
            });
        }];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tvProgramms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    static NSString *identifierProgramm = @"programmCell";
    if (indexPath.row == 0) {
        TSChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        TSProgrammCell *programmCell = [tableView dequeueReusableCellWithIdentifier:identifierProgramm];
        if (!programmCell) {
            programmCell = [[TSProgrammCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                 reuseIdentifier:identifier];
        }
        [self configureProgrammCell:programmCell atIndexPath:indexPath];
        return programmCell;
    }
}

#pragma mark - Configure Cells

- (void)configureCell:(TSChannelCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TSTVProgramm *programm = [self.tvProgramms objectAtIndex:indexPath.row];
    [cell.pictures sd_setImageWithURL:[NSURL URLWithString:self.pictures]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.nameLabel.text = self.nameChannel;
    cell.dateLabel.text = programm.date;
}

- (void)configureProgrammCell:(TSProgrammCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TSTVProgramm *programm = [self.tvProgramms objectAtIndex:indexPath.row];
    cell.timeLabel.text = programm.time;
    cell.titleLabel.text = programm.title;
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

#pragma mark - UIAlertController

- (void)alertController
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Технічні роботи"
                                                                        message:@""
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ок"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
