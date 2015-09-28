//
//  PopUpModule.h
//  Moooh
//
//  Created by Hanqing Hu on 4/16/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "SocialShareModule.h"
@interface PopUpModule : UIView {
    SocialShareModule *ss;
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) NSString *html;
@property (nonatomic, strong) NSString *share_message;
@property (nonatomic, strong) UIViewController *parent;
@property  int animation;
@property CGRect showFrame;

-(void)build_view;
-(void)toggle:(BOOL)show;
@end
