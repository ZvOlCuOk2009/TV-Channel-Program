//
//  TSSelectedProgrammViewController.h
//  TV Channel Program
//
//  Created by Mac on 07.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSProgrammChannelViewController.h"

@interface TSSelectedProgrammViewController : TSProgrammChannelViewController

@property (strong, nonatomic) NSString *selectegDate;
@property (assign, nonatomic) NSString *channelID;

@end
