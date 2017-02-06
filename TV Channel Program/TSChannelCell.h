//
//  TSChannelCell.h
//  TV Channel Program
//
//  Created by Mac on 03.02.17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSChannelCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pictures;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@end
