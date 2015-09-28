//
//  PromotionViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "PromotionViewController.h"
#import "PKRevealController.h"
#import "NSURLConnectionWithTag.h"
#import "Promotion.h"
#import "ProductViewController.h"
#import "CartViewController.h"
#import "Shipping.h"
#import "LoginViewController.h"
#import "Department.h"
#import "IonIcons.h"
#import "NSString+FontAwesome.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "ViewWithData.h"
#import "SocialFeedModule.h"
#import "DeepLinkModule.h"

@interface PromotionViewController ()

@end

@implementation PromotionViewController

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
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Do any additional setup after loading the view from its nib.
        if ((self.config.app_logo == nil || self.config.app_logo.length == 0) || [[[[self.config.design objectForKey:@"settings"] objectForKey:@"main_page"] objectForKey:@"type"] isEqualToString:@"text"]){
            //NSString *title = [[[self.config.design objectForKey:@"settings"] objectForKey:@"main_page"] objectForKey:@"text"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont boldSystemFontOfSize:18.0];
            label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
            label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
            self.navigationItem.titleView = label;
            //if (title== nil || title.length == 0) {
                label.text = self.config.app_text_logo;
            //} else {
                //label.text = title;
            //}
            //[label sizeToFit];
            [Design navigationbar_title:label config:self.config];
    } else {
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.config.app_logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        UIImageView *imageview = [[UIImageView alloc] init];
       
        imageview.image = image;
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.frame = CGRectMake(0, 0, 140, 33);
        self.navigationItem.titleView = imageview;
    }
    
    searchwords = [[NSMutableDictionary alloc] init];
    
    receivedData = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5; i++){
        NSMutableData *rec = [[NSMutableData alloc] init];
        [receivedData addObject:rec];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    
    
   
    UILabel *menubtn = [IonIcons labelWithIcon:icon_navicon_round size:0 color:[UIColor whiteColor]];;
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menu:)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    
    
    self.navigationItem.leftBarButtonItem = barbtn;
    
    
    
    
    cartbtn = [IonIcons labelWithIcon:icon_ios7_cart size:0 color:[UIColor whiteColor]];
    cartbtn.textAlignment = NSTextAlignmentRight;
    cartbtn.frame = CGRectMake(0, 0, 60, 44);
     [Design navigationbar_ion_icon:cartbtn config:self.config];
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"right_navigation_ion_icon"] config:self.config];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cart:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    
    
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
    
    
    self.navigationItem.rightBarButtonItem = menuBtn2;
    
    
    scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64);
    [self.view addSubview:scroll];
    
    
    [self load_view];
    
    //[NSThread detachNewThreadSelector:@selector(load_view) toTarget:self withObject:self];
    
    
    
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [self refresh_badge];
    self.config.temp_cartnum_view = cartbtn;
    [self.config check_cart_with_view:cartbtn];
    [UIView setAnimationsEnabled:YES];
}

-(void) viewDidAppear:(BOOL)animated{
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int loadtime = [[defaults objectForKey:@"collection_load_time"] intValue];
    if (loadtime == 1){
        popup = [[PopUpModule alloc] initWithFrame:CGRectMake(0, self.config.screenHeight+20, self.config.screenWidth, self.config.screenHeight)];
        [popup build_view];
        popup.config = self.config;
        popup.animation = 2;
        popup.showFrame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight);
        //popup.hidden = YES;
        [self.navigationController.view addSubview:popup];
        [popup toggle:YES];
    }
    loadtime++;
    [defaults setObject:[NSString stringWithFormat:@"%d", loadtime] forKey:@"collection_load_time"];*/
    
    if (self.config.store_credit == 0) {
        
    } else {
        
    }
}



-(void)load_view{
    //module_threads = [[NSMutableArray alloc] init];
    flow_layout = [[NSMutableArray alloc] init];
    module_count = 0;
    NSArray *components = [[[self.config.design objectForKey:@"components"] objectForKey:@"main_page"] objectForKey:@"components"];
    for (NSDictionary *d in components){
        NSString *type = [d objectForKey:@"type"];
        if ([type isEqualToString:@"DepartmentModule"]){
            DepartmentModule *dm = [[DepartmentModule alloc] init];
            dm.config = self.config;
            dm.parent = self;
            dm.delegate = self;
            dm.design = d;
            dm.type = [d objectForKey:@"department_type"];
            dm.stype_id = [d objectForKey:@"style_id"];
            
            if (![dm.type isEqualToString:@"multipage"] && refresh == nil){
                refresh = [[UIRefreshControl alloc] init];
                [refresh addTarget:self action:@selector(pageRefresh:) forControlEvents:UIControlEventValueChanged];
                [scroll addSubview:refresh];
            }
            
            DOM *ddom = [[DOM alloc] initWithView:dm parent:self];
            module_count++;
            [flow_layout addObject:ddom];
            
        } else if ([type isEqualToString:@"BillboardModule"]){
            NSString *css = [d objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            
            BillboardModule *bill = [[BillboardModule alloc] init];
            
            bill.delegate = self;
            bill.animationParent = self.view;
            DOM *billdom = [[DOM alloc] initWithView:bill parent:scroll];
            [Design style:billdom design:designs config:self.config];
            
            NSDictionary *compstyle = [d objectForKey:@"component_styles"];
            bill.design_view = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"view"]];
            bill.design_preview = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"preview_image"]];
            bill.design_title = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"title"]];
            bill.design_desc_back = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"description_background"]];
            bill.design_desc = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"description"]];
            bill.design_page_indicator = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"page_indicator"]];
            
            //[bill sync_get_bilboard:self.config department:page.pageid];
            
            module_count++;
            [flow_layout addObject:billdom];
            //[module_threads addObject:billdom];
        }if ([type isEqualToString:@"UILabel"]){
            NSString *css = [d objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            UILabel *label = [[UILabel alloc] init];
            label.text = [d objectForKey:@"content"];
            DOM *label_dom = [[DOM alloc] initWithView:label parent:scroll];
            [Design style:label_dom design:designs config:self.config];
            
            module_count++;
            [flow_layout addObject:label_dom];
            
            
        }
    }

    for (DOM *v in flow_layout){
        if ([v.view isKindOfClass:[DepartmentModule class]]){
            DepartmentModule *dm = (DepartmentModule *)v.view;
            [dm build_department];
        } else if ([v.view isKindOfClass:[BillboardModule class]]){
            BillboardModule *bill = (BillboardModule *)v.view;
            [bill get_bilboard:self.config department:@"-1"];
        }else {
            [self not_module_finish_display:v.view];
        }
    }
    

    
}

-(void)refresh_badge{
     [self.config add_badge:cartbtn withnumber:self.config.cartnum];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu:(id)sender
{
    
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}
-(IBAction)cart:(id)sender{
    //[self done:nil];
    if ((self.config.user_id != nil && ![self.config.user_id isEqualToString:@"0"] && self.config.user_id.length > 0 ) || self.config.guest_checkout){
    CartViewController *cc = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    cc.config = self.config;
    cc.isFromMenu = 0;
        cc.parent = self;
    [self.navigationController pushViewController:cc animated:YES];
    } else {
        LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lefty.config = self.config;
        [self presentViewController:lefty animated:YES completion:nil];
    }
}

-(IBAction)pageRefresh:(id)sender{
    for (int i = 0 ; i < flow_layout.count; i++){
        DOM *d = [flow_layout objectAtIndex:i];
        UIView *v = (UIView *)d.view;
        [v removeFromSuperview];
        v = nil;
        d = nil;
    }
    [flow_layout removeAllObjects];
    flow_layout = nil;
    [self load_view];
    //[NSThread detachNewThreadSelector:@selector(load_view) toTarget:self withObject:self];
}
-(void)billboard_html_touched:(BillboardDetailPage *)detail_page{
    detail_page.hidden = NO;
    //detail_page.frame = CGRectMake(self.config.screenWidth/2, detail_page.touchLocation.y, 0, 0);
    [self.navigationController.view addSubview:detail_page];
    detail_page.frame = CGRectMake(0, self.config.screenHeight, self.config.screenWidth, self.config.screenHeight);
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         detail_page.frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}
-(void)billboard_product_touched:(Billboard *)b{
    NSString *t = b.title;
    
    if (finite != nil)
        [finite pageResign];
    if (infinite!=nil)[infinite pageResign];
    ProductViewController *pv = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    pv.config = self.config;
    pv.filter = b.product_filter;
    pv.departmentid = b.department_id;
    pv.titleText = t;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)billboard_closed:(BillboardDetailPage *)detail_page{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         detail_page.frame = CGRectMake(0, self.config.screenHeight, self.config.screenWidth, self.config.screenHeight);
                     }
                     completion:^(BOOL finished){
                         detail_page.hidden = YES;
                         [detail_page removeFromSuperview];
                     }];
    
}
-(void)not_module_finish_display:(DOM *)v{
    module_count--;
    if (module_count == 0)[self module_finish_loading];
    
}

-(void)billboard_finish_display:(BillboardModule *)module{
    module_count --;
    
    if (module_count == 0) [self module_finish_loading];
    
    
}

-(void)department_finish_display:(DepartmentModule *)module{
    module_count --;
    
    if (module_count == 0) [self module_finish_loading];
    
}
-(void)module_finish_loading{
   if ([[[[self.config.design objectForKey:@"components"] objectForKey:@"main_page"] objectForKey:@"layout" ] isEqualToString:@"Flow"]){
            [Design flow_layout:flow_layout parent:scroll config:self.config];
            float height = 0;
            for (DOM *d in flow_layout){
                
                    [scroll addSubview:d.view];
                    CGRect frame = ((UIView *)d.view).frame;
                    if (frame.origin.y+frame.size.height > height) height = frame.origin.y+frame.size.height;
                
            }
            if (height < self.config.screenHeight-64){
                height = self.config.screenHeight;
            }
            scroll.contentSize = CGSizeMake(self.config.screenWidth, height);
        } else {
            float height = 0;
            for (DOM *d in flow_layout){
                
                    [scroll addSubview:d.view];
                    CGRect frame = ((UIView *)d.view).frame;
                    if (frame.origin.y+frame.size.height > height) height = frame.origin.y+frame.size.height;
                
            }
            if (height < self.config.screenHeight-64){
                height = self.config.screenHeight;
            }
            scroll.contentSize = CGSizeMake(self.config.screenWidth, height);
        }
  
         [refresh endRefreshing];
        
 
    
   
}

@end





