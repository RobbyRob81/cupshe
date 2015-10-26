//
//  LoginViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "LoginViewController.h"
#import "NSURLConnectionWithTag.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "NSString+FontAwesome.h"
#import "Design.h"
#import "DOM.h"
#import "Branch.h"
#import "PKRevealController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
const int LOGIN = 0;
const int SIGNUP = 1;
const int FORGET = 2;
const int FBLOGIN = 3;
@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    receivedData = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < 10; i++){
        [receivedData addObject:[[NSMutableData alloc] init]];
    }
    
    NSDictionary *designs = [self.config.design objectForKey:@"design"];
    
    
    CGRect frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight);
    loginView = [[UIView alloc] init];
    loginView.frame = frame;
    signupView = [[UIView alloc] init];
    signupView.frame = frame;
    signupView.hidden = YES;
    [self.view addSubview:loginView];
    [self.view addSubview:signupView];
    
    
    loginClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 60)];
    loginClose.titleLabel.font = [IonIcons fontWithSize:28];
    [loginClose setTitle:icon_ios7_close forState:UIControlStateNormal];
    [loginClose setTitleColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] forState:UIControlStateNormal];
    [loginClose addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginClose];
    
    
    NSMutableDictionary *nonfill = [designs objectForKey:@"login_nonfill_button"];
    switchToSignup = [[UIButton alloc] initWithFrame:CGRectMake(self.config.screenWidth-100, 20, 100, 60)];
    [switchToSignup addTarget:self action:@selector(seg_pressed:) forControlEvents:UIControlEventTouchUpInside];
    [switchToSignup setTitle:[self.config localisedString:@"SIGN UP"] forState:UIControlStateNormal];
    [Design style:[[DOM alloc] initWithView:switchToSignup parent:nil] design:nonfill config:self.config];
    [loginView addSubview:switchToSignup];
    
    UILabel *loginTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.config.screenWidth, 40)];
    loginTitle.text =[self.config localisedString:@"LOG IN"];
    loginTitle.font = [UIFont systemFontOfSize:20];
    loginTitle.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    loginTitle.textAlignment = NSTextAlignmentCenter;
    [loginView addSubview:loginTitle];
    
    UIView *loginEmailPane = [[UIView alloc] initWithFrame:CGRectMake(10, loginTitle.frame.origin.y+loginTitle.frame.size.height+30, self.config.screenWidth-20, 51)];
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    layer.frame=CGRectMake(0, loginEmailPane.frame.size.height, loginEmailPane.frame.size.width, 0.5);
    [loginEmailPane.layer addSublayer:layer];
    [loginView addSubview:loginEmailPane];
    
    UILabel *loginEmailIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loginEmailPane.frame.size.height, loginEmailPane.frame.size.height)];
    loginEmailIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22];
    loginEmailIcon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope"];
    loginEmailIcon.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    loginEmailIcon.textAlignment = NSTextAlignmentCenter;
    [loginEmailPane addSubview:loginEmailIcon];
    
    loginEmail = [[UITextField alloc] initWithFrame:CGRectMake(loginEmailIcon.frame.size.width+5, 0, loginEmailPane.frame.size.width-loginEmailIcon.frame.size.width, loginEmailPane.frame.size.height)];
    loginEmail.placeholder = [self.config localisedString:@"Email"];
    loginEmail.layer.borderWidth = 0;
    loginEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    loginEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    loginEmail.delegate = self;
    [loginEmailPane addSubview:loginEmail];
    
    
    
    UIView *loginPassPane = [[UIView alloc] initWithFrame:CGRectMake(10, loginEmailPane.frame.origin.y+loginEmailPane.frame.size.height+10, self.config.screenWidth-20, 51)];
    CALayer *layer2 = [CALayer layer];
    layer2.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    layer2.frame=CGRectMake(0, loginPassPane.frame.size.height, loginPassPane.frame.size.width, 0.5);
    [loginPassPane.layer addSublayer:layer2];
    [loginView addSubview:loginPassPane];
    
    UILabel *loginpassIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, loginPassPane.frame.size.height, loginPassPane.frame.size.height)];
    loginpassIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:24];
    loginpassIcon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-lock"];
    loginpassIcon.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    loginpassIcon.textAlignment = NSTextAlignmentCenter;
    [loginPassPane addSubview:loginpassIcon];
    
    loginPass = [[UITextField alloc] initWithFrame:CGRectMake(loginpassIcon.frame.size.width+5, 0, loginPassPane.frame.size.width-loginpassIcon.frame.size.width, loginPassPane.frame.size.height)];
    loginPass.placeholder = [self.config localisedString:@"Password"];
    loginPass.layer.borderWidth = 0;
    loginPass.secureTextEntry = YES;
    loginPass.autocorrectionType = UITextAutocorrectionTypeNo;
    loginPass.autocapitalizationType = UITextAutocapitalizationTypeNone;
    loginPass.delegate = self;
    [loginPassPane addSubview:loginPass];
    
    UIButton *forgetPass = [[UIButton alloc] initWithFrame:CGRectMake(10, loginPassPane.frame.origin.y+loginPassPane.frame.size.height+5, 150, 30)];
    [forgetPass setTitleColor:switchToSignup.titleLabel.textColor forState:UIControlStateNormal];
    [forgetPass setTitle:[self.config localisedString:@"Forget Password"] forState:UIControlStateNormal];
    [forgetPass addTarget:self action:@selector(forgetPass:) forControlEvents:UIControlEventTouchUpInside];
    forgetPass.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    forgetPass.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.3f];
    [loginView addSubview:forgetPass];
    
    indicatorlogin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorlogin.frame = CGRectMake(self.config.screenWidth/2-indicatorlogin.frame.size.width/2, loginPassPane.frame.origin.y+loginPassPane.frame.size.height+20, indicatorlogin.frame.size.width, indicatorlogin.frame.size.height);
    [loginView addSubview:indicatorlogin];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, loginPassPane.frame.origin.y+loginPassPane.frame.size.height+70, self.config.screenWidth-20, 51.3)];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.3];
    [loginBtn setTitle:[self.config localisedString:@"Log In"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *dr = [designs objectForKey:@"login_fill_button"];
    [Design style:[[DOM alloc] initWithView:loginBtn parent:nil] design:dr config:self.config];
    [loginView addSubview:loginBtn];
    
    
    @try {
        if (self.config.use_facebook_login){
            UIButton *fbLoginButton=[[UIButton alloc] initWithFrame:CGRectMake(10, loginBtn.frame.origin.y+loginBtn.frame.size.height+10, self.config.screenWidth-20, 51.3)];
            fbLoginButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
            
            UILabel *fbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fbLoginButton.frame.size.width, fbLoginButton.frame.size.height)];
            fbtitle.font = [UIFont boldSystemFontOfSize:17.3];
            fbtitle.textColor = [UIColor whiteColor];
            fbtitle.textAlignment = NSTextAlignmentCenter;
            fbtitle.text = [self.config localisedString:@"Connect with Facebook"];
            [fbLoginButton addSubview:fbtitle];
            
            UILabel *fbicon = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, fbLoginButton.frame.size.height, fbLoginButton.frame.size.height-1)];
            fbicon.backgroundColor = [UIColor colorWithRed:0/255.0 green:111/255.0 blue:232/255.0 alpha:1];
            fbicon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
            fbicon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook"];
            fbicon.textColor = [UIColor whiteColor];
            fbicon.textAlignment = NSTextAlignmentCenter;
            [fbLoginButton addSubview:fbicon];
            // Handle clicks on the button
            [fbLoginButton
             addTarget:self
             action:@selector(fblogin) forControlEvents:UIControlEventTouchUpInside];
            
            // Add the button to the view
            [loginView addSubview:fbLoginButton];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    
    
    
    signupClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60, 60)];
    signupClose.titleLabel.font = [IonIcons fontWithSize:28];
    [signupClose setTitle:icon_ios7_close forState:UIControlStateNormal];
    [signupClose setTitleColor:[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] forState:UIControlStateNormal];
    [signupClose addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [signupView addSubview:signupClose];
    
    
    //NSMutableDictionary *nonfill = [designs objectForKey:@"login_nonfill_button"];
    switchToLogin = [[UIButton alloc] initWithFrame:CGRectMake(self.config.screenWidth-100, 20, 100, 60)];
    [switchToLogin addTarget:self action:@selector(seg_pressed:) forControlEvents:UIControlEventTouchUpInside];
    [switchToLogin setTitle:[self.config localisedString:@"LOG IN"] forState:UIControlStateNormal];
    [Design style:[[DOM alloc] initWithView:switchToLogin parent:nil] design:nonfill config:self.config];
    [signupView addSubview:switchToLogin];
    
    UILabel *signupTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.config.screenWidth, 40)];
    signupTitle.text =[self.config localisedString:@"CREATE ACCOUNT"];
    signupTitle.font = [UIFont systemFontOfSize:20];
    signupTitle.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    signupTitle.textAlignment = NSTextAlignmentCenter;
    [signupView addSubview:signupTitle];
    
    UIView *signupEmailPane = [[UIView alloc] initWithFrame:CGRectMake(10, signupTitle.frame.origin.y+signupTitle.frame.size.height+30, self.config.screenWidth-20, 51)];
    CALayer *layer3 = [CALayer layer];
    layer3.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    layer3.frame=CGRectMake(0, signupEmailPane.frame.size.height, signupEmailPane.frame.size.width, 0.5);
    [signupEmailPane.layer addSublayer:layer3];
    [signupView addSubview:signupEmailPane];
    
    UILabel *signupEmailIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, signupEmailPane.frame.size.height, signupEmailPane.frame.size.height)];
    signupEmailIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:22];
    signupEmailIcon.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    signupEmailIcon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-envelope"];
    signupEmailIcon.textAlignment = NSTextAlignmentCenter;
    [signupEmailPane addSubview:signupEmailIcon];
    
    signupEmail = [[UITextField alloc] initWithFrame:CGRectMake(signupEmailIcon.frame.size.width+5, 0, signupEmailPane.frame.size.width-signupEmailIcon.frame.size.width, signupEmailPane.frame.size.height)];
    signupEmail.placeholder = [self.config localisedString:@"Email"];
    signupEmail.layer.borderWidth = 0;
    signupEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    signupEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    signupEmail.delegate = self;
    [signupEmailPane addSubview:signupEmail];
    
    
    
    UIView *signupPassPane = [[UIView alloc] initWithFrame:CGRectMake(10, signupEmailPane.frame.origin.y+signupEmailPane.frame.size.height+10, self.config.screenWidth-20, 51)];
    CALayer *layer4 = [CALayer layer];
    layer4.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    layer4.frame=CGRectMake(0, loginPassPane.frame.size.height, loginPassPane.frame.size.width, 0.5);
    [signupPassPane.layer addSublayer:layer4];
    [signupView addSubview:signupPassPane];
    
    UILabel *signupPassIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, signupPassPane.frame.size.height, signupPassPane.frame.size.height)];
    signupPassIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    signupPassIcon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-lock"];
    signupPassIcon.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:30.0/255.0 alpha:1];
    signupPassIcon.textAlignment = NSTextAlignmentCenter;
    [signupPassPane addSubview:signupPassIcon];
    
    signupPass = [[UITextField alloc] initWithFrame:CGRectMake(signupPassIcon.frame.size.width+5, 0, signupPassPane.frame.size.width-signupPassIcon.frame.size.width, signupPassPane.frame.size.height)];
    signupPass.placeholder = [self.config localisedString:@"Password"];
    signupPass.layer.borderWidth = 0;
    signupPass.secureTextEntry = YES;
    signupPass.autocorrectionType = UITextAutocorrectionTypeNo;
    signupPass.autocapitalizationType = UITextAutocapitalizationTypeNone;
    signupPass.delegate = self;
    [signupPassPane addSubview:signupPass];
    
    
    indicatorsignup = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorsignup.frame = CGRectMake(self.config.screenWidth/2-indicatorsignup.frame.size.width/2, signupPassPane.frame.origin.y+signupPassPane.frame.size.height+20, indicatorsignup.frame.size.width, indicatorsignup.frame.size.height);
    [signupView addSubview:indicatorsignup];

    
    UIButton *signupBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, signupPassPane.frame.origin.y+signupPassPane.frame.size.height+70, self.config.screenWidth-20, 51.3)];
    signupBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.3];
    [signupBtn setTitle:[self.config localisedString:@"Sign Up"] forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
   // NSMutableDictionary *dr = [designs objectForKey:@"login_fill_button"];
    [Design style:[[DOM alloc] initWithView:signupBtn parent:nil] design:dr config:self.config];
    [signupView addSubview:signupBtn];
    
    
    @try {
        if (self.config.use_facebook_login){
            UIButton *fbSignupButton=[[UIButton alloc] initWithFrame:CGRectMake(10, signupBtn.frame.origin.y+signupBtn.frame.size.height+10, self.config.screenWidth-20, 51.3)];
            fbSignupButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
            
           
            
            UILabel *fbtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fbSignupButton.frame.size.width, fbSignupButton.frame.size.height)];
            fbtitle.font = [UIFont boldSystemFontOfSize:17.3];
            fbtitle.textColor = [UIColor whiteColor];
            fbtitle.textAlignment = NSTextAlignmentCenter;
            fbtitle.text = [self.config localisedString:@"Connect with Facebook"];
            [fbSignupButton addSubview:fbtitle];
            
            UILabel *fbicon = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, fbSignupButton.frame.size.height, fbSignupButton.frame.size.height-1)];
            fbicon.backgroundColor = [UIColor colorWithRed:0/255.0 green:111/255.0 blue:232/255.0 alpha:1];
            fbicon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:25];
            fbicon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook"];
            fbicon.textColor = [UIColor whiteColor];
            fbicon.textAlignment = NSTextAlignmentCenter;
            [fbSignupButton addSubview:fbicon];
            
            
            // Handle clicks on the button
            [fbSignupButton
             addTarget:self
             action:@selector(fblogin) forControlEvents:UIControlEventTouchUpInside];
            
            // Add the button to the view
            [signupView addSubview:fbSignupButton];
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    
    
    
    
    
    
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

-(IBAction)seg_pressed:(id)sender{
    [loginEmail resignFirstResponder];
    [loginPass resignFirstResponder];
    [signupEmail resignFirstResponder];
    [signupPass resignFirstResponder];
    [UIView transitionWithView:self.view
                      duration:0.7
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        /* any other animation you want */
                    } completion:^(BOOL finished) {
                        /* hide/show the required cells*/
                    }];
    if (sender == switchToSignup){
        loginView.hidden = YES;
        signupView.hidden = NO;
        [signupEmail becomeFirstResponder];
    } else {
        loginView.hidden = NO;
        signupView.hidden = YES;
        [loginEmail becomeFirstResponder];
    }
}

-(IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)login:(id)sender{
    if (loginEmail.text.length == 0 || loginPass.text.length == 0) return;
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    NSString *myRequestString = [NSString stringWithFormat:@"email=%@&password=%@&token=0&push_token=%@&app_uuid=%@&cached_data=%@", loginEmail.text, loginPass.text, self.config.push_token, self.config.APP_UUID, [self.config.cache to_json]];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_LOG_IN]]];
    
    NSLog(@"%@", myRequestString);
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    // NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",response);
    
    NSMutableData *received = [receivedData objectAtIndex:LOGIN];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:LOGIN];
}

-(IBAction)signup:(id)sender{
    if (signupEmail.text.length == 0 || signupPass.text.length == 0) return;
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    
    NSString *myRequestString = [NSString stringWithFormat:@"email=%@&password=%@&device_token=%@&push_token=%@&app_uuid=%@&cached_data=%@", signupEmail.text, signupPass.text, self.config.device_token, self.config.push_token, self.config.APP_UUID, [self.config.cache to_json]];
    
    NSLog(@"%@", myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SIGN_UP]]];
    
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    // NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",response);
    
    NSMutableData *received = [receivedData objectAtIndex:SIGNUP];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:SIGNUP];
}


-(IBAction)forgetPass:(id)sender{
    if (loginEmail.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Please type in your registered email."] message:[self.config localisedString:@"A temporary password will be sent to your email."] delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    
    NSString *myRequestString = [NSString stringWithFormat:@"email=%@&app_uuid=%@", loginEmail.text, self.config.APP_UUID];
    
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_FORGET_PW]]];
    
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    // NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    // NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",response);
    
    NSMutableData *received = [receivedData objectAtIndex:FORGET];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:FORGET];
}

/*- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    NSLog(@"%@", [user objectForKey:@"email"]);
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    NSString *myRequestString = [NSString stringWithFormat:@"email=%@&device_token=%@&push_token=%@&app_uuid=%@&cached_data=%@", [user objectForKey:@"email"], self.config.device_token, self.config.push_token, self.config.APP_UUID, [self.config.cache to_json]];
    
    NSLog(@"%@", myRequestString);
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SOCIAL_SIGN_UP]]];
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    
    NSMutableData *received = [receivedData objectAtIndex:SIGNUP];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:FBLOGIN];
}*/

-(void)fblogin{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    /*[login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             [self getFacebookProfileInfos:result];
         } else {
             [self getFacebookProfileInfos:result];
         }
     }];*/
    [login logInWithReadPermissions:@[@"public_profile", @"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Process error");
        } else if (result.isCancelled) {
            [self getFacebookProfileInfos:result];
        } else {
            [self getFacebookProfileInfos:result];
        }
    }];
}

-(void)getFacebookProfileInfos:(FBSDKLoginManagerLoginResult *)result{
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
         {
             if (!error)
             {
                 
                 
                 NSDictionary *dict = (NSDictionary *)result;
                 
                 
                 [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
                 NSString *myRequestString = [NSString stringWithFormat:@"email=%@&device_token=%@&push_token=%@&app_uuid=%@&cached_data=%@", [dict objectForKey:@"email"], self.config.device_token, self.config.push_token, self.config.APP_UUID, [self.config.cache to_json]];
                 
                 NSLog(@"%@", myRequestString);
                 
                 // Create Data from request
                 NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
                 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_SOCIAL_SIGN_UP]]];
                 
                 // set Request Type
                 [request setHTTPMethod: @"POST"];
                 // Set content-type
                 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
                 // Set Request Body
                 [request setHTTPBody: myRequestData];
                 
                 
                 NSMutableData *received = [receivedData objectAtIndex:SIGNUP];
                 [received setLength:0];
                 NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:FBLOGIN];
                 
                 
             }
         }];
    }
}
/*
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = [self.config localisedString:@"Facebook Error"];
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = [self.config localisedString:@"Session Error"];
        alertMessage = [self.config localisedString:@"Your current session is no longer valid. Please log in again."];
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = [self.config localisedString:@"Cannot connect to Facebook"];
        alertMessage = @"";
        
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:[self.config localisedString:@"Close"]
                          otherButtonTitles:nil] show];
    }
}
*/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        NSMutableData *received = [receivedData objectAtIndex:conn.tag];
        [received appendData:data];
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Something went wrong..."] message:[self.config localisedString:@"Please try again"] delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:nil];
        
        [alert show];
        
        // [indicator stopAnimating];
        [indicatorsignup stopAnimating];
        [indicatorlogin stopAnimating];
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //[indicator stopAnimating];
    //loading = 0;
    [indicatorsignup stopAnimating];
    [indicatorlogin stopAnimating];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == LOGIN ){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            if ([[dic objectForKey:@"success"] intValue] == 1){
                [self.config user_info_from_dictionary:dic];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [[Branch getInstance] setIdentity:[NSString stringWithFormat:@"%@:%@", self.config.email, self.config.APP_UUID]];
                
                if (self.config.affiliate != nil && self.config.affiliate.hasAffiliate == 1){
                    [AffiliateModule getAffiliateID:self.config.APP_UUID email:self.config.email completion:^(NSString *aid, NSError *error) {
                        self.config.affiliate.aid = aid;
                    }];
                }
                [self.config change_active_app];
                [self.config save_default];
                [self.config.cache clear];
                self.config.cartnum = 0;
                if (self.passView == nil) return;
                if ([self.nav isKindOfClass:[PKRevealController class]]){
                    
                    PKRevealController *pk = (PKRevealController *)self.nav;
                    [pk setFrontViewController:self.passView];
                    [pk showViewController:self.passView];
                    
                } else {
                    UINavigationController *n = (UINavigationController *)self.nav;
                    [n pushViewController:self.passView animated:YES];
                }
                
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid Email or Password"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            
            NSLog(@"%@", self.config.email);
            
            
            
        }
        else if (conn.tag == SIGNUP){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            
            if ([[dic objectForKey:@"success"] intValue] == 1){
                [self.config user_info_from_dictionary:dic];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[Branch getInstance] setIdentity:[NSString stringWithFormat:@"%@:%@", self.config.email, self.config.APP_UUID]];
                if (self.config.affiliate != nil && self.config.affiliate.hasAffiliate == 1){
                    [AffiliateModule getAffiliateID:self.config.APP_UUID email:self.config.email completion:^(NSString *aid, NSError *error) {
                        self.config.affiliate.aid = aid;
                    }];
                }
                [self.config change_active_app];
                [self.config.cache clear];
                [self.config save_default];
                self.config.cartnum = 0;
                if (self.passView == nil) return;
                
                if ([self.nav isKindOfClass:[PKRevealController class]]){
                    
                    PKRevealController *pk = (PKRevealController *)self.nav;
                    [pk setFrontViewController:self.passView];
                    [pk showViewController:self.passView];
                    
                } else {
                    UINavigationController *n = (UINavigationController *)self.nav;
                    [n pushViewController:self.passView animated:YES];
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Sign up failed"] message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            NSLog(@"%@", self.config.email);
            
            
        } else if (conn.tag == FBLOGIN ){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            if ([[dic objectForKey:@"success"] intValue] == 1){
                [self.config user_info_from_dictionary:dic];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[Branch getInstance] setIdentity:[NSString stringWithFormat:@"%@:%@", self.config.email, self.config.APP_UUID]];
                
                if (self.config.affiliate != nil && self.config.affiliate.hasAffiliate == 1){
                    [AffiliateModule getAffiliateID:self.config.APP_UUID email:self.config.email completion:^(NSString *aid, NSError *error) {
                        self.config.affiliate.aid = aid;
                    }];
                }
                [self.config change_active_app];
                [self.config.cache clear];
                
                self.config.cartnum = 0;
                if (self.passView == nil) return;
                if ([self.nav isKindOfClass:[PKRevealController class]]){
                    
                    PKRevealController *pk = (PKRevealController *)self.nav;
                    [pk setFrontViewController:self.passView];
                    [pk showViewController:self.passView];
                    
                } else {
                    UINavigationController *n = (UINavigationController *)self.nav;
                    [n pushViewController:self.passView animated:YES];
                }
                
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Invalid Email or Password"] message:@"" delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            
            NSLog(@"%@", self.config.email);
            
            
            
        }      else if (conn.tag == FORGET){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            
            if ([[dic objectForKey:@"success"] intValue] == 1){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"An email containing a temporary password has been sent to your email address."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"error"] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                [alert show];
            }
            
        }
        
        
        
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
    }
    @finally {
        //[indicator stopAnimating];
        //loading = 0;
        [indicatorsignup stopAnimating];
        [indicatorlogin stopAnimating];
        
        //searchBarState = 0;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [loginEmail resignFirstResponder];
    [loginPass resignFirstResponder];
    [signupEmail resignFirstResponder];
    [signupPass resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL proceedLogin = NO;
    BOOL proceedSignup = NO;
    if (textField == loginEmail){
        if (loginPass.text.length == 0){
            [loginEmail resignFirstResponder];
            [loginPass becomeFirstResponder];
        } else if (loginEmail.text.length > 0 ) {
            proceedLogin = YES;
        }
    }
    if (textField == loginPass){
        if (loginEmail.text.length == 0){
            [loginPass resignFirstResponder];
            [loginEmail becomeFirstResponder];
        } else if (loginPass.text.length > 0){
            proceedLogin = YES;
        }
    }
    if (textField == signupEmail){
        if (signupPass.text.length == 0){
            [signupEmail resignFirstResponder];
            [signupPass becomeFirstResponder];
        } else if (signupEmail.text.length > 0){
            proceedSignup = YES;
        }
    }
    if (textField == signupPass){
        if (signupEmail.text.length == 0){
            [signupPass resignFirstResponder];
            [signupEmail becomeFirstResponder];
        } else if (signupPass.text.length > 0){
            proceedSignup = YES;
        }
    }
    if (proceedLogin){
        [self login:nil];
    }
    if (proceedSignup){
        [self signup:nil];
    }
    
    return YES;
}

-(void)threadStartAnimating{
    [indicatorlogin startAnimating];
    [indicatorsignup startAnimating];
}

@end
