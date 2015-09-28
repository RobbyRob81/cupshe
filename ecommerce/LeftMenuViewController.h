//
//  LeftMenuViewController.h
//  Steel Fashion
//
//  Created by Hanqing Hu on 9/8/13.
//  Copyright (c) 2013 Steel Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WidgetView.h"
@interface LeftMenuViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *menuitem;
    NSMutableArray *menuImage;
    
    BOOL hasLang;
    
    BottomPopUpView *shareview;
    
}

@property int selected;
@property (nonatomic, strong) Config *config;

-(void)selectedMenu:(int)i;
-(void)login;

@end
