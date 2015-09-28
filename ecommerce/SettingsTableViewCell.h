//
//  SettingsTableViewCell.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/23/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell
@property(nonatomic, retain)UILabel *primaryLabel;

@property(nonatomic, retain)UILabel *primary_right;

@property(nonatomic, retain)UISwitch *rightBut;

@property(nonatomic, retain)UISegmentedControl *rightseg;
@end
