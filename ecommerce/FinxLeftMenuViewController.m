//
//  FinxLeftMenuViewController.m
//  Moooh
//
//  Created by Hanqing Hu on 2/13/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "FinxLeftMenuViewController.h"
#import "PKRevealController.h"
#import "ProductViewController.h"
#import "PromotionViewController.h"
#import "CartViewController.h"
#import "MenuTableCell.h"
#import "UserAccountViewController.h"
#import "LoginViewController.h"
#import "Department.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "NSString+FontAwesome.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "Branch.h"
#import "AffiliateModule.h"
#import "LanguageViewController.h"
@interface FinxLeftMenuViewController ()

@end

@implementation FinxLeftMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = [UIColor colorWithRed:0.074 green:0.34 blue:0.5 alpha:1];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.config.screenWidth, self.config.screenHeight-64)];
    table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 68;
    table.bounces = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:table];
    [Design menu_table:table config:self.config];
    [self.view setBackgroundColor:table.backgroundColor];
    
    CGRect frame =CGRectMake((self.config.screenWidth*2/3)/2-60, 27, 120, 28);
    if (self.config.screenWidth <= 320){
        frame = CGRectMake(self.config.screenWidth/2-80,  27, 120, 28);
    } else if (self.config.screenWidth <= 375) {
        frame = CGRectMake(self.config.screenWidth/2-110,  27, 120, 28);
        
    }
    
    
    
   /* UIImageView *logo = [[UIImageView alloc] initWithFrame:frame];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.tintColor = [UIColor colorWithRed:155.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    
    NSString *key = [self.config.app_logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString: key] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){}
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         UIImage *new = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
         logo.image = new;
     }];
    
    
    
    //[Config loadImageURL:[self.config.app_logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] toImageView:logo withCacheKey:[self.config.app_logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] trim:NO];
    //UIImage *img = [self convertImageToGrayScale:logo.image];
    //logo.image = img;
    [self.view addSubview:logo];*/
    
    NSDictionary *butdesign = [[self.config.design objectForKey:@"design"] objectForKey:@"menu_bottom_button"];
    UILabel *contactLogo = [[UILabel alloc] initWithFrame:CGRectMake(20, self.config.screenHeight
                                                                     -50, 30, 30)];
 /*   contactLogo.font = [IonIcons fontWithSize:25];
    contactLogo.text = icon_ios7_email;
    [Design style:[[DOM alloc] initWithView:contactLogo parent:self.view] design:butdesign config:self.config];
    
    [self.view addSubview:contactLogo];
    
    UIButton *contactBut = [[UIButton alloc] initWithFrame:CGRectMake(42, self.config.screenHeight-50, 100, 32)];
    [Design style:[[DOM alloc] initWithView:contactBut parent:self.view] design:butdesign config:self.config];
    [contactBut addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
    contactBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [contactBut setTitle:[self.config localisedString:@"Contact Us"] forState:UIControlStateNormal];
    contactBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:contactBut];
    
    UILabel *feedbackLogo = [[UILabel alloc] initWithFrame:CGRectMake(140, self.config.screenHeight-50, 30, 30)];
    feedbackLogo.font = [IonIcons fontWithSize:20];
    feedbackLogo.text = icon_ios7_help;
    [Design style:[[DOM alloc] initWithView:feedbackLogo parent:self.view] design:butdesign config:self.config];
    [self.view addSubview:feedbackLogo];
    
    UIButton *feedbackBut = [[UIButton alloc] initWithFrame:CGRectMake(159, self.config.screenHeight-50, 120, 32)];
    feedbackBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [feedbackBut addTarget:self action:@selector(feedback:) forControlEvents:UIControlEventTouchUpInside];
    feedbackBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [feedbackBut setTitle:[self.config localisedString:@"Report a Bug"] forState:UIControlStateNormal];
    [Design style:[[DOM alloc] initWithView:feedbackBut parent:self.view] design:butdesign config:self.config];
    [self.view addSubview:feedbackBut];*/
    
    
    
    menuitem = [[NSMutableArray alloc] init];
    menuImage = [[NSMutableArray alloc] init];
    menuindex = [[NSMutableArray alloc] init];
    
    
    [menuitem addObject:[self.config localisedString:@"Shop"]];
    [menuindex addObject:@"shop"];
    [menuImage addObject:@"fa-tag"];
    
    
    
    [menuitem addObject:[self.config localisedString:@"Account"]];
    [menuindex addObject:@"account"];
    [menuImage addObject:@"fa-user"];
    
   /* if (self.config.wholesale.wholesale_app_id != nil && ![self.config.wholesale.wholesale_app_id isEqualToString:@"0"]){
        [menuindex addObject:@"wholesale"];
        [menuitem addObject:[self.config localisedString:@"Wholesale"]];
        [menuImage addObject:icon_ios7_flag];
    }
    
    
    NSArray *loc = [self.config.available_locations allKeys];
    
    if (loc.count == 1){
        NSArray *lan = [[self.config.available_locations objectForKey:[loc objectAtIndex:0]] allKeys];
        if (lan.count == 1) hasLang = NO;
        else hasLang = YES;
    } else hasLang = YES;
    
    if (hasLang){
        [menuitem addObject:[self.config localisedString:@"Settings"]];
        [menuindex addObject:@"settings"];
        [menuImage addObject:icon_ios7_gear];
    }*/
    
    
    if (self.config.affiliate != nil && ![self.config.affiliate isKindOfClass:[NSNull class]] && self.config.affiliate.hasReferral > 0){
        if (self.config.affiliate.title!= nil && ![self.config.affiliate.title isKindOfClass:[NSNull class]] && self.config.affiliate.title.length > 0) {
            [menuitem addObject:self.config.affiliate.title];
        } else [menuitem addObject:[self.config localisedString:@"Share"]];
        
    } else [menuitem addObject:[self.config localisedString:@"Share"]];
    [menuindex addObject:@"share"];
    [menuImage addObject:@"fa-paper-plane"];
    
    
    
    
    [menuitem addObject:[self.config localisedString:@"Rate Us"]];
    [menuindex addObject:@"rate"];
    [menuImage addObject:@"fa-star"];
    
    [menuitem addObject:[self.config localisedString:@"Report a Bug"]];
    [menuindex addObject:@"bug report"];
    [menuImage addObject:@"fa-bug"];
    
    [menuitem addObject:[self.config localisedString:@"Contact Us"]];
    [menuindex addObject:@"contact"];
    [menuImage addObject:@"fa-envelope"];
    
    
    shareview = [[BottomPopUpView alloc] initWithFrame:CGRectMake(0, self.config.screenHeight+20, self.config.screenWidth, 140)];
    shareview.screen = CGSizeMake(self.config.screenWidth, self.config.screenHeight);
    shareview.backgroundColor = [UIColor clearColor];
    shareview.show_frame = CGRectMake(0, self.config.screenHeight-140, self.config.screenWidth, 140);
    [shareview layout_view];
    
    ss = [[SocialShareModule alloc] initWithFrame:CGRectMake(30, 30, shareview.frame.size.width-60, 80)];
    ss.config = self.config;
    ss.parent = self;
    [ss build_share_buttons];
    [ss layout_view];
    [ss share_action_target:self action:@selector(share:)];
    [shareview addSubview:ss];
    
    
    [self.revealController.view addSubview:shareview];
    
    
    //[self selectedMenu:selected];
}

-(void)viewWillAppear:(BOOL)animated{
    // [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [UIView setAnimationsEnabled:YES];
    [table reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [shareview toggle_view:NO];
    // [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return [menuitem count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MenuTableCell *cell;
    
    cell = [[MenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.primaryLabel.text = [menuitem objectAtIndex:indexPath.row];
    cell.leftImage.font =[UIFont fontWithName:kFontAwesomeFamilyName size:22];
    cell.leftImage.text = [NSString fontAwesomeIconStringForIconIdentifier:[menuImage objectAtIndex:indexPath.row]];
    cell.secondaryLabel.hidden = YES;
    cell.rightBut.hidden = YES;
    
    /*if ([cell.primaryLabel.text isEqualToString:[self.config localisedString:@"Account"]]){
        cell.leftImage.font = [UIFont fontWithName:kFontAwesomeFamilyName size:26];
        cell.leftImage.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-user"];
        
    }
    if ([cell.primaryLabel.text isEqualToString:[self.config localisedString:@"Share"]]){
        //cell.leftImage.font = [IonIcons fontWithSize:29];
        //cell.leftImage.font = [UIFont fontWithName:kFontAwesomeFamilyName size:29];
        
    }*/
    
    [Design menu_tableCell:cell config:self.config];
    
    return cell;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *mtitle = [menuindex objectAtIndex:indexPath.row];
    
    if ([mtitle isEqualToString:@"shop"]){
        
        if (self.selected == 0) {
            [self.revealController showViewController:self.revealController.frontViewController];
        } else {
            PromotionViewController *index =  [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
            
            index.config = self.config;
            
            UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
            
            [Design navigationbar:frontViewController.navigationBar config:self.config];
            
            //[frontViewController setNavigationBarHidden:YES];
            [self.revealController setFrontViewController:frontViewController];
            [self.revealController showViewController:self.revealController.frontViewController];
            [self selectedMenu:0];
        }
        
        
    }
    
    
    else if ([mtitle isEqualToString:@"account"]){
        UserAccountViewController *index =  [[UserAccountViewController alloc] initWithNibName:@"UserAccountViewController" bundle:nil];
        
        index.config = self.config;
        
        UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
        
        [Design navigationbar:frontViewController.navigationBar config:self.config];
        
       // if ([self check_login]){
            [self.revealController setFrontViewController:frontViewController];
            [self.revealController showViewController:self.revealController.frontViewController];
            [self selectedMenu:4];
       /* } else {
            LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            lefty.config = self.config;
            lefty.passView = frontViewController;
            lefty.nav = self.revealController;
            [self presentViewController:lefty animated:YES completion:nil];
        }*/
        
    }else if ([mtitle isEqualToString:@"wholesale"]){
        WholesaleViewController *index =  [[WholesaleViewController alloc] init];
        
        index.conf = self.config;
        
        UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
        
        [Design navigationbar:frontViewController.navigationBar config:self.config];
        
        if ([self check_login]){
            [self.revealController setFrontViewController:frontViewController];
            [self.revealController showViewController:self.revealController.frontViewController];
            [self selectedMenu:4];
        } else {
            LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            lefty.config = self.config;
            lefty.passView = frontViewController;
            lefty.nav = self.revealController;
            [self presentViewController:lefty animated:YES completion:nil];
        }
        
        
        
        
    } else if ([mtitle isEqualToString:@"settings"] ){
        LanguageViewController *lv = [[LanguageViewController alloc] initWithNibName:@"LanguageViewController" bundle:nil];
        lv.config = self.config;
        
        UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:lv];
        
        [Design navigationbar:frontViewController.navigationBar config:self.config];
        [self.revealController setFrontViewController:frontViewController];
        [self.revealController showViewController:self.revealController.frontViewController];
        [self selectedMenu:4];
        
    }else if ([mtitle isEqualToString:@"share"]){
        [self.revealController.view addSubview:shareview];
        [shareview toggle_view:YES];
        
        
        
        
        
    } else if ([mtitle isEqualToString:@"rate"]){
        
        NSString *str =[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", self.config.ituneID];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", self.config.ituneID];
        }
        
        [[UIApplication sharedApplication] //                                                                                                   Change to our AppleID...
         openURL:[NSURL URLWithString:str]];
    }
    
    else if ([mtitle isEqualToString:@"contact"]){
        
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:self.config.app_email]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    
    else if ([mtitle isEqualToString:@"bug report"]){
        
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Report a Bug"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"support@twixxies.com"]];
        [mailCont setMessageBody:[NSString stringWithFormat:@"%@ %@ %@:", self.config.app_name, self.config.app_version, [self.config localisedString:@"Bug Report"]] isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    
}

-(IBAction)share:(id)sender{
    BOOL ok = [SocialShareModule check_share_available_with_sender:sender withConfig:self.config];
    
    if (!ok) return;
    
    NSString *message = [self.config.sharingText objectForKey:@"side_menu"];
    if (message == nil || message.length == 0) message = [NSString stringWithFormat:@"Check out %@", self.config.app_name];
    if (self.config.affiliate != nil && self.config.affiliate.hasReferral == 1 && self.config.affiliate.message != nil){
        message = self.config.affiliate.message;
    }
    
    NSString *aid = @"0";
    NSString *filter = @"";
    UIView *loadingView = nil;
    if (self.config.affiliate != nil && self.config.affiliate.hasAffiliate == 1 && self.config.affiliate.hasReferral == 0) {
        aid = self.config.affiliate.aid;
        if (aid != nil && ![aid isEqualToString:@"0"]){
            loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:[self.config localisedString:@"Generating Your Affiliate Link."]];
        } else {
            loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:[self.config localisedString:@"Generating Sharing Link."]];
        }
    } else {
        loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight) withMessage:[self.config localisedString:@"Generating Sharing Link."]];
        if (self.config.affiliate != nil && self.config.affiliate.hasReferral == 1 && self.config.affiliate.referal_filter != nil){
            filter = self.config.affiliate.referal_filter;
        }
    }
    [self.revealController.view addSubview:loadingView];
    
    
    
    
    [AffiliateModule getLink:self.config.APP_UUID affiliate:aid item:@"" itemType:@"" filter:filter completion:^(NSString *url, NSError *error) {
        
        [loadingView removeFromSuperview];
        
        [ss present_sharing_dialog_with_message:message image:nil imageurl:nil url:url action_sender:sender action_parent:self];
        
    }];
}

-(IBAction)contact:(id)sender{
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    
    [mailCont setSubject:@""];
    [mailCont setToRecipients:[NSArray arrayWithObject:self.config.app_email]];
    [mailCont setMessageBody:@"" isHTML:NO];
    
    [self presentViewController:mailCont animated:YES completion:nil];
}
-(IBAction)feedback:(id)sender{
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    
    [mailCont setSubject:@"Report a Bug"];
    [mailCont setToRecipients:[NSArray arrayWithObject:@"hello@twixxies.com"]];
    [mailCont setMessageBody:@"" isHTML:NO];
    
    [self presentViewController:mailCont animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil ];
}

-(void)selectedMenu:(int)i{
    self.selected = i;
    
    if (self.selected == 1){
        
    } else if (self.selected == 2){
        
    }
    else if (self.selected == 3){
        
    }else if (self.selected == 4){
        
    }
}

-(void)login{
    if ([self check_login]){
        [self.config logout];
        [table reloadData];
    }
}

-(BOOL)check_login{
    if (self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"]) {
        
        return false;
    } else return true;
}



@end
