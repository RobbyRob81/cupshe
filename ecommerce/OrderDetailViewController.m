//
//  OrderDetailViewController.m
//  Ecommerce
//
//  Created by Hanqing Hu on 8/1/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CartTableViewCell.h"
#import "Cart.h"
#import "IonIcons.h"
#import "ionicons-codes.h"
#import "Design.h"
#import "ViewWithData.h"

@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = [NSString stringWithFormat:@"%@ #%@", [self.config localisedString:@"Order"], self.order.order_id];
    [label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
    // Setup save button
    
    UILabel *cartbtn = [[UILabel alloc] init];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    cartbtn.text = [self.config localisedString:@"Support"];
    cartbtn.textAlignment = NSTextAlignmentRight;
    cartbtn.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(support:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    UIBarButtonItem *menuBtn2 = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
    self.navigationItem.rightBarButtonItem = menuBtn2;
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    
    
    
    
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
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    
    [self.view addSubview:scroll];
    
    [self display_order];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)display_order{
    UIView *ov = [[UIView alloc] init];
    ov.userInteractionEnabled = YES;
    
    ViewWithData *header = [[ViewWithData alloc] init];
    header.itemID = self.order.order_id;
    header.frame = CGRectMake(-1, 0, self.config.screenWidth+1, 145);
    header.userInteractionEnabled = YES;
    header.layer.borderWidth = 0.5;
    header.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UILabel *ordernum = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, header.frame.size.width-30, 15)];
    ordernum.font = [UIFont systemFontOfSize:17];
    ordernum.text = [NSString stringWithFormat:@"%@ #%@", [self.config localisedString:@"Order"], self.order.order_id];
    ordernum.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    [header addSubview:ordernum];
    
    UILabel *orderdate = [[UILabel alloc] initWithFrame:CGRectMake(15, 28, header.frame.size.width-60, 10)];
    orderdate.font = [UIFont systemFontOfSize:12];
    orderdate.textColor = [UIColor lightGrayColor];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *od = [format dateFromString:self.order.timestamp];
    format.dateFormat = @"MMM dd, yyyy";
    orderdate.text = [NSString stringWithFormat:@"%@: %@", [self.config localisedString:@"Order Date"], [format stringFromDate:od]];
    [header addSubview:orderdate];
    
    UILabel *ordertotal = [[UILabel alloc] initWithFrame:CGRectMake(15, 41, header.frame.size.width-60, 10)];
    ordertotal.font = [UIFont systemFontOfSize:12];
    ordertotal.textColor = [UIColor lightGrayColor];
    ordertotal.text = [NSString stringWithFormat:@"%@: $%0.2f", [self.config localisedString:@"Order Total"], self.order.total_product+self.order.total_shipping+self.order.total_tax];
    [header addSubview:ordertotal];
    
    [ov addSubview:header];
    
    UILabel *shiptitle = [[UILabel alloc] initWithFrame:CGRectMake(ordernum.frame.origin.x, ordertotal.frame.origin.y+ordertotal.frame.size.height+20, 200, 15)];
    shiptitle.font = [UIFont systemFontOfSize:14];
    shiptitle.textColor = [UIColor lightGrayColor];
    shiptitle.text = [self.config localisedString:@"Shipping Address"];
    [header addSubview:shiptitle];
    
    UITextView *shipaddr = [[UITextView alloc] initWithFrame:CGRectMake(ordernum.frame.origin.x, shiptitle.frame.origin.y+shiptitle.frame.size.height, header.frame.size.width-30, 60)];
    shipaddr.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    shipaddr.text = [NSString stringWithFormat:@"%@\n%@\n%@ %@ %@, %@", self.order.receipient, self.order.address, self.order.city, self.order.state, self.order.country, self.order.zip];
    shipaddr.contentInset = UIEdgeInsetsMake(-6, -5, 0, 0);
    shipaddr.editable = NO;
    shipaddr.scrollEnabled = NO;
    [header addSubview:shipaddr];
    
    UIView *headsep = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height-2, self.config.screenWidth, 2)];
    headsep.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    [header addSubview:headsep];
    
    UIView *shippingView = [[UIView alloc] initWithFrame:CGRectMake(0, header.frame.size.height, self.config.screenWidth, 40)];
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    layer.frame = CGRectMake(0, shippingView.frame.size.height, shippingView.frame.size.width, 0.5);
    [shippingView.layer addSublayer:layer];
    [ov addSubview:shippingView];
    
    UILabel *shippment = [[UILabel alloc] initWithFrame:CGRectMake(ordernum.frame.origin.x, 5, shippingView.frame.size.width, 17)];
    shippment.font = [UIFont systemFontOfSize:13];
    shippment.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    NSString *status = [self.config localisedString:@"Processing Order"];
    if (self.order.status == 1) status = [self.config localisedString:@"Shipped"];
    else if (self.order.status == 2) status = [self.config localisedString:@"Returned"];
    shippment.text = [NSString stringWithFormat:@"%@: %@", [self.config localisedString:@"Status"], status];
    [shippingView addSubview:shippment];
    
    UILabel *shipdate = [[UILabel alloc] initWithFrame:CGRectMake(shippment.frame.origin.x, 19, shippingView.frame.size.width, 15)];
    shipdate.font = [UIFont systemFontOfSize:12];
    shipdate.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    shipdate.textColor = [UIColor lightGrayColor];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *sd = [format dateFromString:self.order.shipping_date];
    format.dateFormat = @"MM/dd/yyyy";
    shipdate.text = [NSString stringWithFormat:@"%@ %@", self.order.shipping_name, [format stringFromDate:sd]];
    [shippingView addSubview:shipdate];
    
    
    UIView *productView = [[UIView alloc] initWithFrame:CGRectMake(0, shippingView.frame.origin.y+shippingView.frame.size.height, self.config.screenWidth, 0)];
    float viewheight = 120;
    for (int j = 0 ; j < self.order.items.count; j++){
        Cart *c = [self.order.items objectAtIndex:j];
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
        
        UILabel *attr = [[UILabel alloc] initWithFrame:CGRectMake(img.frame.origin.x+img.frame.size.width+8, viewheight-30, cart.frame.size.width-img.frame.origin.x-img.frame.size.width-140, 12)];
        attr.font = [UIFont systemFontOfSize:12];
        attr.textColor = [UIColor lightGrayColor];
        attr.text = c.attr_string;
        
        [cart addSubview:attr];
        
        UILabel *quan = [[UILabel alloc] initWithFrame:CGRectMake(attr.frame.origin.x, viewheight-18, cart.frame.size.width-img.frame.origin.x-img.frame.size.width-100, 12)];
        quan.font = [UIFont systemFontOfSize:12];
        quan.textColor = [UIColor lightGrayColor];
        quan.text = [NSString stringWithFormat:@"%@: %d", [self.config localisedString:@"Qty"], c.quantity] ;
        [cart addSubview:quan];
        
        
        
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(cart.frame.size.width-130, attr.frame.origin.y, 125, 26)];
        price.font = [UIFont systemFontOfSize:15];
        price.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
        price.textAlignment = NSTextAlignmentRight;
        price.text = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], c.paid_price];
        
        if (c.original_price > c.paid_price){
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%0.2f  %@%0.2f",[self.config getCurrencySymbol], c.original_price, [self.config getCurrencySymbol], c.paid_price]];
            
            
            NSString *pstr = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],c.original_price];
            //NSString *s = [NSString stringWithFormat:@"$%0.2f", sale_price];
            [attributeString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange){0,[pstr length]}];
            
            UIColor *priceColor = [UIColor colorWithRed:61/255.0 green:61/255.0 blue:61/255.0 alpha:1];
            
            UIColor *saleColor = [UIColor colorWithRed:204/255.0 green:76/255.0 blue:70/255.0 alpha:1];
            
            
            [attributeString addAttribute:NSForegroundColorAttributeName value:(id)priceColor range:NSMakeRange(0, [pstr length])];
            [attributeString addAttribute:NSForegroundColorAttributeName value:(id)saleColor range:NSMakeRange([pstr length], [attributeString length]-[pstr length])];
            [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:11] range:NSMakeRange(0, [attributeString length])];
            
            
            price.text = @"";
            price.attributedText = attributeString;
        }
        
        
        [cart addSubview:price];
        [productView addSubview:cart];
        
        
        CGRect frame = productView.frame;
        frame.size.height = cart.frame.origin.y+cart.frame.size.height;
        productView.frame = frame;
        
    }
    
    [ov addSubview:productView];
    
    UIView *separater = [[UIView alloc] initWithFrame:CGRectMake(0, productView.frame.origin.y+productView.frame.size.height+3, self.config.screenWidth, 2)];
    separater.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    [ov addSubview:separater];
    
    //**********
    UIView *subtotalView = [[UIView alloc] initWithFrame:CGRectMake(-1, separater.frame.origin.y+separater.frame.size.height-0.5, self.config.screenWidth+1, 35)];
    subtotalView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    subtotalView.layer.borderWidth = 0.5;
    [ov addSubview:subtotalView];
    
    UILabel *subtotaltitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    subtotaltitle.font = [UIFont systemFontOfSize:14];
    subtotaltitle.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    subtotaltitle.text = [self.config localisedString:@"Order Subtotal"];
    [subtotalView addSubview:subtotaltitle];
    
    
    UILabel *subtotalprice = [[UILabel alloc] initWithFrame:CGRectMake(subtotalView.frame.size.width-150, 0, 140, 35)];
    subtotalprice.font = [UIFont systemFontOfSize:14];
    subtotalprice.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    subtotalprice.text = [NSString stringWithFormat:@"%@%0.2f",[self.config getCurrencySymbol], self.order.total_product];
    subtotalprice.textAlignment = NSTextAlignmentRight;
    subtotalprice.font = [UIFont systemFontOfSize:15];
    [subtotalView addSubview:subtotalprice];
    
    //************
    UIView *taxView = [[UIView alloc] initWithFrame:CGRectMake(-1, subtotalView.frame.origin.y+subtotalView.frame.size.height-0.5, self.config.screenWidth+1, 35)];
    taxView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    taxView.layer.borderWidth = 0.5;
    [ov addSubview:taxView];
    
    UILabel *taxtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    taxtitle.font = [UIFont systemFontOfSize:14];
    taxtitle.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    taxtitle.text = [self.config localisedString:@"Sales Tax"];
    [taxView addSubview:taxtitle];
    
    UILabel *taxprice = [[UILabel alloc] initWithFrame:CGRectMake(subtotalView.frame.size.width-150, 0, 140, 35)];
    taxprice.font = [UIFont systemFontOfSize:14];
    taxprice.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    taxprice.text = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], self.order.total_tax];
    taxprice.textAlignment = NSTextAlignmentRight;
    taxprice.font = [UIFont systemFontOfSize:15];
    [taxView addSubview:taxprice];
    
    //*********
    UIView *shippriceView = [[UIView alloc] initWithFrame:CGRectMake(-1, taxView.frame.origin.y+taxView.frame.size.height-0.5, self.config.screenWidth+1, 35)];
    shippriceView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    shippriceView.layer.borderWidth = 0.5;
    [ov addSubview:shippriceView];
    
    UILabel *shiptotaltitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    shiptotaltitle.font = [UIFont systemFontOfSize:14];
    shiptotaltitle.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    shiptotaltitle.text = [self.config localisedString:@"Shipping"];
    taxprice.font = [UIFont systemFontOfSize:15];
    [shippriceView addSubview:shiptotaltitle];
    
    UILabel *shiptotalprice = [[UILabel alloc] initWithFrame:CGRectMake(subtotalView.frame.size.width-150, 0, 140, 35)];
    shiptotalprice.font = [UIFont systemFontOfSize:14];
    shiptotalprice.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    shiptotalprice.text = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol], self.order.total_shipping];
    shiptotalprice.textAlignment = NSTextAlignmentRight;
    [shippriceView addSubview:shiptotalprice];
    
    //*******
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(-1, shippriceView.frame.origin.y+shippriceView.frame.size.height-0.5, self.config.screenWidth+1, 35)];
    totalView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    totalView.layer.borderWidth = 0.5;
    [ov addSubview:totalView];
    
    UILabel *totaltitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 35)];
    totaltitle.font = [UIFont systemFontOfSize:14];
    totaltitle.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    totaltitle.text = [self.config localisedString:@"Total"];
    [totalView addSubview:totaltitle];
    
    UILabel *totalprice = [[UILabel alloc] initWithFrame:CGRectMake(subtotalView.frame.size.width-150, 0, 140, 35)];
    totalprice.font = [UIFont systemFontOfSize:14];
    totalprice.textColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    totalprice.text = [NSString stringWithFormat:@"%@%0.2f", [self.config getCurrencySymbol],self.order.total_product+self.order.total_shipping+self.order.total_tax];
    totalprice.textAlignment = NSTextAlignmentRight;
    totalprice.font = [UIFont systemFontOfSize:15];
    [totalView addSubview:totalprice];
    
    
    UIView *lastseparate = [[UIView alloc] initWithFrame:CGRectMake(0, totalView.frame.origin.y+totalView.frame.size.height, self.config.screenWidth, 2)];
    lastseparate.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1];
    [ov addSubview:lastseparate];
    
    ov.frame = CGRectMake(0, 0, self.config.screenWidth, lastseparate.frame.origin.y+lastseparate.frame.size.height);
    
    
    scroll.contentSize = CGSizeMake(self.config.screenWidth, ov.frame.origin.y+ov.frame.size.height);
    if (scroll.contentSize.height < self.config.screenHeight-64){
        scroll.contentSize = CGSizeMake(self.config.screenWidth, self.config.screenHeight+1);
    }
    [scroll addSubview:ov];
}

-(IBAction)support:(id)sender{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObject:self.config.app_email]];
        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil ];
}
-(void)threadStartAnimating{
    //[indicator startAnimating];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
