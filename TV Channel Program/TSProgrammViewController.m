//
//  TSProgrammViewController.m
//  TV Channel Program
//
//  Created by Mac on 04.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "TSProgrammViewController.h"
#import "TSChannelCell.h"
#import "TSChanel.h"
#import "TSTransportService.h"
#import "TSSelectedProgrammViewController.h"
#import "TSPrefixHeader.pch"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD.h>

@interface TSProgrammViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tvProgramm;
@property (strong, nonatomic) NSMutableArray *labels;
@property (strong, nonatomic) TSTransportService *transportService;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) NSString *selectData;
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL stateDatePicker;

@end

@implementation TSProgrammViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transportService = [[TSTransportService alloc] init];
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Готово" style:UIBarButtonItemStylePlain
                                                      target:self action:@selector(itemDoneAction)];
    [self.doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont fontWithName:@"System-light" size:20.0], NSFontAttributeName,
                                             [UIColor blackColor], NSForegroundColorAttributeName,
                                             nil] forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.labels = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.selectData = [dateFormatter stringFromDate:[NSDate date]];
    for (int i = 0; i < 136; i++) {
        NSString *str = @"";
        [self.labels addObject:str];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"TV программа";
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont fontWithName:@"HelveticaNeue-Light" size:22.f],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
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
    cell.datePickerLabel.text = [self.labels objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    TSChanel *channel = [self.channels objectAtIndex:indexPath.row];
    TSChannelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //проверка указана ли дата для отображения программы
    if ([cell.datePickerLabel.text isEqualToString:@""]) {
        // создание UIDatePicker
        self.stateDatePicker = NO;
        if (self.stateDatePicker == NO) {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_UA"];
            self.datePicker = [[UIDatePicker alloc] init];
            self.datePicker.backgroundColor = [UIColor whiteColor];
            self.datePicker.locale = locale;
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            [self.datePicker addTarget:self action:@selector(dateChanged:)
                      forControlEvents:UIControlEventValueChanged];
            if (self.datePicker.superview == nil)
            {
                [self.view.window addSubview: self.datePicker];
                self.view.window.backgroundColor = [UIColor whiteColor];
                
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
                CGRect startRect = CGRectMake(0.0,
                                              screenRect.origin.y + screenRect.size.height,
                                              pickerSize.width, pickerSize.height);
                self.datePicker.frame = startRect;
                
                CGRect pickerRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - pickerSize.height - 49,
                                               self.view.frame.size.width, self.datePicker.frame.size.height);
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationDelegate:self];
                self.datePicker.frame = pickerRect;
                CGRect newFrame = self.tableView.frame;
                newFrame.size.height -= self.datePicker.frame.size.height;
                self.tableView.frame = newFrame;
                [UIView commitAnimations];
                [self.navigationItem setRightBarButtonItem:self.doneButton animated:YES];
                //жест
                self.tapGestureRecognizer =
                [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(tapDoneAction)];
                [self.view addGestureRecognizer:self.tapGestureRecognizer];
            }
            self.stateDatePicker = YES;
        }
    } else {
        TSSelectedProgrammViewController *controller =
        [self.storyboard instantiateViewControllerWithIdentifier:@"TSSelectedProgrammViewController"];
        controller.selectegDate = self.selectData;
        controller.nameChannel = channel.name;
        controller.channelID = channel.ID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)itemDoneAction
{
    [self doneAction:1];
}

//тапом текущая дата не устанавливается, просто убирается пикер

- (void)tapDoneAction
{
    [self doneAction:0];
}

//получение даты

- (void)doneAction:(NSInteger)dateChanged
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect endFrame = self.datePicker.frame;
    endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.datePicker.frame = endFrame;
    [UIView commitAnimations];
    CGRect newFrame = self.tableView.frame;
    newFrame.size.height += self.datePicker.frame.size.height;
    self.tableView.frame = newFrame;
    [self.navigationItem setRightBarButtonItems:nil animated:YES];
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    if (dateChanged == 1) {
        [self dateChanged:self.datePicker];
    }
}

- (void)slideDownDidStop
{
    [self.datePicker removeFromSuperview];
}

- (void)dateChanged:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.selectData = [dateFormatter stringFromDate:[sender date]];
    [self.labels removeObjectAtIndex:self.indexPath.row];
    [self.labels insertObject:self.selectData atIndex:self.indexPath.row];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TSChannelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.datePickerLabel.text = @"";
        [self.labels removeObjectAtIndex:indexPath.row];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить дату";
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
