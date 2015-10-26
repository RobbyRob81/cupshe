//
//  CartTableViewCell.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "CartTableViewCell.h"

@implementation CartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.name = [[UITextView alloc]init];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.contentInset = UIEdgeInsetsMake(-10,-5,0,0);
        //self.name.numberOfLines = 1;
        self.name.textColor = [UIColor darkGrayColor];
        self.name.editable = NO;
        self.name.scrollEnabled = NO;
        //self.name.numberOfLines = 0;
        //self.name.lineBreakMode = NSLineBreakByCharWrapping;
        
        self.brand = [[UILabel alloc]init];
        self.brand.textAlignment = NSTextAlignmentLeft;
        self.brand.font = [UIFont boldSystemFontOfSize:15];
        self.brand.textColor = [UIColor darkGrayColor];
        
        
        
        
        self.attr = [[UILabel alloc]init];
        self.attr.textAlignment = NSTextAlignmentLeft;
        self.attr.font = [UIFont systemFontOfSize:15];
        self.attr.backgroundColor = [UIColor clearColor];
        self.attr.textColor = [UIColor darkGrayColor];
        
        self.qty = [[UILabel alloc]init];
        self.qty.textAlignment = NSTextAlignmentLeft;
        self.qty.font = [UIFont systemFontOfSize:15];
        self.qty.backgroundColor = [UIColor clearColor];
        self.qty.textColor = [UIColor darkGrayColor];
        
        self.price = [[UILabel alloc] init];
        
        
        self.leftImage = [[UIImageView alloc]init];
        //rightImage = [[UIImageView alloc] init];
        self.leftImage.contentMode = UIViewContentModeScaleAspectFit;
        //rightImage.contentMode = UIViewContentModeScaleAspectFit;
        self.leftImage.backgroundColor = [UIColor clearColor];
        //rightImage.backgroundColor = [UIColor clearColor];
        
        //rightBut = [[UIButton alloc] init];
        //rightBut.backgroundColor = [UIColor clearColor];
        
        
        
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.brand];
        [self.contentView addSubview:self.attr];
        [self.contentView addSubview:self.qty];
        [self.contentView addSubview:self.price];
        [self.contentView addSubview:self.leftImage];
       
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
    
    CGRect contentFrame = self.contentView.frame;
    
    
    self.leftImage.frame = CGRectMake(5, 5, 130/1.333, 130);
    
    
    self.name.frame = CGRectMake(130/1.333+10, 8, contentFrame.size.width-130/1.333-15, 15);
    self.name.font = [UIFont boldSystemFontOfSize:14];
    self.name.textColor =[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    CGFloat fixedWidth = self.name.frame.size.width;
    CGSize newSize = [self.name sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.name.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    NSLog(@"%f",newSize.height);
    self.name.frame = newFrame;
    
    self.brand.frame =CGRectMake(130/1.333+10, self.name.frame.origin.y+self.name.frame.size.height-17, contentFrame.size.width-130/1.333-5, 15);
    self.brand.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    self.brand.textColor =[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    
    self.attr.frame = CGRectMake(130/1.333+10, self.brand.frame.origin.y+self.brand.frame.size.height, contentFrame.size.width-130/1.333-5, 20);
    self.attr.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    self.attr.textColor =[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    self.qty.frame = CGRectMake(130/1.333+10, contentFrame.size.height-20, (contentFrame.size.width-130/1.333-5)/2, 15);
    self.qty.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    self.qty.textColor =[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    self.price.frame = CGRectMake((contentFrame.size.width-130/1.333-5)/2+130/1.333+10, contentFrame.size.height-20, (contentFrame.size.width-130/1.333-5)/2-15, 15);
    self.price.textAlignment = NSTextAlignmentRight;
    self.price.font = [UIFont boldSystemFontOfSize:13];
    self.price.textColor =[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
