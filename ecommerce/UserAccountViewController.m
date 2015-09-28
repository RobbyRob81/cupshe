//
//  SettingsViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/31/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "UserAccountViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "ProductFavoriteViewController.h"
#import "ChangeCardViewController.h"
#import "NotificationsViewController.h"
#import "PolicyViewController.h"
#import "OrderViewController.h"
#import "PKRevealController.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "Design.h"
#import "ShippingViewController.h"
#import "BillingAddressViewController.h"
#import "Branch.h"
#import "AffiliateModule.h"
#import "PromotionViewController.h"
#import "NSURLConnectionBlock.h"
#import "JSCustomBadge.h"
#import "LanguageViewController.h"
#import "StoreLocationViewController.h"
@implementation UserAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        push_count = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString: @"Account"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    // Do any additional setup after loading the view from its nib.
    
    
    /*logoutbtn = [[UILabel alloc] init];
    logoutbtn.text = [self.config localisedString:@"Log Out"];
    logoutbtn.textAlignment = NSTextAlignmentRight;
    logoutbtn.frame = CGRectMake(0, 0, 120, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
    [logoutbtn addGestureRecognizer:tap];
    logoutbtn.userInteractionEnabled = YES;
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:logoutbtn];
    self.navigationItem.rightBarButtonItem = menuBtn2;
    [Design style:[[DOM alloc] initWithView:logoutbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];*/
    
    
    UIView *cartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    cartView.userInteractionEnabled = YES;
    cartView.clipsToBounds = NO;
    
    logoutbtn = [[UILabel alloc] init];
    logoutbtn.text = [self.config localisedString:@"Log Out"];
    logoutbtn.textAlignment = NSTextAlignmentRight;
    logoutbtn.frame = CGRectMake(80-120, 0, 120, 44);
    logoutbtn.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logout:)];
    [logoutbtn addGestureRecognizer:tap];
    logoutbtn.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:logoutbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    //NSDictionary *d =[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] ;
    
    [cartView addSubview:logoutbtn];
    
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartView];
    
    
    self.navigationItem.rightBarButtonItem = menuBtn2;
    
    
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_navicon_round size:34 color:[UIColor blackColor]];
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    
    
    self.navigationItem.leftBarButtonItem = barbtn;
    
    

    
    
    
   /* NSString *login = @"Login";
    if (!(self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"])){
        login = @"Log Out";
    }
    menuitems = [[NSArray alloc] initWithObjects:@"Profile",@"Credit Card", @"My Order",@"Privacy Policy", @"Return Policy", @"Contact Us", login, nil];*/
}
-(void)viewWillAppear:(BOOL)animated{
    [self get_push_count];
    NSString *login = [self.config localisedString:@"Log In"];
    if (!(self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"])){
        login = [self.config localisedString:@"Log Out"];
         logoutbtn.text = [self.config localisedString:@"Log Out"];
    } else {
        login = [self.config localisedString:@"Log In"];
        logoutbtn.text = [self.config localisedString:@"Log In"];

    }
    
    menuItems = [[NSMutableDictionary alloc] init];
    sectionTitle = [[NSMutableArray alloc] init];
    
    NSMutableArray *profile = [[NSMutableArray alloc] initWithObjects:@"Billing Info",@"Credit Card",@"My Favorites", @"Notifications", @"Order History", @"Settings", @"Shipping Info",nil];
    
    //menuitems = [[NSArray alloc] initWithObjects:@"Profile",@"Credit Card", @"My Orders",@"Privacy Policy", @"Return Policy", @"Contact Us", login, @"Bug Report",nil];
    if ([self.config.payment_method isEqualToString:@"Paypal"]){
        //profile = [[NSMutableArray alloc] initWithObjects:@"Order History",@"My Favorites", @"Settings",@"Notifications", @"Billing Info", @"Shipping Info",nil];
    }
    
    if (self.config.affiliate != nil && self.config.affiliate.hasAffiliate == 1) {
        [profile insertObject:@"Affiliate" atIndex:0];
    }
    
    if (self.config.wholesale.wholesale_app_id != nil && ![self.config.wholesale.wholesale_app_id isEqualToString:@"0"]){
        [profile addObject:@"Wholesale"];
    }
    
    NSArray *credit = [[NSArray alloc] initWithObjects:@"Credits Available", nil];
    
    NSArray *lan = [[NSArray alloc] initWithObjects:@"Region", nil];
    
    NSMutableArray *about = [[NSMutableArray alloc] initWithObjects:@"About", @"Policy", nil];
    
    

    [sectionTitle addObject:@"Hi there,"];
    [menuItems setObject:credit forKey:@"Hi there,"];
    [sectionTitle addObject:@"Profile"];
    [menuItems setObject:profile forKey:@"Profile"];
    
    NSArray *loc = [self.config.available_locations allKeys];
    BOOL hasLang = false;
    if (loc.count == 1){
        NSArray *lan = [[self.config.available_locations objectForKey:[loc objectAtIndex:0]] allKeys];
        if (lan.count == 1) hasLang = NO;
        else hasLang = YES;
    } else hasLang = YES;
    
    if (hasLang){
        [sectionTitle addObject:@"Region"];
        [menuItems setObject:lan forKey:@"Region"];
    }
    
    
    [sectionTitle addObject:@"Policy"];
    [menuItems setObject:about forKey:@"Policy"];
    
    
    
    
    [table reloadData];
    
    [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *error) {
        
        NSInteger credits = [[Branch getInstance] getCredits];
        self.config.store_credit = [[NSDecimalNumber alloc] initWithInteger:credits];
        [table reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)get_push_count{
    NSString *uid= self.config.user_id;
    if (self.config.user_id == nil) uid = @"0";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     NSString *last_push = @"";
    if ([defaults objectForKey:@"last_push_time_stamp"] != nil)
    last_push = [defaults objectForKey:@"last_push_time_stamp"];
    
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&token=%@&last_push_time=%@",  self.config.APP_UUID, uid, self.config.token, last_push];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",self.config.API_ROOT, self.config.API_PUSH_NOTIFICATION_NUM]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            push_count = [[dic objectForKey:@"count"] intValue];
            [table reloadData];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[menuItems allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [sectionTitle objectAtIndex:section];
    NSArray *arr = [menuItems objectForKey:key];
    return [arr count];
    
    
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [sectionTitle objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        NSString *title = [self.config localisedString:[[menuItems objectForKey:@"Hi there,"] objectAtIndex:indexPath.row]];
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = title;
        cell.textLabel.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
        
        UILabel *credit = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth-200, 0, 170, tableView.rowHeight)];
        credit.textAlignment = NSTextAlignmentRight;
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        float r = roundf ([self.config.store_credit floatValue] * 100) / 100.0;
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithFloat:r]];
        
        credit.text = [NSString stringWithFormat:@"%@ %@", [self.config getCurrencySymbol], formatted];
        credit.textColor = cell.textLabel.textColor;
        credit.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
        [cell addSubview:credit];
        
        return cell;
    }
    else{
        NSString *key = [sectionTitle objectAtIndex:indexPath.section];
        NSString *title = [self.config localisedString:[[menuItems objectForKey:key] objectAtIndex:indexPath.row]];
    
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = title;
        cell.textLabel.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString *titletext = [[menuItems objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.section]] objectAtIndex:indexPath.row];
        
        if ([title isEqualToString: @"Notifications"]){
            if (push_count > 0){
                
                UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth-80, table.rowHeight/2-12, 40, 24)];
                balance.textAlignment = NSTextAlignmentCenter;
                balance.textColor = cell.textLabel.textColor;
                balance.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
                balance.text = [NSString stringWithFormat:@"%d", push_count];
                balance.layer.borderColor = [cell.textLabel.textColor CGColor];
                balance.layer.cornerRadius =12;
                balance.layer.borderWidth = 0.5;
                [cell addSubview:balance];
                
                
              /*  JSCustomBadge *badge = [JSCustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", push_count]];
                badge.tag = -11;
            
                badge.frame = CGRectMake(self.config.screenWidth-80, 9, 40, 26);
            
                [cell addSubview:badge];*/
            }
        }
        if ([title isEqualToString:@"Region"]){
            UILabel *reg = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth-200, 0, 170, tableView.rowHeight)];
            reg.text = [self.config.codetolanguage objectForKey:self.config.language];
            reg.textColor = cell.textLabel.textColor;
            reg.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
            reg.textAlignment = NSTextAlignmentRight;
            cell.textLabel.text = [self.config.codetocountry objectForKey:self.config.location];
            [cell addSubview:reg];
        }
        if ([title isEqualToString:@"Affiliate"]){
            if (self.config.affiliate == nil || self.config.affiliate.aid == nil || self.config.affiliate.aid.length == 0 || [self.config.affiliate.aid isEqualToString:@"0"]){
            UILabel *reg = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth-200, 0, 170, tableView.rowHeight)];
                reg.text = [self.config localisedString:@"Inactive"];
            reg.textColor = cell.textLabel.textColor;
            reg.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
            reg.textAlignment = NSTextAlignmentRight;
           // cell.textLabel.text = @"Inactive";
            [cell addSubview:reg];
            }
        }
        
        return cell;
    }
    
    
    
    
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [sectionTitle objectAtIndex:indexPath.section];
    NSString *title = [[menuItems objectForKey:key] objectAtIndex:indexPath.row];
    if ([title isEqualToString:@"Order History"]){
        if ([self check_login]){
            
            OrderViewController *ch = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
            ch.config=self.config;
            [self.navigationController pushViewController:ch animated:YES];
        }
        
    } if ([title isEqualToString:@"My Favorites"]){
        if ([self check_login]){
            
            ProductFavoriteViewController *ch = [[ProductFavoriteViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
            ch.config=self.config;
            [self.navigationController pushViewController:ch animated:YES];
        }
        
    } else if ([title isEqualToString: @"Credit Card"]){
        if ([self check_login]){
            ChangeCardViewController *ch = [[ChangeCardViewController alloc] initWithNibName:@"ChangeCardViewController" bundle:nil];
            ch.config=self.config;
            [self.navigationController pushViewController:ch animated:YES];
        }
    } else if ([title isEqualToString: @"Region"]){
        LanguageViewController *lv = [[LanguageViewController alloc] initWithNibName:@"LanguageViewController" bundle:nil];
        lv.config = self.config;
        [self.navigationController pushViewController:lv animated:YES];
    }else if ([title isEqualToString: @"Settings"]){
        if ([self check_login]){
            ProfileViewController *index =  [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
            
            index.config = self.config;
            [self.navigationController pushViewController:index animated:YES];
        }
    }else if ([title isEqualToString: @"Notifications"]){
        if ([self check_login]){
        NotificationsViewController *bv = [[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
        bv.config = self.config;
        [self.navigationController pushViewController:bv animated:YES];
        }
    }
    else if ([title isEqualToString: @"Shipping Info"]){
        if ([self check_login]){
        ShippingViewController *sv = [[ShippingViewController alloc] initWithNibName:@"ShippingViewController" bundle:nil];
        sv.is_setting = YES;
        sv.config = self.config;
        [self.navigationController pushViewController:sv animated:YES];
        }
    }else if ([title isEqualToString: @"Billing Info"]){
        if ([self check_login]){
            BillingAddressViewController *sv = [[BillingAddressViewController alloc] initWithNibName:@"BillingAddressViewController" bundle:nil];
            sv.is_setting = YES;
            sv.config = self.config;
            [self.navigationController pushViewController:sv animated:YES];
        }
    }
    else if ([title isEqualToString: @"Affiliate"]){
        if ([self check_login]){
            AffiliateViewController *sv = [[AffiliateViewController alloc] init];
            sv.config = self.config;
            
           
            [self.navigationController pushViewController:sv animated:YES];
        }
    }else if ([title isEqualToString:@"Policy"]){
        PolicyViewController *po = [[PolicyViewController alloc] initWithNibName:@"PolicyViewController" bundle:nil];
        po.policytype = 1;
        po.config = self.config;
        [self.navigationController pushViewController:po animated:YES];
    } else if ([title isEqualToString:@"About"]){
        PolicyViewController *po = [[PolicyViewController alloc] initWithNibName:@"PolicyViewController" bundle:nil];
        po.policytype = 0;
        po.config = self.config;
        [self.navigationController pushViewController:po animated:YES];
    } else if ([title isEqualToString:@"Store Locations"]){
        StoreLocationViewController *po = [[StoreLocationViewController alloc] init];
                                           
        //po.policytype = 0;
        po.config = self.config;
        [self.navigationController pushViewController:po animated:YES];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil ];
}

-(BOOL)check_login{
    if (self.config.email == nil || self.config.email.length == 0 || self.config.user_id == nil || self.config.user_id.length == 0 || [self.config.user_id isEqualToString:@"0"]) {
        LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lefty.config = self.config;
        [self presentViewController:lefty animated:YES completion:nil];
        return false;
    } else return true;
}

-(void)back{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}

-(IBAction)logout:(id)sender{
    if ([self check_login]){
        [self.config logout];
        logoutbtn.text = [self.config localisedString:@"Log In"];
        
        PromotionViewController *index =  [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
        
        index.config = self.config;
        
        UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
        
        [Design navigationbar:frontViewController.navigationBar config:self.config];
        
        //[frontViewController setNavigationBarHidden:YES];
        [self.navigationController.revealController setFrontViewController:frontViewController];
        [self.navigationController.revealController showViewController:self.revealController.frontViewController];
        
        
        
        
    } else {
       
    }
}


@end
