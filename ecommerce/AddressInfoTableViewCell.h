//
//  AddressInfoTableViewCell.h
//  Moooh
//
//  Created by Hanqing Hu on 2/12/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressInfoTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *bigTitle;
@property (nonatomic, strong) UILabel *smallTitle;
@property (nonatomic, strong) UISwitch *sw;
@property (nonatomic, strong) UITextField *value;

@end
