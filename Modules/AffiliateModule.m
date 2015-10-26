//
//  AffiliateModule.m
//  Moooh
//
//  Created by Hanqing Hu on 3/21/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "AffiliateModule.h"
#import "NSURLConnectionBlock.h"
#import "Config.h"
#import "OrderTableViewCell.h"
#import "ViewWithData.h"
#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "NSString+FontAwesome.h"
#import "JSCustomBadge.h"
#import "WidgetView.h"
#import "SocialShareModule.h"
const int AFF_GET_AFFILIATE = 1;
const NSString *AFF_GET_MERCHANT_URL = @"https://www.twixxies.com/affiliateapi/app_getMerchant";
const NSString *AFF_GET_AFFILIATE_URL = @"https://www.twixxies.com/affiliateapi/app_getAffiliate";
const NSString *AFF_GET_LINK = @"https://www.twixxies.com/affiliateapi/app_getLink";
const NSString *AFF_GET_AFFILIATE_DETAIL = @"https://www.twixxies.com/affiliateapi/app_getAffiliateDetail";
const NSString *AFF_APPLY = @"https://www.twixxies.com/affiliateapi/app_applyAffiliate/";
const NSString *AFF_REDEEM = @"https://www.twixxies.com/affiliateapi/app_redeem/";
const NSString *AFF_SAVE_EVENT = @"https://www.twixxies.com/affiliateapi/app_saveEvent/";
const NSString *AFF_GET_BANNER = @"https://www.twixxies.com/affiliateapi/app_getBanner/";
@implementation AffiliateModule

+(void)getMerchant:(Config *)config completion:(void(^)(AffiliateModule *am, NSError *error))completion{
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&location=%@&currency=%@", config.APP_UUID, config.location, config.currency];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_GET_MERCHANT_URL]]];
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
            
            AffiliateModule *am = [[AffiliateModule alloc] init];
            am.mid = [dic objectForKey:@"merchant_id"];
            am.hasAffiliate = [[dic objectForKey:@"has_affiliate"] intValue];
            am.hasReferral = [[dic objectForKey:@"has_referral"] intValue];
            
            if (am.hasReferral > 0){
                NSDictionary *d = [dic objectForKey:@"referral"];
                if (d != nil) {
                    am.title =  [[d objectForKey:@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    am.desc = [[d objectForKey:@"description"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    am.message = [[d objectForKey:@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    am.referal_filter = [d objectForKey:@"filters"];
                }
                
            }
            
            
            completion(am, nil);
        } else {
            //There was an error
            completion(nil, nil);
        }
        
    };
    [connection start];
    
}

+(void)getAffiliateID:(NSString *)appkey email:(NSString*)email completion:(void(^)(NSString *aid, NSError *error))completion{
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&email=%@", appkey, email];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_GET_AFFILIATE_URL]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            NSString *aid = [dic objectForKey:@"affiliate_id"];
            completion(aid, nil);
        } else {
            //There was an error
            completion(@"0", nil);
        }
        
    };
    [connection start];
    
}

+(void)getLink:(NSString *)appkey affiliate:(NSString *)aid item:(NSString *)iid itemType:(NSString *)type filter:(NSString *)filters completion:(void(^)(NSString *url, NSError *error))completion{
    
    if (aid == nil || [aid isKindOfClass:[NSNull class]] || aid.length == 0){
        aid = @"0";
    }
    
    if (iid == nil || [iid isKindOfClass:[NSNull class]] || iid.length == 0){
        iid = @"0";
    }
    
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&affiliate_id=%@&item_id=%@&item_type=%@&item_source=%@&filters=%@", appkey, aid, iid, type, filters ,@"Twixxies"];
    
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_GET_LINK]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@", response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            NSString *url = [dic objectForKey:@"url"];
            completion(url, nil);
            
            
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
}

+(void)saveEvent:(NSString *)appkey affiliate:(NSString *)aid event:(NSString *)event json_data:(NSString *)json{
    if (aid == nil || [aid isKindOfClass:[NSNull class]] || aid.length == 0){
        return;
    }
    
    if (event == nil || [event isKindOfClass:[NSNull class]] || event.length == 0){
        return;
    }
    
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&affiliate_id=%@&event=%@&event_data=%@", appkey, aid, event, json];
    
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_SAVE_EVENT]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            //NSLog(@"%@", response);
            
                       
            
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
}


+(UIView *)getLoadingScreen:(CGRect)frame withMessage:(NSString *)mes{
    UIView *main = [[UIView alloc] initWithFrame:frame];
    main.frame = frame;
    main.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [blurEffectView setFrame:main.bounds];
    [main addSubview:blurEffectView];
    
    
    
    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(main.frame.size.width/2-130, main.frame.size.height/2-100, 260, 150)];
    loading.layer.borderWidth = 0.5;
    loading.layer.borderColor = [[UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1] CGColor];
    loading.backgroundColor = [UIColor whiteColor];
    loading.layer.cornerRadius = 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, loading.frame.size.height/2-50, loading.frame.size.width-20, 60)];
    label.textColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    label.text = mes;
    [loading addSubview:label];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(loading.frame.size.width/2-indicator.frame.size.width/2, loading.frame.size.height/2+20, indicator.frame.size.width, indicator.frame.size.height);
    [indicator startAnimating];
    [loading addSubview:indicator];
    
    [main addSubview:loading];
    
    return main;
    
}


@end



@implementation AffiliateViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    Config *conf = (Config *)self.config;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [conf localisedString:@"Affiliate Program"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:conf];
    
    
    
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[conf.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    self.navigationItem.leftBarButtonItem = barbtn;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(conf.screenWidth/2-indicator.frame.size.width/2, conf.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    
    Config *cf = (Config *)self.config;
    if (cf.affiliate == nil || cf.affiliate.aid == nil || [cf.affiliate.aid isEqualToString:@"0"]){
        [self load_apply_view];
    } else {
        [self load_view];
    }
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)load_apply_view{
    
    Config *cf = (Config *)self.config;
    
    UIColor *darkg = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, cf.screenWidth, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [cf localisedString:@"Join Our Affiliate Program"];
    title.textColor = darkg;
    [self.view addSubview:title];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, cf.screenWidth-60, 45)];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.numberOfLines = 2;
    subtitle.lineBreakMode = NSLineBreakByWordWrapping;
    subtitle.text=[cf localisedString:@"Share products and earn cash whenever someone makes a purchase using your unique link"];
    subtitle.font = [UIFont systemFontOfSize:13];
    subtitle.textColor = [UIColor lightGrayColor];
    [self.view addSubview:subtitle];
    
    
    
    UIView *emailpane = [[UIView alloc] initWithFrame:CGRectMake(30, subtitle.frame.origin.y+subtitle.frame.size.height+15, cf.screenWidth-60, 30)];
    UILabel *emailicon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, emailpane.frame.size.height, emailpane.frame.size.height)];
    emailicon.font = [IonIcons fontWithSize:25];
    emailicon.text = icon_email;
    emailicon.textColor = [UIColor lightGrayColor];
    [emailpane addSubview:emailicon];
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(emailicon.frame.origin.x+emailicon.frame.size.width, 0, emailpane.frame.size.width - emailicon.frame.size.width, emailpane.frame.size.height)];
    emailLabel.text = cf.email;
    emailLabel.textColor = [UIColor lightGrayColor];
    [emailpane addSubview:emailLabel];
    CALayer *emaillayer= [CALayer layer];
    emaillayer.frame = CGRectMake(0, emailpane.frame.size.height, emailpane.frame.size.width, 0.5);
    emaillayer.backgroundColor = [darkg CGColor];
    [emailpane.layer addSublayer:emaillayer];
    [self.view addSubview:emailpane];
    
    UIView *urlpane = [[UIView alloc] initWithFrame:CGRectMake(emailpane.frame.origin.x, emailpane.frame.origin.y+emailpane.frame.size.height+15, cf.screenWidth-60, 30)];
    UILabel *urlicon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, urlpane.frame.size.height, urlpane.frame.size.height)];
    urlicon.font = [IonIcons fontWithSize:25];
    urlicon.text = icon_link;
    [urlpane addSubview:urlicon];
    apply_url = [[UITextField alloc] initWithFrame:CGRectMake(urlicon.frame.origin.x+urlicon.frame.size.width, 0, urlpane.frame.size.width - urlicon.frame.size.width, urlpane.frame.size.height)];
    apply_url.placeholder = [cf localisedString:@"Site URL http://www.mysite.com"];
    [urlpane addSubview:apply_url];
    CALayer *urllayer= [CALayer layer];
    urllayer.frame = CGRectMake(0, urlpane.frame.size.height, urlpane.frame.size.width, 0.5);
    urllayer.backgroundColor = [darkg CGColor];
    [urlpane.layer addSublayer:urllayer];
    [self.view addSubview:urlpane];
    
    
    UIView *phonepane = [[UIView alloc] initWithFrame:CGRectMake(urlpane.frame.origin.x, urlpane.frame.origin.y+urlpane.frame.size.height+15, cf.screenWidth-60, 30)];
    UILabel *phoneicon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, phonepane.frame.size.height, phonepane.frame.size.height)];
    phoneicon.font = [IonIcons fontWithSize:25];
    phoneicon.text = icon_ios7_telephone;
    [phonepane addSubview:phoneicon];
    apply_phone = [[UITextField alloc] initWithFrame:CGRectMake(phoneicon.frame.origin.x+phoneicon.frame.size.width, 0, phonepane.frame.size.width - phoneicon.frame.size.width, phonepane.frame.size.height)];
    apply_phone.placeholder = [cf localisedString:@"Phone number"];
    [phonepane addSubview:apply_phone];
    CALayer *phonelayer= [CALayer layer];
    phonelayer.frame = CGRectMake(0, phonepane.frame.size.height, phonepane.frame.size.width, 0.5);
    phonelayer.backgroundColor = [darkg CGColor];
    [phonepane.layer addSublayer:phonelayer];
    [self.view addSubview:urlpane];

    [self.view addSubview:phonepane];
    
    UILabel *cartbtn = [[UILabel alloc] init];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    cartbtn.text = [cf localisedString:@"Apply"];
    cartbtn.textAlignment = NSTextAlignmentRight;
    cartbtn.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(apply:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
    self.navigationItem.rightBarButtonItem = menuBtn2;
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[cf.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:cf];
    
    
}
-(void)apply:(UITapGestureRecognizer *)ges{
    Config *cf = (Config *)self.config;
    NSString *phone = apply_phone.text;
    NSString *url = apply_url.text;
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&email=%@&url=%@&phone=%@", cf.APP_UUID, cf.email, url, phone ];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_APPLY]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[cf localisedString:@"Application Submitted"] message:[cf localisedString:@"Please check back later for application approval"] delegate:nil cancelButtonTitle:[cf localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                cf.affiliate.aid = [dic objectForKey:@"affiliate_id"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[cf localisedString:@"Application Failed"] message:[cf localisedString:@"All inputs are required"] delegate:nil cancelButtonTitle:[cf localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                
            }
        } else {
            //There was an error
            NSMutableData *d = (NSMutableData *)obj;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[cf localisedString:@"Application failed."] message:[cf localisedString:@"All information required"] delegate:nil cancelButtonTitle:[cf localisedString:@"Close"] otherButtonTitles: nil];
            [alert show];
           
        }
        
    };
    [connection start];
}
-(void)load_waiting_view{
    Config *cf = (Config *)self.config;
    
    UIColor *darkg = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, cf.screenWidth, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = [cf localisedString:@"Application Submitted"];
    title.textColor = darkg;
    [self.view addSubview:title];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, cf.screenWidth-60, 40)];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.numberOfLines = 2;
    subtitle.lineBreakMode = NSLineBreakByWordWrapping;
    subtitle.text=[cf localisedString:@"Waiting for review"];
    subtitle.font = [UIFont systemFontOfSize:13];
    subtitle.textColor = [UIColor lightGrayColor];
    [self.view addSubview:subtitle];
}
-(void)load_view{
    Config *cf = (Config *)self.config;

    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&affiliate_id=%@&location=%@&currency=%@", cf.APP_UUID, cf.affiliate.aid, cf.location, cf.currency];
    
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_GET_AFFILIATE_DETAIL]]];
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
            
            
            self.commission = [dic objectForKey:@"commission"];
            self.commission_desc = [dic objectForKey:@"description"];
            self.status = [[dic objectForKey:@"status"] intValue];
            self.rate =[[dic objectForKey:@"rate"] floatValue];
            self.earning = [dic objectForKey:@"earning"];
            self.total_earning = [dic objectForKey:@"total_earning"];
            self.url = [dic objectForKey:@"url"];
            self.promo_count = [[dic objectForKey:@"promotion_count"] intValue];
            self.banner_count = [[dic objectForKey:@"banner_count"] intValue];
            
            if (self.status == 1) {
                table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, cf.screenWidth, cf.screenHeight-64) style:UITableViewStyleGrouped];
                
                table.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
                table.dataSource = self;
                table.delegate = self;
                table.rowHeight = 57.3;
                
                [self.view addSubview:table];
                [table reloadData];
            } else {
                [self load_waiting_view];
            }
           
        } else {
            //There was an error
           
        }
        
    };
    [connection start];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) return 1;
    else if (section == 1) return 3;
    else if (section == 2) return 2;
    
    return 0;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) return [self.config localisedString:@"UNIQUE URL"];
    if (section == 1) return [self.config localisedString:@"AFFILIATE DETAILS"];
    if (section == 2) return [self.config localisedString:@"LINKS"];
    return @"";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    
    header.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];;
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    Config *cf = self.config;
    if (section == 0){
        UITextView *tv = [[UITextView alloc] init];
        tv.text = [self.config localisedString:@"Easily earn cash by sharing your unique url, promotion or products"];
        tv.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
        tv.backgroundColor = [UIColor clearColor];
        tv.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.3f];;
        tv.textColor = [UIColor grayColor];
        tv.editable = NO;
        tv.userInteractionEnabled = NO;
        return tv;
    } else if (section == 1) {
    
        
        
        UITextView *tv = [[UITextView alloc] init];
        tv.text = [NSString stringWithFormat:@"%@\n%@",[cf localisedString:@"*Estimated amount. Payout will be based on USD."], self.commission_desc];
        tv.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
        tv.backgroundColor = [UIColor clearColor];
        tv.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.3f];;
        tv.textColor = [UIColor grayColor];
        tv.editable = NO;
        tv.userInteractionEnabled = NO;
        return tv;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0){
        return 60;
    } else if (section == 1) {
        CGFloat fixedWidth = tableView.frame.size.width;
        UITextView *tv = [[UITextView alloc] init];
        CGSize newSize = [tv sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        return newSize.height+35;
    }
    return 0;
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Config *cf = (Config *)self.config;
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
    if (indexPath.section == 0){
        if (indexPath.row == 0){
             //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            /*UITextField *t = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, cf.screenWidth, 44)];
            t.enabled = YES;
            t.delegate = self;
            t.text = self.url;
            t.inputView = [[UIView alloc] initWithFrame:CGRectZero];
            [cell addSubview:t];*/
            UILabel *sign = [[UILabel alloc] initWithFrame:CGRectMake(cf.screenWidth-44, 0, 44, table.rowHeight)];
            sign.textAlignment = NSTextAlignmentCenter;
            sign.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
            sign.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-hand-o-left"];
            sign.textColor = [UIColor lightGrayColor];
            [cell addSubview:sign];
            cell.textLabel.text = self.url;
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0){
            cell.textLabel.text =[NSString stringWithFormat:@"%@ *",  [self.config localisedString:@"Redeemable Earnings"]];
            
            
            UILabel *sign = [[UILabel alloc] initWithFrame:CGRectMake(cf.screenWidth-44, 0, 44, table.rowHeight)];
            sign.textAlignment = NSTextAlignmentCenter;
            sign.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
            sign.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-hand-o-left"];
            sign.textColor = [UIColor lightGrayColor];
            [cell addSubview:sign];
            
            UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(cf.screenWidth-130, 0, 90, table.rowHeight)];
            balance.textAlignment = NSTextAlignmentRight;
            balance.textColor = cell.textLabel.textColor;
            balance.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            balance.text = [NSString stringWithFormat:@"%@ %0.2f",[self.config getCurrencySymbol],[self.earning floatValue]];
            [cell addSubview:balance];
        }
        if (indexPath.row == 1){
            cell.textLabel.text = [self.config localisedString:@"Total Earnings"];
            UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(cf.screenWidth-130, 0, 90, table.rowHeight)];
            balance.textAlignment = NSTextAlignmentRight;
            balance.textColor = cell.textLabel.textColor;
            balance.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            balance.text = [NSString stringWithFormat:@"%@ %0.2f",[self.config getCurrencySymbol], [self.total_earning floatValue]];
            [cell addSubview:balance];
            

        }
        if (indexPath.row == 2){
            cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [self.config localisedString:@"Commission"], self.commission];
            UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(cf.screenWidth-130, 0, 90, table.rowHeight)];
            balance.textAlignment = NSTextAlignmentRight;
            balance.textColor = cell.textLabel.textColor;
            balance.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            balance.text = [NSString stringWithFormat:@"%0.2f%%",self.rate*100];
            [cell addSubview:balance];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            cell.textLabel.text = [self.config localisedString:@"Promotions"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(cf.screenWidth-80, table.rowHeight/2-12, 40, 24)];
            balance.textAlignment = NSTextAlignmentCenter;
            balance.textColor = cell.textLabel.textColor;
            balance.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            balance.text = [NSString stringWithFormat:@"%d", self.promo_count];
            balance.layer.borderColor = [cell.textLabel.textColor CGColor];
            balance.layer.cornerRadius =12;
            balance.layer.borderWidth = 0.5;
            [cell addSubview:balance];

            
           /* JSCustomBadge *badge = [JSCustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", self.promo_count]];
            badge.tag = -11;
            //badge.badgeInsetColor = [UIColor whiteColor];
            badge.badgeFrameColor = cell.textLabel.textColor;
            badge.frame = CGRectMake(cf.screenWidth-80, table.rowHeight/2-13, 40, 26);
            
            [cell addSubview:badge];*/
        }
        if (indexPath.row == 1){
            cell.textLabel.text = [self.config localisedString:@"Banners"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(cf.screenWidth-80, table.rowHeight/2-12, 40, 24)];
            balance.textAlignment = NSTextAlignmentCenter;
            balance.textColor = cell.textLabel.textColor;
            balance.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
            balance.text = [NSString stringWithFormat:@"%d", self.banner_count];
            balance.layer.borderColor = [cell.textLabel.textColor CGColor];
            balance.layer.cornerRadius =12;
            balance.layer.borderWidth = 0.5;
            [cell addSubview:balance];
            
            
          /*  JSCustomBadge *badge = [JSCustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d", self.banner_count]];
            badge.tag = -11;
            
             badge.frame = CGRectMake(cf.screenWidth-80, 9, 40, 26);
            
            [cell addSubview:badge];*/
        }
    }
    
    
    
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Copy URL"] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Copy"],nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = 1;
        UITextField *t = [alert textFieldAtIndex:0];
        t.text = self.url;
        t.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        [alert show];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Redeem Earnings?"] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles:[self.config localisedString:@"Redeem"], nil];
        alert.tag = 2;
        [alert show];
    } else if (indexPath.section == 2 && indexPath.row == 0){
        AffiliatePromotionController *apc = [[AffiliatePromotionController alloc] init];
        apc.config = self.config;
        
        [self.navigationController pushViewController:apc animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 1){
        AffiliateBannerController *apc = [[AffiliateBannerController alloc] init];
        apc.config = self.config;
        
        [self.navigationController pushViewController:apc animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        if (buttonIndex == 1){
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            UITextField *t = [alertView textFieldAtIndex:0];
            [pb setString:[t text]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"URL Copied"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
            [alert show];
        }
    }
}

-(void)apply_redeem{
    Config *cf = (Config *)self.config;
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&affiliate_id=%@", cf.APP_UUID, cf.affiliate.aid];
    
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_REDEEM]]];
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
            
            int success = [[dic objectForKey:@"success"] intValue];
            
            if (success == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Redeeming Failed"] message:[NSString stringWithFormat:@"%@: %@ %@", [cf localisedString:@"Minimum Redeemable Balance"], [cf getCurrencySymbol], [dic objectForKey:@"minimum"]] delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Redeeming Requested"] message:[self.config localisedString:@"Please allow the merchant one to two weeks to process your request."] delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
}

@end


const NSString *AFF_GET_AFFILIATE_PROMO = @"https://www.twixxies.com/affiliateapi/app_getAffiliatePromotion";

@implementation AffiliatePromotionController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    Config *conf = (Config *)self.config;
    
    UILabel* titlelabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = [conf localisedString:@"Affiliate Promotions"];
    titlelabel.frame = CGRectMake(0, 0, 180, 44);
    [Design navigationbar_title:titlelabel config:self.config];
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[conf.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    self.navigationItem.leftBarButtonItem = barbtn;
    
    
    
    
    
    
    
    
    NSLog(@"%f", conf.screenHeight);
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, conf.screenWidth, conf.screenHeight-64)];
    scroll.backgroundColor = [UIColor colorWithRed:245/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    
    [self.view addSubview:scroll];
    
    
    
    shareview = [[BottomPopUpView alloc] initWithFrame:CGRectMake(0, conf.screenHeight+20, conf.screenWidth, 140)];
    BottomPopUpView *sv = (BottomPopUpView *)shareview;
    sv.screen = CGSizeMake(conf.screenWidth, conf.screenHeight);
    sv.backgroundColor = [UIColor clearColor];
    sv.show_frame = CGRectMake(0, conf.screenHeight-140-64, conf.screenWidth, 140);
    [shareview layout_view];
    
    ss = [[SocialShareModule alloc] initWithFrame:CGRectMake(30, 30, sv.frame.size.width-60, 80)];
    SocialShareModule *s = (SocialShareModule *)ss;
    s.parent = self;
    s.config = conf;
    [s build_share_buttons];
    [s layout_view];
    [s share_action_target:self action:@selector(share:)];
    [sv addSubview:s];
    
    [self.view addSubview:sv];
    
    
    [self load_view:0];
}

-(void)load_view:(int)start{
    
    if (start == 0){
        if (itemViews != nil) [itemViews removeAllObjects];
        else itemViews = [[NSMutableArray alloc] init];
        if (itemImages != nil) [itemImages removeAllObjects];
        else itemImages = [[NSMutableArray alloc] init];
    }
    
    Config *cf = (Config *)self.config;
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&affiliate_id=%@", cf.APP_UUID, cf.affiliate.aid];
    NSLog(@"%@", myRequestString);
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_GET_AFFILIATE_PROMO]]];
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
            
            self.promo = [dic objectForKey:@"promotions"];
            
            [self display_promo];
           
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
}

-(void)display_promo{
    int count = 0;
    //int line = 0;
    Config *cf = (Config *)self.config;
   
    CGRect last = CGRectMake(0, 0, 0, 0);
    int column = 2;
    for (int i = (int)itemViews.count ; i < self.promo.count; i++){
        NSDictionary *temp = [self.promo objectAtIndex:i];
        //line = i/2;
        
        NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
        //CGRect  frame = CGRectMake(160*(i%2)+1,(160.0 * 1.533+60)*line+44+1, 160.0f-2, 160*1.533+60-2);
        
        ViewWithData *pv = [[ViewWithData alloc] init];
        pv.tag = i;
        pv.itemID = [temp objectForKey:@"product_id"];
        [pv.layer setMasksToBounds:YES];
        pv.layer.masksToBounds = NO;
        pv.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share_item:)];
        singleTap.numberOfTapsRequired = 1;
        pv.userInteractionEnabled = YES;
        [pv addGestureRecognizer:singleTap];
        
        
        CGRect frame = pv.frame;
        frame.origin.x = cf.screenWidth/column * (i%column);
        frame.size.width = cf.screenWidth/column;
        if (i/column > 0){
            UIView *prev = [itemViews objectAtIndex:i-column];
            frame.origin.y = prev.frame.origin.y+prev.frame.size.height;
        }
        //figure out column row and col spacing
        
            float col_spacing = 4;
            float row_spacing = 4;
            float first_row = 4;
            if (i/column > 0){
                frame.origin.y += row_spacing;
            } else {
                frame.origin.y += first_row;
            }
            if (column <= 1){
                frame.origin.x += col_spacing;
                frame.size.width -= col_spacing*2;
            } else {
                if (i%column == 0){
                    frame.origin.x += col_spacing;
                    frame.size.width -= col_spacing/2+col_spacing;
                }
                if (i%column == column - 1){
                    frame.origin.x += col_spacing/2;
                    frame.size.width -= col_spacing + col_spacing/2;
                }
                if (i%column != 0 && i%column != column - 1) {
                    frame.origin.x += col_spacing/2;
                    frame.size.width -= col_spacing/2 + col_spacing/2;
                }
            }
        
        frame.size.height = frame.size.width * 1.255+60;
        
        pv.frame = frame;
        
        
        //  [vs setObject:image forKey:@"main"];
        
        
        
        
        ImageWithData *but = [[ImageWithData alloc] init];
        [but setUserInteractionEnabled:YES];
        but.contentMode = UIViewContentModeScaleAspectFit;
        but.frame = CGRectMake(2, 2, frame.size.width-4, (frame.size.width-4)*1.255);
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.hidesWhenStopped = YES;
        spinner.frame = CGRectMake(but.frame.origin.x+but.frame.size.width/2-spinner.frame.size.width/2, but.frame.origin.y+but.frame.size.height/2-spinner.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height);
        [pv addSubview:spinner];
        [spinner startAnimating];
        but.indicator = spinner;
        
        [pv addSubview:but];
        
        // [vs setObject:but forKey:@"image"];
        
        NSString *url = [[temp objectForKey:@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        but.url = [NSURL URLWithString:url];
        but.item_id = pv.itemID;
        [itemImages addObject:but];
        
        //[Config loadImageURL:url toImageView:but withCacheKey:key trim:YES];
        
        
        
        
        
      
        
        UITextView *name = [[UITextView alloc] init];
        name.frame = CGRectMake(0, but.frame.size.height, frame.size.width, 40);
        name.contentInset =UIEdgeInsetsMake(-4, 0, 0, 0);
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        name.font = [UIFont boldSystemFontOfSize:13];
        name.text = [temp objectForKey:@"name"];
        name.editable = NO;
        name.userInteractionEnabled = NO;
        [pv addSubview:name];
        // [vs setObject:exname forKey:@"name"];
        
        
        
        //frame = CGRectMake(5, image.frame.size.width*1.533+45, image.frame.size.width-10, 10);
        UILabel *exprice = [[UILabel alloc] init];
        exprice.textAlignment=NSTextAlignmentLeft;
        exprice.text = [NSString stringWithFormat:[self.config localisedString:@"Earn %0.2f%%"], [[temp objectForKey:@"rate"] floatValue]*100];
        exprice.frame = CGRectMake(5, name.frame.size.height+name.frame.origin.y, frame.size.width, 20);
        exprice.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        exprice.font = [UIFont systemFontOfSize:13];
        [pv addSubview:exprice];
        
   
        
        [scroll addSubview:pv];
        [itemViews addObject:pv];
        count++;
        if (i == self.promo.count-1) last = pv.frame;
    }
    if (count > 0){
        //[scroll setContentSize:CGSizeMake(320, (120.0 * 1.255+20)*(line+1)+49)];
        if (((160.0 * 1.255+60)*(itemViews.count/column+1)+49) <= cf.screenHeight){
            [scroll setContentSize:CGSizeMake(cf.screenWidth, cf.screenHeight)];
        } else {
            [scroll setContentSize:CGSizeMake(cf.screenWidth, last.origin.y+last.size.height)];
        }
    }
    
    [self load_image:scroll.contentOffset];
}

-(void)load_image:(CGPoint)contentOffset{
    Config *cf = (Config *)self.config;
    for (ImageWithData *v in itemImages){
        if (v.frame.origin.y <= contentOffset.y+cf.screenHeight){
            if (!v.loaded){
                [Config loadImageURL:[v.url absoluteString] toImageView:v withCacheKey:[v.url absoluteString] trim:YES sizeMultiplyer:1 completion:^{
                    [v.indicator stopAnimating];
                }];
                v.loaded = true;
            }
        }
    }
}
/*-(void)display_promo{
    order_views = [[NSMutableArray alloc] init];
    Config *cf = (Config *)self.config;
    images = [[NSMutableDictionary alloc] init];
    for (long i = 0; i < self.promo.count;i++){
        NSDictionary *or = [self.promo objectAtIndex:i];
        UIView *order = [[UIView alloc] init];
        order.userInteractionEnabled = YES;
 
        
       
        float viewheight = 120;
        ViewWithData *productView = [[ViewWithData alloc] initWithFrame:CGRectMake(0, 0, cf.screenWidth, viewheight)];
        productView.itemID = [or objectForKey:@"product_id"];
        
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, (viewheight-10)/1.533, viewheight-10)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        NSString *url = [[or objectForKey:@"image"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [Config loadImageURL:url toImageView:img withCacheKey:url trim:YES];
        [images setObject:img forKey:productView.itemID];
        [productView addSubview:img];
        
        UITextView *pname = [[UITextView alloc] initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+3, img.frame.origin.y-6, productView.frame.size.width-img.frame.origin.x-img.frame.size.width-30, viewheight/2)];
        pname.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        pname.contentInset = UIEdgeInsetsMake(-2, 0, 0, 0);
        pname.text = [or objectForKey:@"name"];
        pname.editable = NO;
        pname.userInteractionEnabled = NO;
        [productView addSubview:pname];
        
        UITextView *rate = [[UITextView alloc] initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+3, img.frame.origin.y+20, productView.frame.size.width-img.frame.origin.x-img.frame.size.width-30, viewheight/2)];
        rate.textColor = [UIColor colorWithRed:161.0/255.0 green:161.0/255.0 blue:161.0/255.0 alpha:1];
        rate.contentInset = UIEdgeInsetsMake(-2, 0, 0, 0);
        rate.text = [NSString stringWithFormat:@"Earn %@%%", [or objectForKey:@"rate"]];
        rate.editable = NO;
        rate.userInteractionEnabled = NO;
        [productView addSubview:rate];
        
        
        ButtonWithData *share = [[ButtonWithData alloc] initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+3, img.frame.origin.y+50, 40, 25)];
        share.item_id = productView.itemID;
        [share setTitleColor:[UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1] forState:UIControlStateNormal];
        [share setTitle:@"Share" forState:UIControlStateNormal];
        share.titleLabel.font = [UIFont systemFontOfSize:12];
        share.layer.borderWidth = 0.5;
        share.layer.borderColor = [UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1].CGColor;
        share.layer.cornerRadius = 5;
        [share addTarget:self action:@selector(share_item:) forControlEvents:UIControlEventTouchUpInside];
        [productView addSubview:share];
        
        
        [order addSubview:productView];
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, productView.frame.origin.y+productView.frame.size.height+3, cf.screenWidth, 0.5)];
        separater.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        [order addSubview:separater];
        
        if (i == 0){
            order.frame = CGRectMake(0, 0, cf.screenWidth, separater.frame.origin.y+separater.frame.size.height);
            
        } else {
            UIView *prev = [order_views objectAtIndex:i-1];
            order.frame = CGRectMake(0, prev.frame.origin.y+prev.frame.size.height, cf.screenWidth, separater.frame.origin.y+separater.frame.size.height);
        }
        
        
        scroll.contentSize = CGSizeMake(cf.screenWidth, order.frame.origin.y+order.frame.size.height);
        
        [order_views addObject:order];
        [scroll addSubview:order];
        
        
    }
}*/

-(IBAction)share_item:(UITapGestureRecognizer *)sender{
    
    SocialShareModule *s = (SocialShareModule *)ss;
    BottomPopUpView *sv = (BottomPopUpView *)shareview;
    
    ViewWithData *but = (ViewWithData *)sender.view;
    NSString *pid = but.itemID;
    
    NSString *name = @"";
    for (NSDictionary *d in self.promo){
        if ([[d objectForKey:@"product_id"] isEqualToString:pid]) name = [d objectForKey:@"name"];
    }
    
    
    UIImage *img = nil;
    
    for (ImageWithData *v in itemImages){
        if ([v.item_id isEqualToString:pid]){
            img = v.image;
            s.imageURL = [v.url absoluteString];
        }
    }
    
    s.item_id = pid;
    s.message = name;
    s.image = img;
    
    [sv toggle_view:YES];
    
    
    
    
    /*ViewWithData *but = (ViewWithData *)sender.view;
    NSString *pid = but.itemID;
    
    NSString *name = @"";
    for (NSDictionary *d in self.promo){
        if ([[d objectForKey:@"product_id"] isEqualToString:pid]) name = [d objectForKey:@"name"];
    }
    
    Config *cf = (Config *)self.config;
    [AffiliateModule getLink:cf.APP_UUID affiliate:cf.affiliate.aid item:pid itemType:@"product" completion:^(NSString *url, NSError *error) {
        
        UIImageView *imgview = [images objectForKey:pid];
        UIImage *img =imgview.image;
        
        NSArray *activityItems = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@, %@", name, url], img, nil];
        ;
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
            if (completed){
                // [NSThread detachNewThreadSelector:@selector(send_user_share) toTarget:self withObject:nil];
            }
        }];
        
        [self presentViewController:activityViewController animated:YES completion:nil];
        
    }];*/
    
    
}

-(IBAction)share:(id)sender{
    Config *cf = (Config *)self.config;
    BOOL ok = [SocialShareModule check_share_available_with_sender:sender withConfig:cf];
    
    if (!ok) return;
    
    
    BottomPopUpView *sv = (BottomPopUpView *)shareview;
    SocialShareModule *s = (SocialShareModule *)ss;
    [sv toggle_view:NO];
    
   
    
    NSString *aid = @"0";
    UIView *loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, cf.screenWidth, cf.screenHeight) withMessage:[cf localisedString:@"Generating Your Affiliate Link."]];
    
    [self.navigationController.view addSubview:loadingView];
    
    
    
    
    
    [AffiliateModule getLink:cf.APP_UUID affiliate:aid item:s.item_id itemType:@"product" filter:@"" completion:^(NSString *url, NSError *error) {
        
        [loadingView removeFromSuperview];
        s.url = url;
        
        [s present_sharing_dialog_with_message:s.message image:s.image imageurl:s.imageURL url:s.url action_sender:sender action_parent:self];
        
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



@end




@implementation AffiliateBannerController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    Config *conf = (Config *)self.config;
    
    UILabel* titlelabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = [conf localisedString:@"Affiliate Banners"];
    titlelabel.frame = CGRectMake(0, 0, 180, 44);
    [Design navigationbar_title:titlelabel config:self.config];
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[conf.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    self.navigationItem.leftBarButtonItem = barbtn;
    

    
    //NSLog(@"%f", conf.screenHeight);
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, conf.screenWidth, conf.screenHeight-64)];
    scroll.backgroundColor = [UIColor colorWithRed:245/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    
    [self.view addSubview:scroll];
    
    
    
    shareview = [[BottomPopUpView alloc] initWithFrame:CGRectMake(0, conf.screenHeight+20, conf.screenWidth, 140)];
    BottomPopUpView *sv = (BottomPopUpView *)shareview;
    sv.screen = CGSizeMake(conf.screenWidth, conf.screenHeight);
    sv.backgroundColor = [UIColor clearColor];
    sv.show_frame = CGRectMake(0, conf.screenHeight-140-64, conf.screenWidth, 140);
    [shareview layout_view];
    
    ss = [[SocialShareModule alloc] initWithFrame:CGRectMake(30, 30, sv.frame.size.width-60, 80)];
    SocialShareModule *s = (SocialShareModule *)ss;
    s.config = conf;
    [s build_share_buttons];
    [s layout_view];
    [s share_action_target:self action:@selector(share:)];
    [sv addSubview:s];
    
    [self.view addSubview:sv];
    
    [self load_view];
}

-(void)load_view{
    Config *cf = (Config *)self.config;
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&affiliate_id=%@", cf.APP_UUID, cf.affiliate.aid];
    NSLog(@"%@", myRequestString);
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",AFF_GET_BANNER]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request2];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            self.banners = [dic objectForKey:@"banners"];
            
            
            [self display_banner];
            
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
}


-(void)display_banner{
    order_views = [[NSMutableArray alloc] init];
    Config *cf = (Config *)self.config;
    images = [[NSMutableDictionary alloc] init];
    for (long i = 0; i < self.banners.count;i++){
        NSDictionary *or = [self.banners objectAtIndex:i];
        UIView *order = [[UIView alloc] init];
        order.userInteractionEnabled = YES;
        order.backgroundColor = [UIColor whiteColor];
        
        /*ViewWithData *header = [[ViewWithData alloc] init];
         header.itemID = [or objectForKey:@"product_id"];
         header.frame = CGRectMake(-1, 0, cf.screenWidth+1, 60);
         header.userInteractionEnabled = YES;
         header.layer.borderWidth = 0.5;
         header.layer.borderColor = [[UIColor lightGrayColor] CGColor];
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(order_sel:)];
         [header addGestureRecognizer:tap];*/
        
        
        
        float viewheight = 180;
        ViewWithData *productView = [[ViewWithData alloc] initWithFrame:CGRectMake(0, 0, cf.screenWidth-10, viewheight+22)];
        productView.itemID = [or objectForKey:@"banner_id"];
        productView.backgroundColor = [UIColor clearColor];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(cf.screenWidth/2-indicator.frame.size.width/2, (viewheight-40)/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
        [productView addSubview:indicator];
        
        
        ImageWithData *img = [[ImageWithData alloc] initWithFrame:CGRectMake(3, 3, productView.frame.size.width-6,viewheight-20)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        NSString *url = [[or objectForKey:@"image"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        img.url = [NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [Config loadImageURL:url toImageView:img withCacheKey:url trim:YES sizeMultiplyer:1 completion:^{
            [indicator stopAnimating];
        }];
        [images setObject:img forKey:productView.itemID];
        [productView addSubview:img];
        
        UITextView *pname = [[UITextView alloc] initWithFrame:CGRectMake(5, img.frame.origin.y+img.frame.size.height+5, 280, 38)];
        pname.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        pname.contentInset = UIEdgeInsetsMake(-2, 0, 0, 0);
        pname.text = [or objectForKey:@"title"];
        pname.editable = NO;
        pname.userInteractionEnabled = NO;
        pname.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];;
        [productView addSubview:pname];
        
        
        ButtonWithData *share = [[ButtonWithData alloc] initWithFrame:CGRectMake(productView.frame.size.width-65, img.frame.origin.y+img.frame.size.height+5, 60, 40)];
        share.item_id = productView.itemID;
        [share setTitleColor:[UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        [Design style:[[DOM alloc] initWithView:share parent:nil] design:[[cf.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
        [share setTitle:@"Share" forState:UIControlStateNormal];
        share.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.3f];
        
        share.layer.borderWidth = 0;
        [share addTarget:self action:@selector(share_item:) forControlEvents:UIControlEventTouchUpInside];
        [productView addSubview:share];
        
        
        [order addSubview:productView];
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, productView.frame.origin.y+productView.frame.size.height+3, cf.screenWidth, 0.5)];
       // separater.backgroundColor = [UIColor colorWithRed:196.0/255.0 green:196.0/255.0 blue:196.0/255.0 alpha:1];
        separater.backgroundColor = [UIColor clearColor];
        [order addSubview:separater];
        
        if (i == 0){
            order.frame = CGRectMake(5, 10, cf.screenWidth-10, separater.frame.origin.y+separater.frame.size.height);
            
        } else {
            UIView *prev = [order_views objectAtIndex:i-1];
            order.frame = CGRectMake(5, prev.frame.origin.y+prev.frame.size.height+10, cf.screenWidth-10, separater.frame.origin.y+separater.frame.size.height);
        }
        
        
        scroll.contentSize = CGSizeMake(cf.screenWidth, order.frame.origin.y+order.frame.size.height);
        
        [order_views addObject:order];
        [scroll addSubview:order];
        
        
    }
}

-(IBAction)share_item:(id)sender{
    
    
    SocialShareModule *s = (SocialShareModule *)ss;
    BottomPopUpView *sv = (BottomPopUpView *)shareview;
    
    ButtonWithData *but = (ButtonWithData *)sender;
    NSString *pid = but.item_id;
    
    NSString *name = @"";
    for (NSDictionary *d in self.banners){
        if ([[d objectForKey:@"banner_id"] isEqualToString:pid]) name = [d objectForKey:@"title"];
    }
    
    
    ImageWithData *imgview =  (ImageWithData *)[images objectForKey:pid];
    UIImage *img =imgview.image;
    
    s.item_id = pid;
    s.message = name;
    s.image = img;
    s.imageURL = [imgview.url absoluteString];
    [sv toggle_view:YES];
    
    
    
    
    
}

-(IBAction)share:(id)sender{
    Config *cf = (Config *)self.config;
    BOOL ok = [SocialShareModule check_share_available_with_sender:sender withConfig:cf];
    
    if (!ok) return;
    
    
    BottomPopUpView *sv = (BottomPopUpView *)shareview;
    SocialShareModule *s = (SocialShareModule *)ss;
    [sv toggle_view:NO];
    
    
    
    
    UIView *loadingView = [AffiliateModule getLoadingScreen:CGRectMake(0, 0, cf.screenWidth, cf.screenHeight) withMessage:[cf localisedString:@"Generating Your Affiliate Link."]];;
    
    [self.navigationController.view addSubview:loadingView];
    
    
    [AffiliateModule getLink:cf.APP_UUID affiliate:cf.affiliate.aid item:@"0" itemType:@"banner" filter:@"" completion:^(NSString *url, NSError *error) {
        
        [loadingView removeFromSuperview];
        s.url = url;
        
        [s present_sharing_dialog_with_message:s.message image:s.image imageurl:s.imageURL url:s.url action_sender:sender action_parent:self];
        
    }];

    
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



@end