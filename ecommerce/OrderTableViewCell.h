//
//  OrderTableViewCell.h
//  Ecommerce
//
//  Created by Hanqing Hu on 8/1/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property(nonatomic, retain)UILabel *primaryLabel;
@property(nonatomic, retain)UILabel *secondaryLabel;
@property(nonatomic, retain)UILabel *primary_right;
@property(nonatomic, retain)UIImageView *leftImage;
@property(nonatomic, retain)UIImageView *rightImage;
@property(nonatomic, retain)UIButton *rightBut;
@end
