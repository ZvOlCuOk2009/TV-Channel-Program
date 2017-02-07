//
//  TSProgrammChannelViewController.h
//  TV Channel Program
//
//  Created by Mac on 07.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger alert;

@class TSContentService;

@interface TSProgrammChannelViewController : UIViewController

@property (strong, nonatomic) NSString *nameChannel;
@property (strong, nonatomic) NSString *pictures;
@property (assign, nonatomic) NSInteger idChannel;
@property (strong, nonatomic) UIBarButtonItem *backItem;
@property (strong, nonatomic) TSContentService *contentService;

@end
