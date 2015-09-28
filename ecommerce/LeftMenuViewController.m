//
//  LeftMenuViewController.m
//  Steel Fashion
//
//  Created by Hanqing Hu on 9/8/13.
//  Copyright (c) 2013 Steel Fashion. All rights reserved.
//

#import "LeftMenuViewController.h"
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
#import "LanguageViewController.h"
#import "NSString+FontAwesome.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
@synthesize selected;
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
    
    [Design menu_table:table config:self.config];
    
    menuitem = [[NSMutableArray alloc] init];
    menuImage = [[NSMutableArray alloc] init];
    
    
    [menuitem addObject:[self.config localisedString:@"Shop"]];
    [menuImage addObject:icon_pricetag];
    
   // [menuitem addObject:@"Shop"];
   // [menuImage addObject:@"icon_shop"];
    
   
    
    //[menuitem addObject:@"Settings"];
    //[menuImage addObject:@"more-settings.png"];
    
    // [menuitem addObject:@"Profile"];
    // [menuImage addObject:@"profile.png"];
    
    // [menuitem addObject:@"My Closet"];
    // [menuImage addObject:@"mycloset.png"];
    
    //[menuitem addObject:@"In-App Purchases"];
    //[menuImage addObject:@"more-card.png"];
    
    [menuitem addObject:[self.config localisedString:@"Account"]];
    [menuImage addObject:icon_ios7_gear];
    
    
    NSArray *loc = [self.config.available_locations allKeys];
    
    if (loc.count == 1){
        NSArray *lan = [[self.config.available_locations objectForKey:[loc objectAtIndex:0]] allKeys];
        if (lan.count == 1) hasLang = NO;
        else hasLang = YES;
    } else hasLang = YES;
    
    if (hasLang){
        [menuitem addObject:[self.config localisedString:@"Settings"]];
        [menuImage addObject:icon_ios7_gear];
    }
    
    [menuitem addObject:[self.config localisedString:@"Rate us"]];
    [menuImage addObject:icon_ios7_star];
    
    
    
    shareview = [[BottomPopUpView alloc] initWithFrame:CGRectMake(20, self.config.screenHeight+20, self.config.screenWidth-40, 100)];
    [self.revealController.view addSubview:shareview];
    
    
    
   
    
    //[self selectedMenu:selected];
}



-(void)viewWillAppear:(BOOL)animated{
    [UIView setAnimationsEnabled:YES];
    [table reloadData];
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
    
    
    
    return [menuitem count]+1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MenuTableCell *cell;
    if (indexPath.row > 0){
    cell = [[MenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.primaryLabel.text = [menuitem objectAtIndex:indexPath.row-1];
        cell.leftImage.text = [menuImage objectAtIndex:indexPath.row-1];
        cell.secondaryLabel.hidden = YES;
        cell.rightBut.hidden = YES;
        if ([cell.primaryLabel.text isEqualToString:@"Account"]){
            cell.leftImage.font = [UIFont fontWithName:kFontAwesomeFamilyName size:15];
            cell.leftImage.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-user"];
            
        }
    } else {
        cell = [[MenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.secondaryLabel.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
        [cell.rightBut addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        if (self.config.user_id == nil || [self.config.user_id intValue]== 0){
            cell.secondaryLabel.text = NSLocalizedString(@"Hi, sign in or join for free", @"Hi, sign in or join for free");
            cell.secondaryLabel.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
            cell.rightBut.hidden = NO;
            [cell.rightBut setTitle:@"Join" forState:UIControlStateNormal];
        } else {
            NSString *epart = @"";
            if (self.config.email!= nil){
                NSArray *part = [self.config.email componentsSeparatedByString:@"@"];
                if (part.count > 0){
                    epart = [part objectAtIndex:0];
                }
            }
            cell.secondaryLabel.text = [NSString stringWithFormat:@"Welcome, %@", epart];
            cell.secondaryLabel.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
            cell.rightBut.hidden = NO;
            [cell.rightBut setTitle:@"Logout" forState:UIControlStateNormal];
        }
    }
    
    [Design menu_tableCell:cell config:self.config];
    return cell;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1){
        
        if (selected == 1) {
            [self.revealController showViewController:self.revealController.frontViewController];
        } else {
            PromotionViewController *index =  [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
            
            index.config = self.config;
            
            UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
            
            [Design navigationbar:frontViewController.navigationBar config:self.config];
            
            //[frontViewController setNavigationBarHidden:YES];
            [self.revealController setFrontViewController:frontViewController];
            [self.revealController showViewController:self.revealController.frontViewController];
            [self selectedMenu:1];
        }
        
        
    }
    //SHOP
  /*  else if (indexPath.row == 2){
        ProductViewController *index =  [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
        
        index.config = self.config;
        index.titleText = @"Shop";
        if ([self.config.departments count] == 1) {
            Department *d =[self.config.departments  objectAtIndex:0];
            index.departmentid = d.department_id;
        }
        
        UINavigationController *front = (UINavigationController *)self.revealController.frontViewController;
        [front pushViewController:index animated:YES];
        [self.revealController showViewController:self.revealController.frontViewController];
        [self selectedMenu:2];
    }*/
    
     else if (indexPath.row == 2){
        
         UserAccountViewController *index =  [[UserAccountViewController alloc] initWithNibName:@"UserAccountViewController" bundle:nil];
         
         index.config = self.config;
         
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
         [self selectedMenu:4];
         
     }  else if (indexPath.row == 3 && hasLang){
         LanguageViewController *lv = [[LanguageViewController alloc] initWithNibName:@"LanguageViewController" bundle:nil];
         lv.config = self.config;
         
         UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:lv];
         
         [Design navigationbar:frontViewController.navigationBar config:self.config];
         [self.revealController setFrontViewController:frontViewController];
         [self.revealController showViewController:self.revealController.frontViewController];
         [self selectedMenu:4];
         
     }else if (indexPath.row == 3 && !hasLang){
        [[UIApplication sharedApplication] //                                                                                                   Change to our AppleID...
         openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", self.config.ituneID]]];
     } else if (indexPath.row == 4 && hasLang){
         [[UIApplication sharedApplication] //                                                                                                   Change to our AppleID...
          openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", self.config.ituneID]]];
         
     }
    
}

/*

-(IBAction)menuSelect:(id)sender{
    UIButton *temp = (UIButton *)sender;
    if (temp == promotion){
        if (selected == 1) {
            [self.revealController showViewController:self.revealController.frontViewController];
        } else {
            PromotionViewController *index =  [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
            
            index.config = self.config;
            
            UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
           //[frontViewController.navigationBar setBarTintColor:[UIColor colorWithRed:6/255.0f green:116/255.0f blue:178/255.0f alpha:1.0f]];
             [frontViewController.navigationBar setBarTintColor:[UIColor blackColor]];
            frontViewController.navigationBar.tintColor = [UIColor whiteColor];

            //[frontViewController setNavigationBarHidden:YES];
            [self.revealController setFrontViewController:frontViewController];
            [self.revealController showViewController:self.revealController.frontViewController];
            [self selectedMenu:1];
        }
    } else if (temp == product){
        UINavigationController *front = (UINavigationController *)self.revealController.frontViewController;
            [front pushViewController:index animated:YES];
            [self.revealController showViewController:self.revealController.frontViewController];
            [self selectedMenu:2];
       // }
       
    }else if (temp == cart){
      //  if (selected == 3) {
      //      [self.revealController showViewController:self.revealController.frontViewController];
      //  } else {
            CartViewController *index =  [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
            
            index.config = self.config;
            index.isFromMenu = 1;
            index.parent = self;
            UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:index];
            //[frontViewController.navigationBar setBarTintColor:[UIColor colorWithRed:6/255.0f green:116/255.0f blue:178/255.0f alpha:1.0f]];
             [frontViewController.navigationBar setBarTintColor:[UIColor blackColor]];
            frontViewController.navigationBar.tintColor = [UIColor whiteColor];
            
            //[frontViewController setNavigationBarHidden:YES];
            [self.revealController setFrontViewController:frontViewController];
            [self.revealController showViewController:self.revealController.frontViewController];
            [self selectedMenu:3];
       // }
 
        
        return;
    } else if (temp == rate){
        [[UIApplication sharedApplication] //                                                                                                   Change to our AppleID...
         //openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=853433911"]];
         openURL:[NSURL URLWithString:@"http://goo.gl/lyLACZ"]];
        //[self.config change_quote_limit];
    } else if (temp == contact){
 
    }
}*/

-(void)selectedMenu:(int)i{
    self.selected = i;
 
    if (selected == 1){
      
    } else if (selected == 2){
       
    }
    else if (selected == 3){
       
    }else if (selected == 4){
       
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
        LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lefty.config = self.config;
        [self presentViewController:lefty animated:YES completion:nil];
        return false;
    } else return true;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
