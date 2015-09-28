//
//  CartTableViewCell.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableViewCell : UITableViewCell

@property(nonatomic, strong)UITextView *name;
@property(nonatomic, strong)UILabel *brand;
@property (nonatomic, strong) UILabel *attr;
@property(nonatomic, strong)UILabel *qty;
@property(nonatomic, strong)UILabel *price;
@property(nonatomic, retain)UIImageView *leftImage;
@property(nonatomic, retain)UIImageView *rightImage;
@property(nonatomic, retain)UIButton *rightBut;

@end
