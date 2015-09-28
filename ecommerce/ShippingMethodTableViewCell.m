//
//  ShippingMethodTableViewCell.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/14/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "ShippingMethodTableViewCell.h"

@implementation ShippingMethodTableViewCell

@synthesize primaryLabel,  primary_right;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = NSTextAlignmentLeft;
        primaryLabel.font = [UIFont systemFontOfSize:16];
        primaryLabel.backgroundColor = [UIColor clearColor];
        primaryLabel.numberOfLines = 2;
        primaryLabel.textColor = [UIColor darkGrayColor];
        
        primary_right = [[UILabel alloc]init];
        primary_right.textAlignment = NSTextAlignmentRight;
        primary_right.font = [UIFont boldSystemFontOfSize:13];
        primary_right.textColor = [UIColor blackColor];
        
        primary_right.layer.cornerRadius = 10;
        
        
     
        
        
        
        [self.contentView addSubview:primaryLabel];
        
        //[self.contentView addSubview:rightImage];
        //[self.contentView addSubview:rightBut];
        [self.contentView addSubview:primary_right];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    //self.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    UIView *selectionColor = [[UIView alloc] init];
    //selectionColor.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    selectionColor.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectionColor;
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGFloat height = contentRect.size.height;
    CGFloat width = contentRect.size.width;
    CGRect frame;
   
    
    
    frame= CGRectMake(boundsX+20,0, 180, height);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(width-110,0, 100, height);
    primary_right.frame = frame;
    
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
