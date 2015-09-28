//
//  PopUpModule.m
//  Moooh
//
//  Created by Hanqing Hu on 4/16/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "PopUpModule.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
const int kPopUpAnimationFadeIn = 1;
const int kPopUpAnimationSlideUp = 2;
@implementation PopUpModule

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)build_view{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:self.bounds];
    [self addSubview:blurEffectView];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    web.backgroundColor = [UIColor clearColor];
    web.opaque = NO;
    [web loadHTMLString:@"<div style='color:#161515;text-align:center;width:300px;margin:15em auto 0 auto;'><h1><span style='font-weight: 100;'>Give </span><span class='font-weight:700;'>$10, </span><span style='font-weight: 100;'>Get </span><span class='font-weight:700;'>$10</span></h1></div><p style='color:#161515;text-align:center;width:230px;margin:0 auto 0 auto;'>Sharing is caring. Give a friend some cash and get some too</p>"  baseURL:nil];
    [self addSubview:web];
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 20, 60, 44)];
    close.titleLabel.font = [IonIcons fontWithSize:26];
    [close setTitleColor:[UIColor colorWithRed:22.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1] forState:UIControlStateNormal];
    [close setTitle:icon_ios7_close forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:close];
    
    NSMutableDictionary *design = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *title = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@[@"0",@"0",@"0",@"0"], @"color",  nil];
    NSMutableDictionary *btn = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @[@"22", @"21",@"21",@"1"], @"color",  /*@[@"60",@"0",@"0",@"0"], @"width",@[@"60",@"0",@"0",@"0"], @"height",*/nil];
    //NSMutableDictionary *circle = [[NSMutableDictionary alloc] initWithObjectsAndKeys: @[@"255", @"255",@"255",@"1"], @"color", @[@"60",@"0",@"0",@"0"],@"width", @[@"60",@"0",@"0",@"0"], @"height", nil];
    [design setObject:title forKey:@"title"];
    [design setObject:btn forKey:@"button"];
    //[design setObject:circle forKey:@"button_circle"];
    
    ss = [[SocialShareModule alloc] init];
    ss.parent = self.parent;
    ss.config = self.config;
    ss.button_align = @"center";
    ss.button_width = 50;
    ss.button_fontsize = 27;
    ss.designs = design;
    ss.backgroundColor = [UIColor clearColor];
    ss.frame = CGRectMake(40, self.frame.size.height-200, self.frame.size.width-80, 160);
    [ss build_share_buttons];
    [ss layout_view];
    [ss share_action_target:self action:@selector(share:)];
    [self addSubview:ss];
    
}

-(IBAction)share:(id)sender{
    BOOL ok = [SocialShareModule check_share_available_with_sender:sender withConfig:self.config];
    
    if (!ok) return;
    
    NSLog(@"%@", self.config.app_name);
    NSString *message = [NSString stringWithFormat:@"Check out %@", self.config.app_name];
    
    NSString *aid = @"0";
    UIView *loadingView = nil;
    if (self.config.affiliate != nil && self.config.affiliate.hasAffiliate == 1) {
        aid = self.config.affiliate.aid;
        if (aid != nil && ![aid isEqualToString:@"0"]){
            loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:@"Generating Your Affiliate Link."];
        } else {
            loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:@"Generating Sharing Link."];
        }
    } else {
        loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:@"Generating Sharing Link."];
    }
    [self.parent.navigationController.view addSubview:loadingView];
    
    
    
    [AffiliateModule getLink:self.config.APP_UUID affiliate:aid item:@"" itemType:@"" filter:@"" completion:^(NSString *url, NSError *error) {
        
        [loadingView removeFromSuperview];
        
        [ss present_sharing_dialog_with_message:message image:nil imageurl:nil url:url action_sender:sender action_parent:self.parent];
        
        [self toggle:NO];
        
    }];
}

-(IBAction)close:(id)sender{
    [self toggle:NO];
}

-(void)toggle:(BOOL)show{
    if (self.animation == kPopUpAnimationFadeIn){
        if (show){
            self.alpha = 0;
            self.hidden = NO;
            [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
        } else {
            [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             self.hidden = YES;
                         }];
        }
    } else if (self.animation == kPopUpAnimationSlideUp){
        if (show){
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.frame = self.showFrame;
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        } else {
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.frame = CGRectMake(self.frame.origin.x, self.config.screenHeight+20, self.frame.size.width, self.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
}

@end
