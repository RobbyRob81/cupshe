//
//  OrderTableViewCell.m
//  Ecommerce
//
//  Created by Hanqing Hu on 8/1/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

@synthesize primaryLabel, secondaryLabel, leftImage, rightImage, primary_right,rightBut;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = NSTextAlignmentLeft;
        primaryLabel.font = [UIFont boldSystemFontOfSize:17];
        primaryLabel.backgroundColor = [UIColor clearColor];
        primaryLabel.textColor = [UIColor blackColor];
        
        primary_right = [[UILabel alloc]init];
        primary_right.textAlignment = NSTextAlignmentLeft;
        primary_right.font = [UIFont boldSystemFontOfSize:14];
        primary_right.textColor = [UIColor colorWithRed:0.686 green:0.686 blue:0.686 alpha:1];
        primary_right.backgroundColor = [UIColor clearColor];
        primary_right.layer.cornerRadius = 10;
        
        
        secondaryLabel = [[UILabel alloc]init];
        secondaryLabel.textAlignment = NSTextAlignmentLeft;
        secondaryLabel.font = [UIFont boldSystemFontOfSize:14];
        secondaryLabel.backgroundColor = [UIColor clearColor];
        secondaryLabel.textColor = [UIColor colorWithRed:0.686 green:0.686 blue:0.686 alpha:1];
        
        
       /* leftImage = [[UIImageView alloc]init];
        rightImage = [[UIImageView alloc] init];
        leftImage.contentMode = UIViewContentModeScaleAspectFit;
        rightImage.contentMode = UIViewContentModeScaleAspectFit;
        leftImage.backgroundColor = [UIColor clearColor];
        rightImage.backgroundColor = [UIColor clearColor];
        
        rightBut = [[UIButton alloc] init];
        rightBut.backgroundColor = [UIColor colorWithRed:0.894 green:0.459 blue:0.216 alpha:1];
        rightBut.tintColor = [UIColor whiteColor];
        rightBut.layer.cornerRadius = 5;*/
        
        
        
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
        //[self.contentView addSubview:leftImage];
        //[self.contentView addSubview:rightImage];
        //[self.contentView addSubview:rightBut];
        [self.contentView addSubview:primary_right];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    // UIView *selectionColor = [[UIView alloc] init];
    // selectionColor.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
    // self.selectedBackgroundView = selectionColor;
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
   // frame= CGRectMake(boundsX+20 , 17, 30, 30);
   // leftImage.frame = frame;
    
    
    frame= CGRectMake(boundsX+25 ,0, contentRect.size.width, 34);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX+25 ,34, contentRect.size.width, 20);
     primary_right.frame = frame;
    
    frame= CGRectMake(boundsX+25 ,54, contentRect.size.width, 20);
    secondaryLabel.frame = frame;
    
    //frame = CGRectMake(boundsX+200+45, 0, 20, 45);
    //rightImage.frame = frame;
   // frame = CGRectMake(boundsX+190, 27, 70, 30);
   // rightBut.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
