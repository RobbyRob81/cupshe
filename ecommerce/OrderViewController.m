//
//  OrderViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 7/19/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderDetailViewController.h"
#import "NSURLConnectionWithTag.h"
#import "OrderTableViewCell.h"
#import "Order.h"
#import "Cart.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "ViewWithData.h"
const int Get_ORDER = 1;
@interface OrderViewController ()

@end

@implementation OrderViewController

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
    label.text = [self.config localisedString:@"Order History"];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    // Do any additional setup after loading the view from its nib.
    receivedData = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < 5; i++){
        NSMutableData *rec = [[NSMutableData alloc] init];
        [receivedData addObject:rec];
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
    
    scroll = [[UIScrollView alloc] init];
    scroll.frame=CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64);
    scroll.userInteractionEnabled = YES;
    [self.view addSubview:scroll];
    
    [self load_order:0];
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

-(void)load_order:start{
    if (start == 0 ){
        order_views = [[NSMutableArray alloc] init];
        orders = [[NSMutableArray alloc] init];
    }
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating) toTarget:self withObject:nil];
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&start=%d&user_id=%@&access_token=%@", self.config.APP_UUID, start,self.config.user_id, self.config.token];
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GET_ORDER]]];
    
    
    
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
    
    NSMutableData *received = [receivedData objectAtIndex:Get_ORDER];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:Get_ORDER];
}

-(void)display_order{
    if (orders.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"You have no order history"] message:@"" delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:nil];
        
        [alert show];
    }
    long start = order_views.count;
    for (long i = start; i < orders.count;i++){
        Order *or = [orders objectAtIndex:i];
        UIView *order = [[UIView alloc] init];
        order.userInteractionEnabled = YES;
        
        ViewWithData *header = [[ViewWithData alloc] init];
        header.itemID = or.order_id;
        header.frame = CGRectMake(-1, 0, self.config.screenWidth+1, 60);
        header.userInteractionEnabled = YES;
        header.layer.borderWidth = 0.5;
        header.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(order_sel:)];
        [header addGestureRecognizer:tap];
        
        
        UILabel *ordernum = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, header.frame.size.width-30, 15)];
        ordernum.font = [UIFont systemFontOfSize:17];
        ordernum.text = [NSString stringWithFormat:@"%@ #%@", [self.config localisedString:@"Order"], or.order_id];
        ordernum.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        [header addSubview:ordernum];
        
        UILabel *orderdate = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, header.frame.size.width-60, 10)];
        orderdate.font = [UIFont systemFontOfSize:12];
        orderdate.textColor = [UIColor lightGrayColor];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *od = [format dateFromString:or.timestamp];
        format.dateFormat = @"MMM dd, yyyy";
        orderdate.text = [NSString stringWithFormat:@"%@: %@", [self.config localisedString:@"Order Date"], [format stringFromDate:od]];
        [header addSubview:orderdate];
        
        UILabel *ordertotal = [[UILabel alloc] initWithFrame:CGRectMake(15, 41, header.frame.size.width-60, 10)];
        ordertotal.font = [UIFont systemFontOfSize:12];
        ordertotal.textColor = [UIColor lightGrayColor];
        ordertotal.text = [NSString stringWithFormat:@"%@: $%0.2f", [self.config localisedString:@"Order Total"], or.total_product+or.total_shipping+or.total_tax];
        [header addSubview:ordertotal];
        
        [order addSubview:header];
        
        UILabel *next = [[UILabel alloc] initWithFrame:CGRectMake(header.frame.size.width-30, 0, 20, header.frame.size.height)];
        next.font = [IonIcons fontWithSize:30];
        next.textColor = [UIColor lightGrayColor];
        next.textAlignment = NSTextAlignmentRight;
        next.text = icon_ios7_arrow_forward;
        [header addSubview:next];
        
        UIView *productView = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height, self.config.screenWidth, 0)];
        float viewheight = 120;
        for (int j = 0 ; j < or.items.count; j++){
            Cart *c = [or.items objectAtIndex:j];
            UIView *cart = [[UIView alloc] initWithFrame:CGRectMake(0, j*viewheight, self.config.screenWidth, viewheight)];
            //CALayer *layer = [CALayer layer];
            //layer.frame = CGRectMake(0, cart.frame.size.height-0.5, cart.frame.size.width, 0.5);
            //layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
            //[cart.layer addSublayer:layer];
            
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, (cart.frame.size.height-10)/1.533, cart.frame.size.height-10)];
            img.contentMode = UIViewContentModeScaleAspectFit;
            NSString *url = [c.imageURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [Config loadImageURL:url toImageView:img withCacheKey:url trim:YES sizeMultiplyer:1 completion:^{
                
            }];
            [cart addSubview:img];
            
            UITextView *pname = [[UITextView alloc] initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+3, img.frame.origin.y-6, cart.frame.size.width-img.frame.origin.x-img.frame.size.width-30, viewheight/2)];
            pname.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
            pname.contentInset = UIEdgeInsetsMake(-2, 0, 0, 0);
            pname.text = c.name;
            pname.editable = NO;
            pname.scrollEnabled = NO;
            [cart addSubview:pname];
            
            UILabel *attr = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+8, viewheight-30, cart.frame.size.width-img.frame.origin.x-img.frame.size.width-35, 12)];
            attr.font = [UIFont systemFontOfSize:12];
            attr.textColor = [UIColor lightGrayColor];
            attr.text = c.attr_string;
            
            [cart addSubview:attr];
            
            UILabel *quan = [[UILabel alloc] initWithFrame:CGRectMake(attr.frame.origin.x, viewheight-18, cart.frame.size.width-img.frame.origin.x-img.frame.size.width-30, 12)];
            quan.font = [UIFont systemFontOfSize:11];
            quan.textColor = [UIColor lightGrayColor];
            quan.text = [NSString stringWithFormat:@"%@: %d",[self.config localisedString:@"Qty"], c.quantity] ;
            [cart addSubview:quan];

            [productView addSubview:cart];
            CGRect frame = productView.frame;
            frame.size.height = cart.frame.origin.y+cart.frame.size.height;
            productView.frame = frame;
            
        }
        
        [order addSubview:productView];
        
        UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, productView.frame.origin.y+productView.frame.size.height+3, self.config.screenWidth, 2)];
        separater.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        [order addSubview:separater];
        
        if (i == 0){
            order.frame = CGRectMake(0, 0, self.config.screenWidth, separater.frame.origin.y+separater.frame.size.height);
            
        } else {
            UIView *prev = [order_views objectAtIndex:i-1];
            order.frame = CGRectMake(0, prev.frame.origin.y+prev.frame.size.height, self.config.screenWidth, separater.frame.origin.y+separater.frame.size.height);
        }
        
        
        scroll.contentSize = CGSizeMake(self.config.screenWidth, order.frame.origin.y+order.frame.size.height);
        if (scroll.contentSize.height < self.config.screenHeight-64){
            scroll.contentSize = CGSizeMake(self.config.screenWidth, self.config.screenHeight+1);
        }
        [order_views addObject:order];
        [scroll addSubview:order];
        
        
    }
}

-(void)order_sel:(UITapGestureRecognizer *)ges{
    ViewWithData *vd = (ViewWithData *)ges.view;
    
    OrderDetailViewController *odv = [[OrderDetailViewController alloc] initWithNibName:@"OrderDetailViewController" bundle:nil];
    for (int i = 0 ; i < orders.count;i++){
        Order *o = [orders objectAtIndex:i];
        if ([o.order_id isEqualToString:vd.itemID]){
            odv.order = o;
            odv.config = self.config;
            [self.navigationController pushViewController:odv animated:YES];
            return;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        NSMutableData *received = [receivedData objectAtIndex:conn.tag];
        [received appendData:data];
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Cannot Connect to Internet"] message:@"" delegate:self cancelButtonTitle:[self.config localisedString:@"Cancel"] otherButtonTitles:nil];
        
        [alert show];
        
         [indicator stopAnimating];
        
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [indicator stopAnimating];
    //loading = 0;
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == Get_ORDER ){
            NSString *myxml = [[NSString alloc] initWithData:received encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:0 error:nil];
            int success = [[dic objectForKey:@"success"] intValue];
            if (success == 1){
                NSArray *o = [dic objectForKey:@"orders"];
                for (NSDictionary *d in o){
                    Order *order = [[Order alloc] init];
                    [order order_from_dictionary:d];
                    [orders addObject:order];
                }
                
                
                
                [self display_order];
               // [table reloadData];
                
            }
            
            
            
            
            
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
