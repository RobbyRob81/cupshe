//
//  SettingsTableViewCell.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/23/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

@synthesize primaryLabel,  primary_right,rightBut, rightseg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = NSTextAlignmentLeft;
        primaryLabel.font = [UIFont boldSystemFontOfSize:15];
        primaryLabel.backgroundColor = [UIColor clearColor];
        
        primary_right = [[UILabel alloc]init];
        primary_right.textAlignment = NSTextAlignmentRight;
        primary_right.font = [UIFont boldSystemFontOfSize:15];
        primary_right.textColor = [UIColor darkGrayColor];
        primary_right.backgroundColor = [UIColor clearColor];
        
        rightBut = [[UISwitch alloc] init];
        //rightBut.backgroundColor = [UIColor clearColor];
        NSArray *itemArray = [NSArray arrayWithObjects: @"Male", @"Female", nil];
        rightseg = [[UISegmentedControl alloc] initWithItems:itemArray];
        
        
        
        
        
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:primary_right];
        [self.contentView addSubview:rightBut];
        [self.contentView addSubview:rightseg];
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    
    
    
    frame= CGRectMake(boundsX+20 ,0, 100, 57.3);
    primaryLabel.frame = frame;
    
    //frame= CGRectMake(boundsX+200+45 ,0, 20, 45);
    //primary_right.frame = frame;
    
    frame= CGRectMake(boundsX+100+20 ,0, 180, 57.3);
    primary_right.frame = frame;
    
    
    rightBut.center =CGPointMake(270, 22.5);
    // frame = CGRectMake(boundsX+5, 5, 40, 40);
    // rightBut.frame = frame;
    rightseg.center = CGPointMake(240, 22.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
