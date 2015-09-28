//
//  SocialShareModule.h
//  Moooh
//
//  Created by Hanqing Hu on 4/13/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import <FBSDKShareKit/FBSDKShareKit.h>
@interface SocialShareModule : UIView <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, FBSDKSharingDelegate>{
    NSMutableArray *buttons;
    UILabel *label;
}

@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSMutableDictionary *designs;
@property float button_width;
@property float button_fontsize;
@property NSString *button_align;
@property (nonatomic, strong) UIViewController *parent;


-(void)build_share_buttons;
-(void)layout_view;
-(void)share_action_target:(id)target action:(SEL)selector;

+(BOOL)check_share_available_with_sender:(id)sender withConfig:(Config *)config;
+(NSString *)check_share_type:(id)sender;
-(void)present_sharing_dialog_with_message:(NSString *)message image:(UIImage *)img imageurl:(NSString *)imageurl url:(NSString *)url action_sender:(id)sender action_parent:(UIViewController *)parent;

@end


