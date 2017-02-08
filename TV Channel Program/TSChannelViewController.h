//
//  TSCategoryChannelViewController.h
//  TV Channel Program
//
//  Created by Mac on 02.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger saveTvProgramm;
extern BOOL syncReceived;

@interface TSChannelViewController : UIViewController

@property (strong, nonatomic) NSArray *channels;

@end
