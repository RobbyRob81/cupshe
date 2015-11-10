//
//  AddressInfoTableViewCell.m
//  Moooh
//
//  Created by Hanqing Hu on 2/12/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "AddressInfoTableViewCell.h"

@implementation AddressInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
        self.bigTitle = [[UILabel alloc] init];
        self.bigTitle.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.bigTitle];
        
        self.smallTitle = [[UILabel alloc] init];
        self.smallTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        self.smallTitle.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        [self.contentView addSubview:self.smallTitle];
        
        self.sw = [[UISwitch alloc] init];
        [self.contentView addSubview:self.sw];
        
        self.value = [[UITextField alloc] init];
        self.value.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.value];
        
        
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
    
    
    
    frame= CGRectMake(boundsX+20,0, 250, height);
    self.bigTitle.frame = frame;
    
    frame= CGRectMake(width-63,10, 51, 31);
    self.sw.frame = frame;
    
    frame = CGRectMake(boundsX+20, 3, width, 20);
    self.smallTitle.frame = frame;
    self.smallTitle.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    
    frame = CGRectMake(boundsX+20, 17, width, 42);
    self.value.frame = frame;
    self.value.userInteractionEnabled = YES;
    self.value.textColor = [UIColor darkGrayColor];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
