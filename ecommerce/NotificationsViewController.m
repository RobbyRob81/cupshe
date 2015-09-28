//
//  NotificationsViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/21/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "NotificationsViewController.h"
#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "NSURLConnectionBlock.h"
#import "ViewWithData.h"
@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [self.config localisedString: @"Notifications"];
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
    
    
    
    
    
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    
    
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    // menubtn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22.f];
    // menubtn.text =[NSString fontAwesomeIconStringForIconIdentifier:@"fa-bars"];
    
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    
    
    self.navigationItem.leftBarButtonItem = barbtn;
    
    
    
    loading = 0;
    hasmore = 1;
    notifications = [[NSMutableArray alloc] init];
    views = [[NSMutableArray alloc] init];
    
    
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    scroll.delegate = self;
    scroll.bounces = YES;
    scroll.backgroundColor = [UIColor colorWithRed:245/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    [self.view addSubview:scroll];
    
    
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, -55, self.config.screenWidth, 50)];
    loadingView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, loadingView.frame.size.height, loadingView.frame.size.width, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:196.0/255.0 green:196.0/255.0  blue:196.0/255.0  alpha:1] CGColor];
    [loadingView.layer addSublayer:layer];
    
    UILabel *loadinglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loadingView.frame.size.width, loadingView.frame.size.height)];
    loadinglabel.text = [self.config localisedString:@"Loading More..."];
    loadinglabel.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    loadinglabel.textAlignment = NSTextAlignmentCenter;
    loadinglabel.font = [UIFont systemFontOfSize:13];
    [loadingView addSubview:loadinglabel];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    indicator.frame = CGRectMake(self.config.screenWidth/2+55, loadingView.frame.size.height/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    [loadingView addSubview:indicator];
    [self.view addSubview:loadingView];

    
    
    [self load_notifications:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLoadingView:(BOOL)show{
    if (show){
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = loadingView.frame;
                             frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
                             loadingView.frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
    } else {
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             CGRect frame = loadingView.frame;
                             frame = CGRectMake(0, -55, frame.size.width, frame.size.height);
                             loadingView.frame = frame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    
}

-(void)load_notifications:(int)start{
    if (loading == 1) return;
    if (start == 0){
        [notifications removeAllObjects];
        for (int i = 0; i < views.count; i++){
            UIView *v = [views objectAtIndex:i];
            [v removeFromSuperview];
            v = nil;
        }
        [views removeAllObjects];
    } else {
        if (hasmore == 0) return;
    }
    [self showLoadingView:YES];
    loading = 1;
    
    NSString *uid = self.config.user_id;
    if (self.config.user_id == nil) uid = @"0";
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&user_id=%@&token=%@&start=%d", self.config.APP_UUID, uid, self.config.token, start];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_PUSH_NOTIFICATION]]];
    
    NSLog(@"%@", myRequestString);
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@", response);
            [self showLoadingView:NO];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (dic != nil){
                NSArray *not = [dic objectForKey:@"notifications"];
                for (NSDictionary *d in not){
                    TwixxiesNotification *tn = [[TwixxiesNotification alloc] init];
                    tn.not_id = [d objectForKey:@"notification_id"];
                    tn.message = [d objectForKey:@"message"];
                    tn.timestamp = [d objectForKey:@"time_stamp"];
                    tn.to_user_id = [d objectForKey:@"to_user"];
                    
                    [notifications addObject:tn];
                }
            }
            
            if (notifications.count > 0){
                TwixxiesNotification *tn = [notifications objectAtIndex:0];
                if (tn.timestamp != nil){
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:tn.timestamp forKey:@"last_push_time_stamp"];
                    [defaults synchronize];
                }
            }
            [self build_view];
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        loading = 0;
    };
    [connection start];
}

-(void)build_view{
    for (long i = views.count; i < notifications.count;i++){
        
        TwixxiesNotification *tn = [notifications objectAtIndex:i];
        
        CGRect frame;
        if (i == 0){
            frame = CGRectMake(5, 5, self.config.screenWidth-10, 0);
        } else {
            UIView *prev = [views objectAtIndex:(i-1)];
            frame = CGRectMake(5, prev.frame.size.height+prev.frame.origin.y+5, self.config.screenWidth-10, 0);
        }
        
        ViewWithData *pv = [[ViewWithData alloc] init];
        pv.backgroundColor = [UIColor whiteColor];
        pv.itemID = tn.not_id;
        
        
        UITextView *response = [[UITextView alloc] init];
        response.editable = NO;
        response.frame = CGRectMake(10, 10, frame.size.width-20, 0);
        response.contentInset = UIEdgeInsetsMake(0,-5, 0, 0);
        response.text =  tn.message;
        response.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
        response.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39./255.0 alpha:1];
        CGSize size = [response sizeThatFits:CGSizeMake(response.frame.size.width, FLT_MAX)];
        CGRect textframe = response.frame;
        textframe.size.height = size.height+8;
        response.frame = textframe;
        [pv addSubview:response];
        
        
        
        
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        // Set the date format according to your needs
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //for 12 hour format
        //[df setDateFormat:@"MM/dd/YYYY HH:mm "]  // for 24 hour format
        NSDate *date1 = [df dateFromString:tn.timestamp];
        NSDate *date2 = [NSDate date];
        
    
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;;
        
        NSDateComponents* fromcomponents = [gregorian components:unitFlags fromDate:date1];
        NSDateComponents* tocomponents = [gregorian components:unitFlags fromDate:date2];
        
        NSDate* from = [gregorian dateFromComponents:fromcomponents];
        NSDate *to = [gregorian dateFromComponents:tocomponents];
        
        
        
        
        NSDateComponents *components = [gregorian components:unitFlags
                                                    fromDate:from
                                                      toDate:to options:0];
        NSInteger month= [components month];
        NSInteger day = [components day];
        //NSInteger year = [components year];
        
        NSString *date = [self.config localisedString:@"Today"];
        //if (year > 0) date = [NSString stringWithFormat:@"%@", [self.config localisedString:@"Last Year"]];
        if (month >1) date = [NSString stringWithFormat:@"%ld %@", month, [self.config localisedString:@"Months Ago"]];
        if (month == 1)  date = [NSString stringWithFormat:@"%ld %@", month, [self.config localisedString:@"Month ago"]];
        if (day >1) date = [NSString stringWithFormat:@"%ld %@", day, [self.config localisedString:@"Days Ago"]];
        if (day == 1)  date = [NSString stringWithFormat:@"%@", [self.config localisedString:@"Yesterday"]];
        
        
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, response.frame.origin.y+response.frame.size.height+10, frame.size.width, 20)];
        timelabel.textColor = [UIColor lightGrayColor];
        timelabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
        timelabel.textColor = [UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:1];
        timelabel.text = date;
        [pv addSubview:timelabel];
        
       
        
        frame.size.height = timelabel.frame.origin.y+timelabel.frame.size.height+12;
        
        pv.frame = frame;
        
       /* CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, pv.frame.size.height-0.5, pv.frame.size.width, 0.5);
        layer.backgroundColor = [[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1] CGColor];
        //pv.bottom_border = layer;
        [pv.layer addSublayer:layer];*/
        
        [scroll addSubview:pv];
        [views addObject:pv];
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, pv.frame.origin.y+pv.frame.size.height)];
        if (scroll.contentSize.height < self.config.screenHeight-64) {
            [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight-64+1)];
        }
    }
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (loading == 1) return;
    if (hasmore == 0) return;
    if (scrollView.contentOffset.y + 300 >= scrollView.contentSize.height){
        [self load_notifications:(int)notifications.count];
    }
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation  TwixxiesNotification : NSObject


@end