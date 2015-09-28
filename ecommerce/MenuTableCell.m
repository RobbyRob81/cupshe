//
//  MenuTableCell.m
//  Steel Fashion
//
//  Created by Hanqing Hu on 12/5/13.
//  Copyright (c) 2013 Steel Fashion. All rights reserved.
//

#import "MenuTableCell.h"
#import "NSString+FontAwesome.h"
#import "IonIcons.h"
@implementation MenuTableCell

@synthesize primaryLabel, secondaryLabel, leftImage, rightImage, primary_right,rightBut;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = NSTextAlignmentLeft;
        //primaryLabel.font = [UIFont boldSystemFontOfSize:15];
        primaryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];;
        primaryLabel.backgroundColor = [UIColor clearColor];
        //primaryLabel.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
        primaryLabel.textColor = [UIColor whiteColor];
        
        primary_right = [[UILabel alloc]init];
        primary_right.textAlignment = NSTextAlignmentCenter;
        //primary_right.font = [UIFont boldSystemFontOfSize:16];
        primary_right.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
        //primary_right.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
        primary_right.textColor = [UIColor whiteColor];
        primary_right.backgroundColor = [UIColor redColor];
        primary_right.layer.cornerRadius = 10;
        
        
        secondaryLabel = [[UILabel alloc]init];
        secondaryLabel.textAlignment = NSTextAlignmentLeft;
        secondaryLabel.font = [UIFont boldSystemFontOfSize:13];
        secondaryLabel.backgroundColor = [UIColor clearColor];
        //secondaryLabel.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
        secondaryLabel.textColor = [UIColor whiteColor];
        
        
        leftImage = [[UILabel alloc]init];
        leftImage.textAlignment = NSTextAlignmentCenter;
        //leftImage.font = [IonIcons fontWithSize:26];
        
        rightImage = [[UIImageView alloc] init];
        //leftImage.contentMode = UIViewContentModeScaleAspectFit;
        rightImage.contentMode = UIViewContentModeScaleAspectFit;
        //leftImage.backgroundColor = [UIColor clearColor];
        rightImage.backgroundColor = [UIColor clearColor];
        
        rightBut = [[UIButton alloc] init];
        rightBut.backgroundColor = [UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1];
        rightBut.tintColor = [UIColor whiteColor];
        rightBut.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        rightBut.layer.cornerRadius = 5;
        
        
        
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
        [self.contentView addSubview:leftImage];
        //[self.contentView addSubview:rightImage];
        [self.contentView addSubview:rightBut];
        //[self.contentView addSubview:primary_right];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    //self.backgroundColor = [UIColor colorWithRed:0.11 green:0.102 blue:0.102 alpha:1];
   // UIView *selectionColor = [[UIView alloc] init];
   // selectionColor.backgroundColor = [UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1];
   // self.selectedBackgroundView = selectionColor;
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame= CGRectMake(boundsX+20 , 19, 25, 25);
    leftImage.frame = frame;
    
    
    frame= CGRectMake(boundsX+55 ,0, 200, 64);
    primaryLabel.frame = frame;
    
    //frame= CGRectMake(boundsX+200+65 ,20, 30, 20);
   // primary_right.frame = frame;
    
    frame= CGRectMake(boundsX+20 ,20, 150, 44);
    secondaryLabel.frame = frame;
    
    //frame = CGRectMake(boundsX+200+45, 0, 20, 45);
    //rightImage.frame = frame;
    frame = CGRectMake(boundsX+190, 27, 70, 30);
    rightBut.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
