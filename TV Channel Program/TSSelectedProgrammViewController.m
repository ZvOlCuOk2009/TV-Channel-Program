//
//  TSSelectedProgrammViewController.m
//  TV Channel Program
//
//  Created by Mac on 07.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSSelectedProgrammViewController.h"
#import "TSProgrammCell.h"
#import "TSTVProgramm.h"
#import "TSTVSelectedProgramm.h"
#import "TSContentService.h"

#import <SVProgressHUD.h>

@interface TSSelectedProgrammViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSArray *selectegProgramms;

@end

@implementation TSSelectedProgrammViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.contentService = [[TSContentService alloc] init];
    self.navigationItem.leftBarButtonItem = self.backItem;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *convertData = [dateFormatter dateFromString:self.selectegDate];
    self.timestamp = [NSString stringWithFormat:@"%f", ([convertData timeIntervalSince1970]) * 1000];
    NSLog(@"timestamp %@", self.timestamp);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, - 44, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title =
    [NSString stringWithFormat:@"%@ %@", self.nameChannel, self.selectegDate];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    alert = 1;
    [self requestToDatabase];
}

- (void)requestToDatabase
{
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.contentService loadedTvProgrammSelectedTimestamp:self.timestamp
                                                 byChannel:[self.channelID integerValue] inSuccess:^(NSArray *tvProgramm) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         self.selectegProgramms = tvProgramm;
                                                         [self.tableView reloadData];
                                                         [SVProgressHUD dismiss];
                                                         });
                                                 }];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectegProgramms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierProgramm = @"programmCell";
    TSProgrammCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierProgramm];
    if (!cell) {
        cell = [[TSProgrammCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierProgramm];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Configure Cells

- (void)configureCell:(TSProgrammCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TSTVSelectedProgramm *programm = [self.selectegProgramms objectAtIndex:indexPath.row];
    cell.titleLabel.text = programm.title;
    cell.timeLabel.text = programm.time;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
