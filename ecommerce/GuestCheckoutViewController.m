//
//  GuestCheckoutViewController.m
//  Ecommerce
//
//  Created by Han Hu on 8/18/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "GuestCheckoutViewController.h"
#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "NSURLConnectionBlock.h"
#import "LoginViewController.h"

@interface GuestCheckoutViewController ()

@end

@implementation GuestCheckoutViewController

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
    label.text = [self.config localisedString:[self.config localisedString:@"Checkout Method"]];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
   

    
    
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
    
    
    UIView *new_title = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, self.config.screenWidth+2, 64)];
    new_title.backgroundColor = [UIColor colorWithRed:245/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, new_title.frame.size.height-0.5, new_title.frame.size.width, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
    [new_title.layer addSublayer:layer];
    
    UILabel *new_title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, new_title.frame.size.width, new_title.frame.size.height)];
    new_title_label.text = [self.config localisedString:@"New Customer"];
    new_title_label.textAlignment = NSTextAlignmentCenter;
    [new_title addSubview:new_title_label];
    
    [self.view addSubview:new_title];
    
    
    UIView *emailview = [[UIView alloc] initWithFrame:CGRectMake(8, new_title.frame.origin.y+new_title.frame.size.height+12, self.config.screenWidth-16, 50)];
    emailview.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
    emailview.layer.borderWidth = 0.5;
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, emailview.frame.size.width-15, emailview.frame.size.height)];
    email.placeholder = [self.config localisedString:@"Email"];
    email.delegate = self;
    email.text = self.config.temp_email;
    
    [emailview addSubview:email];
    [self.view addSubview:emailview];
    
    
    UIView *cont_view = [[UIView alloc] initWithFrame:CGRectMake(8, emailview.frame.origin.y+emailview.frame.size.height+12, self.config.screenWidth-16, 50 )];
    cont_view.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
    cont_view.layer.borderWidth = 0.5;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, cont_view.frame.size.width, cont_view.frame.size.height)];
    [btn setTitle:[self.config localisedString:@"Continue Guest Checkout"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(continue_guest) forControlEvents:UIControlEventTouchUpInside];
    [cont_view addSubview:btn];
    
    NSString *dstr = [[[[self.config.design objectForKey:@"components"] objectForKey:@"filter_page"] objectForKey:@"style"] objectForKey:@"apply-background"];
    [Design style:[[DOM alloc] initWithView:cont_view parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:dstr] config:self.config];
    [self.view addSubview:cont_view];
    
    
    UIView *exist_view = [[UIView alloc] initWithFrame:CGRectMake(8, cont_view.frame.origin.y+cont_view.frame.size.height+12, self.config.screenWidth-16, 50 )];
    exist_view.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
    exist_view.layer.borderWidth = 0.5;
    
    UIButton *exist_btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, exist_view.frame.size.width, exist_view.frame.size.height)];
    [exist_btn setTitle:[self.config localisedString:@"Existing Customer"] forState:UIControlStateNormal];
    [exist_btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [exist_btn addTarget:self action:@selector(continue_exist) forControlEvents:UIControlEventTouchUpInside];
    [exist_view addSubview:exist_btn];
    
    [self.view addSubview:exist_view];
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(self.config.screenWidth/2-indicator.frame.size.width/2, self.config.screenHeight/2-indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [email resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [email resignFirstResponder];
    return YES;
}

-(void)continue_guest{
    if (email.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Email is required"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (self.config.temp_user_id != nil){
        [self.navigationController pushViewController:self.next animated:YES];
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self withObject:nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.config.cache.cart
                                                       options:0
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&device_token=%@&location=%@&currency=%@&email=%@", self.config.APP_UUID, self.config.device_token, self.config.location, self.config.currency, email.text];
    
    NSLog(@"%@", myRequestString);
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GUEST_LOG_IN]]];
    
    
    
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
            NSLog(@"%@",response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            
            if ([[dic objectForKey:@"success"] intValue] == 1){
                self.config.temp_user_id = [dic objectForKey:@"temp_user_id"];
                self.config.temp_email = email.text;
                [self.navigationController pushViewController:self.next animated:YES];
            } else {
                if ([[dic objectForKey:@"error"] intValue] == 1){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"There is already an account associate with this email. Please log in."] message:nil delegate:self cancelButtonTitle:[self.config localisedString:@"Close"]otherButtonTitles:[self.config localisedString:@"Log In"], nil];
                    [alert show];
                }
            }
            
           
            
            [indicator stopAnimating];
            
        } else {
            //There was an error
            
        }
        
    };
    [connection start];
    
    
    
}
-(void)continue_exist{
    LoginViewController *lg = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    lg.config = self.config;
    lg.passView = self.next;
    lg.nav = self.navigationController;
    [self presentViewController:lg animated:YES completion:nil];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        LoginViewController *lg = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lg.config = self.config;
        lg.passView = self.next;
        lg.nav = self.navigationController;
        [self presentViewController:lg animated:YES completion:nil];
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

-(void)startAnimating{
    [indicator startAnimating];
}
@end
