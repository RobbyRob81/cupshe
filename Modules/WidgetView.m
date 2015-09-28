//
//  BottomPopUpView.m
//  Moooh
//
//  Created by Hanqing Hu on 4/13/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "WidgetView.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
@implementation BottomPopUpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layout_view{
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width-40, self.frame.size.height-40)];
    background.backgroundColor = [UIColor whiteColor];
    [self addSubview:background];
    
    UIView *topborder= [[UIView alloc] initWithFrame:CGRectMake(20, 20, self.frame.size.width-40, 5)];
    topborder.backgroundColor =[UIColor colorWithRed:80/255.0 green:156/255.0 blue:87/255.0 alpha:1];
    [self addSubview:topborder];
    
    
    close = [[UIButton alloc] init];
    [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    close.backgroundColor = [UIColor clearColor];
    close.frame = CGRectMake(-2, -2, 44, 44);
    close.titleLabel.font = [IonIcons fontWithSize:30];
    [close setTitleColor:[UIColor colorWithRed:80/255.0 green:156/255.0 blue:87/255.0 alpha:1] forState:UIControlStateNormal];
    [close setTitle:icon_ios7_close forState:UIControlStateNormal];
    
    UILabel *btnback = [[UILabel alloc] initWithFrame:CGRectMake(14, 14, 12, 12)];
    btnback.backgroundColor = background.backgroundColor;
    [self addSubview:btnback];
    
    [self addSubview:close];
}
-(IBAction)close:(id)sender{
    [self toggle_view:NO];
}

-(void)toggle_view:(BOOL)show{
    
    if (show){
        [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.frame = self.show_frame;
                     }
                     completion:^(BOOL finished){
                     }];
    } else {
        [UIView animateWithDuration:0.1f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, self.screen.height+20, self.frame.size.width, self.frame.size.height);
                         }
                         completion:^(BOOL finished){
                         }];
    }

}

@end
