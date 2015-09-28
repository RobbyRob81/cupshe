//
//  FinxLeftMenuViewController.h
//  Moooh
//
//  Created by Hanqing Hu on 2/13/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "SocialShareModule.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WidgetView.h"
@interface FinxLeftMenuViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>{
    UITableView *table;
    
    NSMutableArray *menuitem;
    NSMutableArray *menuImage;
    NSMutableArray *menuindex;
    
    BOOL hasLang;
    SocialShareModule *ss;
    BottomPopUpView *shareview;
}

@property int selected;
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) UIViewController *parent;

-(void)selectedMenu:(int)i;
-(void)login;

@end
