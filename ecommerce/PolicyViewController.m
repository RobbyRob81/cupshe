//
//  PolicyViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/31/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "PolicyViewController.h"
#import "NSURLConnectionWithTag.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
@interface PolicyViewController ()

@end

@implementation PolicyViewController

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
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
    // Do any additional setup after loading the view from its nib.
    
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    [self.view insertSubview:web belowSubview:indicator];
    received = [[NSMutableData alloc] init];
    if (self.policytype == 0){
        if (self.config.returnPolicy == nil || self.config.returnPolicy.length == 0)
        [self load_policy];
        
        else { NSString *html = [NSString stringWithFormat:@"<html> \n"
                                       "<head> \n"
                                       "<style type=\"text/css\"> \n"
                                       "body {font-family: \"%@\"; font-size: %@; word-break:break-all;}\n"
                                       "</style> \n"
                                       "</head> \n"
                                       "<body>%@</body> \n"
                                       "</html>", @"helvetica", @"10pt", self.config.returnPolicy ];
        
            [web loadHTMLString:html baseURL:nil];}
        //else policytext.text = self.config.returnPolicy;
        label.text = [self.config localisedString:@"About Us"];
        
    } else if (self.policytype  == 1){
        if (self.config.privacyPolicy == nil || self.config.privacyPolicy.length == 0)
            [self load_policy];
        else {NSString *html = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-family: \"%@\"; font-size: %@; word-break:break-all;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", @"helvetica", @"10pt", self.config.privacyPolicy ];
        
            [web loadHTMLString:html baseURL:nil];}
        //[web loadHTMLString:self.config.privacyPolicy baseURL:nil];
        label.text = [self.config localisedString:@"Policy"];
    } else if (self.policytype  == 2){
        if (self.config.contact == nil || self.config.contact.length == 0)
            [self load_policy];
        else { NSString *html = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-family: \"%@\"; font-size: %@; word-break:break-all;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", @"helvetica", @"10pt", self.config.contact ];
        
            [web loadHTMLString:html baseURL:nil];}
        //[web loadHTMLString:self.config.contact baseURL:nil];
        label.text = [self.config localisedString:@"Contact Us"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)load_policy{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@", self.config.APP_UUID];
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_POLICY]]];
    
    
    
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
    
    //NSMutableData *received = [receivedData objectAtIndex:CHANGE_CARD];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        //NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
       // NSMutableData *received = [receivedData objectAtIndex:conn.tag];
        [received appendData:data];
        
    }
    @catch (NSException *exception) {
        
        
        
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    //loading = 0;
    
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    //NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
       NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
        NSLog(@"%@", myxml);
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
        NSString *privacy = [d objectForKey:@"privacy"];
        NSString *returnp = [d objectForKey:@"return"];
        NSString *contact = [d objectForKey:@"contact"];
        self.config.privacyPolicy = privacy;
        self.config.returnPolicy = returnp;
        self.config.contact = contact;
        if (privacy.length == 0){
            self.config.privacyPolicy = @"";
        }
        if (returnp.length == 0){
            self.config.returnPolicy= @"";
        }
        if (contact.length == 0){
            self.config.contact=@"";
        }
        if (self.policytype == 0){
            NSString *html = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-family: \"%@\"; font-size: %@; word-break:break-all;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", @"helvetica", @"10pt", self.config.returnPolicy ];
            
            [web loadHTMLString:html baseURL:nil];
            // [web loadHTMLString:self.config.returnPolicy baseURL:nil];
        } else if (self.policytype  == 1){
            NSString *html = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-family: \"%@\"; font-size: %@; word-break:break-all;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", @"helvetica", @"10pt", self.config.privacyPolicy ];
            NSLog(@"%@", html);
            [web loadHTMLString:html baseURL:nil];
           //[web loadHTMLString:self.config.privacyPolicy baseURL:nil];
        } else if (self.policytype == 2){
            NSString *html = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-family: \"%@\"; font-size: %@; word-break:break-all;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", @"helvetica", @"10pt", self.config.contact ];
            
            [web loadHTMLString:html baseURL:nil];
            //[web loadHTMLString:self.config.contact baseURL:nil];
        }
        
        
        
        
        
        
        
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
        
    }
    @finally {
        [indicator stopAnimating];
        //loading = 0;
        
        //searchBarState = 0;
    }
    
}

-(void)threadStartAnimating{
    [indicator startAnimating];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
