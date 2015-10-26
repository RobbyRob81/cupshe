//
//  ProductReviewViewControllerModule.m
//  Moooh
//
//  Created by Hanqing Hu on 2/20/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "ProductReviewViewControllerModule.h"
#import "NSURLConnectionBlock.h"
#import "NSURLConnectionWithTag.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "NSString+FontAwesome.h"
#import "Design.h"
#import "ViewWithData.h"
#import "LoginViewController.h"
#import "StringUtility.h"
const int YOPTO_BOTTOM_LINE = 1;
const int YOPTO_PRODUCT_REVIEW = 2;
const int YOPTO_ADD_REVIEW = 3;
const NSString *CHECK_PRODUCT_PURCHASE = @"userappuser/checkProductPurchase";
@interface ProductReviewViewControllerModule ()

@end

@implementation ProductReviewViewControllerModule

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self.API_LOAD_PRODUCT_REVIEW = @"userappuser/productReview";
    self.API_POST_PRODUCT_REVIEW = @"userappuser/addEditReview";
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.self_review_id = 0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    self.navigationItem.titleView = label;
    label.text = self.product.name;
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    // Do any additional setup after loading the view from its nib.
    
    
    
    UIView *cartView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    cartView.userInteractionEnabled = YES;
    cartView.clipsToBounds = NO;
    
    cartbtn = [[UILabel alloc] init];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    cartbtn.text = [self.config localisedString:@"Add"];
    cartbtn.textAlignment = NSTextAlignmentRight;
    cartbtn.frame = CGRectMake(0, 0, 80, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(add:)];
    [cartbtn addGestureRecognizer:tap];
    cartbtn.userInteractionEnabled = YES;
    [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    addbtn = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
    self.navigationItem.rightBarButtonItem = addbtn;
    
    /*UILabel *cartbtn = [[UILabel alloc] init];
     //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
     cartbtn.text = [self.config localisedString:@"Add"];
     cartbtn.font = [UIFont systemFontOfSize:15];
     cartbtn.textAlignment = NSTextAlignmentRight;
     cartbtn.frame = CGRectMake(0, 0, 60, 44);
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(add:)];
     [cartbtn addGestureRecognizer:tap];
     cartbtn.userInteractionEnabled = YES;
     addbtn = [[UIBarButtonItem alloc] initWithCustomView:cartbtn];
     self.navigationItem.rightBarButtonItem = addbtn;
     [Design style:[[DOM alloc] initWithView:cartbtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];*/
    
    
    UILabel *save = [[UILabel alloc] init];
    //cartbtn.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    save.text = [self.config localisedString:@"Save"];
    save.font = [UIFont systemFontOfSize:15];
    save.textAlignment = NSTextAlignmentRight;
    save.frame = CGRectMake(0, 0, 60, 44);
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(save_review)];
    [save addGestureRecognizer:tap2];
    save.userInteractionEnabled = YES;
    savebtn = [[UIBarButtonItem alloc] initWithCustomView:save];
    [Design style:[[DOM alloc] initWithView:save parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"navigation_icon"] config:self.config];
    
    
    
    UILabel *menubtn = [IonIcons labelWithIcon:icon_ios7_arrow_back size:22 color:[UIColor blackColor]];;
    menubtn.frame = CGRectMake(0, 0, 60, 44);
    [Design navigationbar_ion_icon:menubtn config:self.config];
    [Design style:[[DOM alloc] initWithView:menubtn parent:nil] design:[[self.config.design objectForKey:@"design"] objectForKey:@"left_navigation_ion_icon"] config:self.config];
    UITapGestureRecognizer *menutap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    [menubtn addGestureRecognizer:menutap];
    menubtn.userInteractionEnabled = YES;
    backbtn = [[UIBarButtonItem alloc] initWithCustomView:menubtn];
    self.navigationItem.leftBarButtonItem = backbtn;
    
    
    UILabel *close = [IonIcons labelWithIcon:icon_ios7_close size:22 color:[UIColor blackColor]];;
    close.frame = CGRectMake(0, 0, 60, 44);
    [Design navigationbar_ion_icon:close config:self.config];
    close.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
    UITapGestureRecognizer *closetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close_review)];
    [close addGestureRecognizer:closetap];
    close.userInteractionEnabled = YES;
    closebtn = [[UIBarButtonItem alloc] initWithCustomView:close];
    
    
    
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight-64)];
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
    // if ([self.reviewSource isEqualToString:@"Yotpo"]){
    add_review = [[UIView alloc] initWithFrame:CGRectMake(0, self.config.screenHeight, self.config.screenWidth, self.config.screenHeight)];
    add_review.backgroundColor = [UIColor whiteColor];
    star_buttons = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 5; i++){
        ButtonWithData *btn = [[ButtonWithData alloc] initWithFrame:CGRectMake(20+i*(44+3), 30, 44, 44)];
        btn.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:30];;
        [btn setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star-o"] forState:UIControlStateNormal];
        btn.tag = 1;
        [btn setTitleColor:[UIColor colorWithRed:226.0/255.0 green:244.0/255.0 blue:61.0/255.0 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rating_change:) forControlEvents:UIControlEventTouchUpInside];
        [star_buttons addObject:btn];
        [add_review addSubview:btn];
    }
    
    if (self.display_rating > 0){
        long rating = lroundf(self.display_rating);
        if (rating < 5) {
            [self rating_change:[star_buttons objectAtIndex:rating]];
        }
    }
    
    review_name = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, self.config.screenWidth-40, 40)];
    review_name.placeholder = [self.config localisedString:@"Display Name"];
    review_name.delegate = self;
    review_name.clearsOnBeginEditing = YES;
    review_name.layer.borderWidth = 0;
    review_name.font = [UIFont systemFontOfSize:18];
    
    [add_review addSubview:review_name];
    if (self.display_name != nil && self.display_name.length > 0) {
        review_name.clearsOnBeginEditing = false;
        review_name.text=self.display_name;
        cartbtn.text = [self.config localisedString:@"Edit"];
    }
    UIView *nameborde = [[UIView alloc] initWithFrame:CGRectMake(20, review_name.frame.origin.y+review_name.frame.size.height+5, review_name.frame.size.width, 2)];
    CALayer *nlayer = [CALayer layer];
    nlayer.frame = CGRectMake(0, 0, nameborde.frame.size.width, 0.5);
    nlayer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [nameborde.layer addSublayer:nlayer];
    [add_review addSubview:nameborde];
    
    
    review_title = [[UITextField alloc] initWithFrame:CGRectMake(20, 145, self.config.screenWidth-40, 30)];
    review_title.placeholder = [self.config localisedString:@"Review Title"];
    review_title.delegate = self;
    review_title.clearsOnBeginEditing = YES;
    //review_title.borderStyle = UITextBorderStyleRoundedRect;
    review_title.layer.borderWidth = 0;
    
    review_title.font = [UIFont systemFontOfSize:18];
    [add_review addSubview:review_title];
    if (self.display_title != nil && self.display_title.length > 0) {
        review_title.clearsOnBeginEditing = false;
        review_title.text=self.display_title;
        cartbtn.text = [self.config localisedString:@"Edit"];
    }
    
    
    UIView *titleborde = [[UIView alloc] initWithFrame:CGRectMake(20, review_title.frame.origin.y+review_title.frame.size.height+5, review_title.frame.size.width, 2)];
    CALayer *tlayer = [CALayer layer];
    tlayer.frame = CGRectMake(0, 0, titleborde.frame.size.width, 0.5);
    tlayer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [titleborde.layer addSublayer:tlayer];
    [add_review addSubview:titleborde];
    
    
    review_message = [[UITextView alloc] initWithFrame:CGRectMake(20, 195, self.config.screenWidth-40, 100)];
    review_message.contentInset = UIEdgeInsetsMake(0, -4, 0, 0);
    review_message.text = [self.config localisedString:@"Comments"];
    review_message.font = [UIFont systemFontOfSize:18];
    review_message.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:206/255.0 alpha:1];
    review_message.delegate = self;
    review_message.tag = 1;
    
    [add_review addSubview:review_message];
    if (self.display_text != nil && self.display_text.length > 0) {
        review_message.textColor = [UIColor blackColor];
        review_message.text=self.display_text;
    }
    
    
    [self.view addSubview:add_review];
    
    
    
    if (self.reviews != nil && self.reviews.count > 0){
        [self build_details];
    } else {
        
        
    }
    
    tried_login = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (self.reviews != nil && self.reviews.count > 0){
        
    } else {
        if (self.config.email == nil || self.config.email.length == 0){
            if (tried_login == 1)  {
                tried_login = 0;
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            lefty.config = self.config;
            [self presentViewController:lefty animated:YES completion:nil];
            tried_login = 1;
            return;
        } else {
            [self show_add:YES animated:NO];
        }
        
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.clearsOnBeginEditing = NO;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 1) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 0;
    }
}
-(IBAction)rating_change:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = (int)[star_buttons indexOfObject:btn];
    
    for (int i = 0 ; i < 5; i++){
        UIButton *b = [star_buttons objectAtIndex:i];
        if (i <= index){
            [b setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star"] forState:UIControlStateNormal];
            b.tag = 1;
        } else {
            [b setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star-o"] forState:UIControlStateNormal];
            b.tag = 0;
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)init_preview:(CGRect)frame{
    self.preview = [[UIView alloc] init];
    self.preview.frame = frame;
    
    preview_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    preview_indicator.hidesWhenStopped = YES;
    [preview_indicator stopAnimating];
    CGRect f = CGRectMake(self.preview.frame.size.width/2 - preview_indicator.frame.size.width/2, self.preview.frame.size.height/2 - preview_indicator.frame.size.height/2, preview_indicator.frame.size.width, preview_indicator.frame.size.height);
    preview_indicator.frame = f;
    [self.preview addSubview:preview_indicator];
    [NSThread detachNewThreadSelector:@selector(preview_indicator_start) toTarget:self withObject:nil];
    if ([self.reviewSource isEqualToString:@"Yotpo"]){
        [self load_yopto_reviews];
    } else {
        [self load_review];
    }
}
-(void)preview_indicator_start{
    if (preview_indicator != nil){
        [preview_indicator startAnimating];
    }
}
-(void)build_preview{
    
    
    UIView *total = [[UIView alloc] initWithFrame:CGRectMake(7, 0, self.preview.frame.size.width-14, 57.3)];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(-7, total.frame.size.height, total.frame.size.width+14, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [total.layer addSublayer:layer];
    CALayer *toplayer = [CALayer layer];
    toplayer.frame = CGRectMake(-7, 0, total.frame.size.width+17, 0.5);
    toplayer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [total.layer addSublayer:toplayer];
    
    UILabel *total_title = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 150, total.frame.size.height)];
    total_title.text = [self.config localisedString:@"Product Rating"];
    total_title.font = [UIFont boldSystemFontOfSize:18];
    total_title.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    [total addSubview:total_title];
    
    UILabel *total_count = [[UILabel alloc] initWithFrame:CGRectMake(total_title.frame.size.width, 0, 80, total.frame.size.height)];
    total_count.text = [NSString stringWithFormat:@"(%d)", self.totalreview];
    total_count.font = [UIFont systemFontOfSize:12];
    total_count.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    // [total addSubview:total_count];
    
    
    UILabel *starlabel = [[UILabel alloc] initWithFrame:CGRectMake(self.preview.frame.size.width-140, 0, 120, total.frame.size.height)];
    //starlabel.font = [IonIcons fontWithSize:18];
    starlabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    starlabel.text = [self draw_star:self.totalrating];
    starlabel.textAlignment = NSTextAlignmentRight;
    starlabel.textColor = [UIColor colorWithRed:226.0/255.0 green:244.0/255.0 blue:61.0/255.0 alpha:1];
    [total addSubview:starlabel];
    
    [self.preview addSubview:total];
    
    if (self.reviews.count > 0){
        ProductReview *pr = [self.reviews objectAtIndex:0];
        UIView *recent = [[UIView alloc] initWithFrame:CGRectMake(total.frame.origin.x, total.frame.origin.y+total.frame.size.height, total.frame.size.width, 0)];
        UILabel *recent_title = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 150, total.frame.size.height)];
        recent_title.text = [self.config localisedString:@"Recent Review"];
        recent_title.font = [UIFont boldSystemFontOfSize:16];
        recent_title.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        [recent addSubview:recent_title];
        
        UILabel *recentstar = [[UILabel alloc] initWithFrame:CGRectMake(self.preview.frame.size.width-140, 0, 120, total.frame.size.height)];
        recentstar.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];;
        recentstar.text = [self draw_star:pr.rating];
        recentstar.textAlignment = NSTextAlignmentRight;
        recentstar.textColor = [UIColor colorWithRed:226.0/255.0 green:244.0/255.0 blue:61.0/255.0 alpha:1];
        [recent addSubview:recentstar];
        
        UILabel *pretitle = [[UILabel alloc] init];
        //pretitle.editable = NO;
        pretitle.frame = CGRectMake(8, recent_title.frame.origin.y+recent_title.frame.size.height, recent.frame.size.width-16, 0);
        pretitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];;
        //pretitle.contentInset = UIEdgeInsetsMake(-4,-5, 0, 0);
        pretitle.text = [NSString stringWithFormat:@"%@", pr.title];
        CGSize size = [pretitle sizeThatFits:CGSizeMake(pretitle.frame.size.width, FLT_MAX)];
        CGRect frame = pretitle.frame;
        frame.size.height = size.height+8;
        pretitle.frame = frame;
        [recent addSubview:pretitle];
        
        UITextView *text = [[UITextView alloc] init];
        text.editable = NO;
        text.frame = CGRectMake(8, pretitle.frame.origin.y+pretitle.frame.size.height, recent.frame.size.width-16, 0);
        text.contentInset = UIEdgeInsetsMake(-4,-5, 0, 0);
        text.text = [[NSString stringWithFormat:@"%@", pr.text] stringByDecodingHTMLEntities];
        text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.3f];
        size = [text sizeThatFits:CGSizeMake(text.frame.size.width, FLT_MAX)];
        frame = text.frame;
        frame.size.height = size.height+8;
        text.frame = frame;
        [recent addSubview:text];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(8, text.frame.origin.y+text.frame.size.height, text.frame.size.width-118, 20)];
        name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
        name.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        name.text = pr.name;
        [recent addSubview:name];
        
        
        
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        // Set the date format according to your needs
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //for 12 hour format
        //[df setDateFormat:@"MM/dd/YYYY HH:mm "]  // for 24 hour format
        NSDate *date1 = [df dateFromString:pr.timestamp];
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
        NSInteger year = [components year];
        
        NSString *date = [self.config localisedString:@"Today"];
        if (year > 0) date = [NSString stringWithFormat:@"%@", [self.config localisedString:@"Last Year"]];
        if (month >1) date = [NSString stringWithFormat:@"%ld %@", month, [self.config localisedString:@"Months Ago"]];
        if (month == 1)  date = [NSString stringWithFormat:@"%ld %@", month, [self.config localisedString:@"Month ago"]];
        if (day >1) date = [NSString stringWithFormat:@"%ld %@", day, [self.config localisedString:@"Days Ago"]];
        if (day == 1)  date = [NSString stringWithFormat:@"%@", [self.config localisedString:@"Yesterday"]];
        
        UILabel *timestamp = [[UILabel alloc] initWithFrame:CGRectMake(text.frame.size.width-120, text.frame.origin.y+text.frame.size.height, 110, 20)];
        timestamp.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
        timestamp.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        timestamp.text = date;
        timestamp.textAlignment = NSTextAlignmentRight;
        [recent addSubview:timestamp];
        
        
        
        frame = recent.frame;
        frame.size.height = name.frame.origin.y+name.frame.size.height+15;
        recent.frame = frame;
        CALayer *layer2 = [CALayer layer];
        layer2.frame = CGRectMake(-7, recent.frame.size.height, recent.frame.size.width+14, 0.5);
        layer2.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        [recent.layer addSublayer:layer2];
        [self.preview addSubview:recent];
        
        UIView *more = [[UIView alloc] initWithFrame:CGRectMake(recent.frame.origin.x, recent.frame.origin.y+recent.frame.size.height, recent.frame.size.width, 57.3)];
        CALayer *layer3 = [CALayer layer];
        layer3.frame = CGRectMake(0, more.frame.size.height, more.frame.size.width, 0.5);
        layer3.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        [more.layer addSublayer:layer3];
        more.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(goto_detail_page)];
        [more addGestureRecognizer:tap];
        
        
        UILabel *more_title = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 180, total.frame.size.height)];
        more_title.text = [self.config localisedString:@"More Reviews"];
        more_title.font = [UIFont boldSystemFontOfSize:18];
        more_title.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        [more addSubview:more_title];
        
        UILabel *moreicon = [[UILabel alloc] initWithFrame:CGRectMake(self.preview.frame.size.width-120, 0, 100, total.frame.size.height)];
        moreicon.textAlignment = NSTextAlignmentRight;
        moreicon.font = [IonIcons fontWithSize:28];
        moreicon.text = icon_ios7_arrow_forward;
        moreicon.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        [more addSubview:moreicon];
        
        
        [self.preview addSubview:more];
        
        frame = self.preview.frame;
        frame.size.height = more.frame.origin.y+more.frame.size.height;
        self.preview.frame = frame;
    } else {
        UIView *more = [[UIView alloc] initWithFrame:CGRectMake(total.frame.origin.x, total.frame.origin.y+total.frame.size.height, total.frame.size.width, 57.3)];
        CALayer *layer3 = [CALayer layer];
        layer3.frame = CGRectMake(-7, more.frame.size.height, more.frame.size.width+14, 0.5);
        layer3.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        [more.layer addSublayer:layer3];
        more.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(goto_detail_page)];
        [more addGestureRecognizer:tap];
        
        
        UILabel *more_title = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 180, total.frame.size.height)];
        more_title.text = [self.config localisedString:@"Write a Review"];
        more_title.font = [UIFont boldSystemFontOfSize:18];
        more_title.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        [more addSubview:more_title];
        
        UILabel *moreicon = [[UILabel alloc] initWithFrame:CGRectMake(self.preview.frame.size.width-120, 0, 100, total.frame.size.height)];
        moreicon.textAlignment = NSTextAlignmentRight;
        moreicon.font = [IonIcons fontWithSize:28];
        moreicon.text = icon_ios7_arrow_forward;
        moreicon.textColor = [UIColor colorWithRed:41/255.0 green:39/255.0 blue:39/255.0 alpha:1];
        [more addSubview:moreicon];
        
        
        [self.preview addSubview:more];
        
        CGRect frame = self.preview.frame;
        frame.size.height = more.frame.origin.y+more.frame.size.height;
        self.preview.frame = frame;
    }
    
    [preview_indicator stopAnimating];
    [self.delegate preview_finish_loading];
    
    
}


-(void)build_details{
    self.review_item_views = [[NSMutableArray alloc] init];
    UIView *prev = nil;
    for (ProductReview *pr in self.reviews){
        float y = 0;
        if (prev != nil) y = prev.frame.origin.y+prev.frame.size.height;
        ProductReviewItemView *rv = [[ProductReviewItemView alloc] initWithFrame:CGRectMake(0, y, self.config.screenWidth, 0)];
        rv.review_id = pr.review_id;
        rv.clipsToBounds = YES;
        
        UILabel *starlabel = [[UILabel alloc] initWithFrame:CGRectMake(rv.frame.size.width-140, 10, 130, 20)];
        starlabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        starlabel.text = [self draw_star:pr.rating];
        starlabel.textAlignment = NSTextAlignmentRight;
        starlabel.textColor = [UIColor colorWithRed:226.0/255.0 green:244.0/255.0 blue:61.0/255.0 alpha:1];
        [rv addSubview:starlabel];
        
        
        UITextView *pretitle = [[UITextView alloc] init];
        pretitle.editable = NO;
        pretitle.scrollEnabled = NO;
        //pretitle.editable = NO;
        pretitle.contentInset = UIEdgeInsetsMake(-5, -4, 0, 0);
        pretitle.frame = CGRectMake(15, 10, rv.frame.size.width-140, 40);
        pretitle.font = [UIFont boldSystemFontOfSize:17];
        //pretitle.contentInset = UIEdgeInsetsMake(-4,-5, 0, 0);
        pretitle.text = [NSString stringWithFormat:@"%@", pr.title];
        CGSize size = [pretitle sizeThatFits:CGSizeMake(pretitle.frame.size.width, FLT_MAX)];
        CGRect frame = pretitle.frame;
        frame.size.height = size.height+8;
        pretitle.frame = frame;
        [rv addSubview:pretitle];
        
        
        UITextView *text = [[UITextView alloc] init];
        text.editable = NO;
        text.frame = CGRectMake(15, pretitle.frame.origin.y+pretitle.frame.size.height-3, rv.frame.size.width-30, 0);
        text.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];;
        text.contentInset = UIEdgeInsetsMake(0,-5, 0, 0);
        text.text = [[NSString stringWithFormat:@"%@", pr.text] stringByDecodingHTMLEntities];
        size = [text sizeThatFits:CGSizeMake(text.frame.size.width, FLT_MAX)];
        frame = text.frame;
        frame.size.height = size.height+8;
        text.frame = frame;
        [rv addSubview:text];
        
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, text.frame.origin.y+text.frame.size.height+5, self.config.screenWidth/2-30, 20)];
        name.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.3f];
        name.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        name.text = pr.name;
        [rv addSubview:name];
        
        
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        // Set the date format according to your needs
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //for 12 hour format
        //[df setDateFormat:@"MM/dd/YYYY HH:mm "]  // for 24 hour format
        NSDate *date1 = [df dateFromString:pr.timestamp];
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
        NSInteger year = [components year];
        
        NSString *date = [self.config localisedString:@"Today"];
        if (year > 0) date = [NSString stringWithFormat:@"%@", [self.config localisedString:@"Last Year"]];
        if (month >1) date = [NSString stringWithFormat:@"%ld %@", month, [self.config localisedString:@"Months Ago"]];
        if (month == 1)  date = [NSString stringWithFormat:@"%ld %@", month, [self.config localisedString:@"Month ago"]];
        if (day >1) date = [NSString stringWithFormat:@"%ld %@", day, [self.config localisedString:@"Days Ago"]];
        if (day == 1)  date = [NSString stringWithFormat:@"%@", [self.config localisedString:@"Yesterday"]];
        
        UILabel *timestamp = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth/2-15, text.frame.origin.y+text.frame.size.height+5, 120, 20)];
        //timestamp.font = [UIFont systemFontOfSize:13];
        //timestamp.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        timestamp.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.3f];
        timestamp.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        timestamp.text = date;
        [rv addSubview:timestamp];
        
        
        
        
        frame = rv.frame;
        frame.size.height = name.frame.origin.y+name.frame.size.height+10;
        rv.frame = frame;
        rv.default_frame = frame;
        
        
        if (pr.response != nil && pr.response.length > 0){
            
            ButtonWithData *but = [[ButtonWithData alloc] initWithFrame:CGRectMake(self.config.screenWidth-100, text.frame.origin.y+text.frame.size.height+5, 90, 20)];
            but.item_id = pr.review_id;
            [but addTarget:self action:@selector(view_response:) forControlEvents:UIControlEventTouchUpInside];
            [rv addSubview:but];
            
            UILabel *bubble = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, but.frame.size.height)];
            bubble.font = [IonIcons fontWithSize:20];
            bubble.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
            bubble.text = icon_ios7_chatbubble_outline;
            [but addSubview:bubble];
            
            UILabel *bubbletext = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, but.frame.size.width-17, but.frame.size.height)];
            bubbletext.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.3f];
            bubbletext.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
            //bubbletext.font = [UIFont systemFontOfSize:12];
            //bubbletext.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
            bubbletext.text = [self.config localisedString:@"View Reply"];
            [but addSubview:bubbletext];
            
            
            UITextView *response = [[UITextView alloc] init];
            response.editable = NO;
            response.frame = CGRectMake(30, rv.frame.size.height, rv.frame.size.width-30, 0);
            response.contentInset = UIEdgeInsetsMake(0,-5, 0, 0);
            response.text = [NSString stringWithFormat:@"%@", pr.response];
            response.backgroundColor = [UIColor clearColor];
            response.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.3f];
            CGSize size = [response sizeThatFits:CGSizeMake(response.frame.size.width, FLT_MAX)];
            CGRect frame = response.frame;
            frame.size.height = size.height+8;
            response.frame = frame;
            [rv addSubview:response];
            
            
            
            
            UILabel *rep = [[UILabel alloc] initWithFrame:CGRectMake(30, response.frame.origin.y+response.frame.size.height+5, self.config.screenWidth/2-15, 20)];
            //rep.font = [UIFont systemFontOfSize:13];
            rep.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.3f];
            rep.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
            //rep.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
            rep.text = [self.config localisedString:@"Seller Reply"];
            [rv addSubview:rep];
            
            UIView *backgound = [[UIView alloc] initWithFrame:CGRectMake(0, response.frame.origin.y, rv.frame.size.width, rep.frame.origin.y+rep.frame.size.height+10 -  response.frame.origin.y)];
            backgound.backgroundColor = [UIColor colorWithRed:245/255.0 green:243/255.0 blue:243/255.0 alpha:1];
            [rv insertSubview:backgound belowSubview:response];
            
            frame = rv.frame;
            frame.size.height = rep.frame.origin.y+rep.frame.size.height+10;
            //rv.frame = frame;
            rv.full_frame = frame;
            rv.isFull = NO;
            
            
            UIView *edge = [[UIView alloc] initWithFrame:CGRectMake(0, backgound.frame.origin.y, 15, backgound.frame.size.height)];
            edge.backgroundColor = [UIColor colorWithRed:80/255.0 green:156/255.0 blue:87/255.0 alpha:1];
            [rv addSubview:edge];
        }
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, rv.frame.size.height-0.5, rv.frame.size.width, 0.5);
        layer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        rv.bottom_border = layer;
        [rv.layer addSublayer:layer];
        
        [scroll addSubview:rv];
        [self.review_item_views addObject:rv];
        [scroll setContentSize:CGSizeMake(self.config.screenWidth, rv.frame.origin.y+rv.frame.size.height)];
        if (scroll.contentSize.height < self.config.screenHeight){
            [scroll setContentSize:CGSizeMake(self.config.screenWidth, self.config.screenHeight+1)];
        }
        
        prev = rv;
    }
}


-(IBAction)view_response:(id)sender{
    ButtonWithData *btn = (ButtonWithData *)sender;
    NSString *rid = btn.item_id;
    
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGFloat diff = 0;
                         for (int i = 0 ; i < self.review_item_views.count; i++){
                             ProductReviewItemView *pr = [self.review_item_views objectAtIndex:i];
                             if ([pr.review_id isEqualToString:rid]){
                                 if (!pr.isFull){
                                     pr.frame = pr.full_frame;
                                     pr.bottom_border.frame = CGRectMake(0, pr.frame.size.height-0.5, pr.frame.size.width, 0.5);
                                     diff = pr.full_frame.size.height - pr.default_frame.size.height;
                                     pr.isFull = YES;
                                 } else {
                                     pr.frame = pr.default_frame;
                                     pr.bottom_border.frame = CGRectMake(0, pr.frame.size.height-0.5, pr.frame.size.width, 0.5);
                                     diff = pr.default_frame.size.height - pr.full_frame.size.height;
                                     pr.isFull = NO;
                                 }
                             } else {
                                 CGRect frame = pr.frame;
                                 frame.origin.y = frame.origin.y+diff;
                                 pr.frame = frame;
                             }
                         }
                     }
                     completion:^(BOOL finished){
                     }];
    
    
    
}

-(NSMutableString *)draw_star:(float)rating{
    NSMutableString *stars = [[NSMutableString alloc] init];
    
    //NSMutableArray *starstr = [[NSMutableArray alloc] initWithObjects:icon_ios7_star,icon_ios7_star,icon_ios7_star,icon_ios7_star,icon_ios7_star, nil];
    NSMutableArray *starstr = [[NSMutableArray alloc] initWithObjects:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star"],[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star"],[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star"],[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star"],[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star"], nil];
    for (int i = 1 ; i <=starstr.count; i++){
        if (i > rating){
            if (i-rating < 0.1){
                //don't do anything. close enough to be a full star
            } else if (i-rating > 0.9 && i-rating < 1){
                [starstr replaceObjectAtIndex:i-1 withObject:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star-o"]];
            } else if (i-rating > 0.1 && i-rating < 0.9){
                [starstr replaceObjectAtIndex:i-1 withObject:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star-half-o"]];
            } else {
                [starstr replaceObjectAtIndex:i-1 withObject:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-star-o"]];
            }
        }
        
    }
    [stars appendFormat:@"%@ %@ %@ %@ %@", [starstr objectAtIndex:0],[starstr objectAtIndex:1],[starstr objectAtIndex:2],[starstr objectAtIndex:3],[starstr objectAtIndex:4]];
    return stars;
}

-(void)load_review{
    
    self.reviews = [[NSMutableArray alloc] init];
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&product_name=%@&user_id=%@", self.config.APP_UUID, self.product.name, self.config.user_id];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.API_LOAD_PRODUCT_REVIEW]]];
    
    
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
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            self.self_review_id = @"0";
            if (dic != nil){
                NSArray *rews = [dic objectForKey:@"reviews"];
                for (NSDictionary *d in rews){
                    ProductReview *pr = [[ProductReview alloc] init];
                    pr.user_id = [d objectForKey:@"user_id"];
                    pr.rating = [[d objectForKey:@"rating"] floatValue];
                    pr.text = [d objectForKey:@"review"];
                    pr.title = [d objectForKey:@"title"];
                    pr.name = [d objectForKey:@"reviewer_name"];
                    pr.timestamp = [d objectForKey:@"timestamp"];
                    pr.review_id = [d objectForKey:@"review_id"];
                    pr.status = [[d objectForKey:@"status"] intValue];
                    if ([pr.user_id isEqualToString:self.config.user_id]) {
                        
                        self.self_review_id = pr.review_id;
                        self.display_name = pr.name;
                        self.display_text = pr.text;
                        self.display_title = pr.title;
                        self.display_rating = pr.rating;
                        
                    }
                    
                    NSArray *answer = [d objectForKey:@"response"];
                    if (answer.count > 0){
                        pr.response = [[answer objectAtIndex:0] objectForKey:@"response"];
                        
                        
                    }
                    if (pr.status == 1){
                        [self.reviews addObject:pr];
                    }
                }
                
                self.totalrating = [[dic objectForKey:@"rating"] floatValue];
                self.totalreview = [[dic objectForKey:@"count"] intValue];
                [self build_preview];
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
}

-(void)post_review:(float)rating withTitle:(NSString *)title withText:(NSString *)review name:(NSString *)name{
    if (updating == 1) return;
    updating = 1;
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&product_name=%@&rating=%0.2f&title=%@&review=%@&user_id=%@&review_name=%@&review_id=%@", self.config.APP_UUID, self.product.name, rating, title, review, self.config.user_id, name, self.self_review_id];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.API_POST_PRODUCT_REVIEW]]];
    
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
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (dic != nil){
                int success = [[dic objectForKey:@"success"] intValue];
                if (success == 1){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your review is posted."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                    [alert show];
                    [self show_add:NO animated:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                } else {
                    int error = [[dic objectForKey:@"error"] intValue];
                    if (error == 101){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"You haven't purchased this product."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                        [alert show];
                    } else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Your review failed to save."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
                        [alert show];
                    }
                    
                }
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        updating = 0;
    };
    [connection start];
}
-(void)load_yopto_reviews{
    self.API_KEY = @"oOlQySHvILarwqRfa3v28UmFFgfbQZZFX4sFKLCt";
    api_sec = @"7irin5qjIfy1uZkNao3k3mI6SGGxMnvdE4xLNCPb";
    product_purchased = NO;
    
    
    //self.product.third_party_id = @"1037301892";
    
    NSString *myRequestString = @"";
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://api.yotpo.com/products/%@/%@/bottomline", self.API_KEY, self.product.third_party_id]]];
    //NSLog([NSString stringWithFormat:@"https://api.yotpo.com/products/%@/%@/bottomline", self.API_KEY, self.product.third_party_id]);
    [request setHTTPMethod: @"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: myRequestData];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:YOPTO_BOTTOM_LINE];
    
    
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://api.yotpo.com/products/%@/%@/reviews.json?count=100&page=1", self.API_KEY, self.product.third_party_id]]];
    //NSLog([NSString stringWithFormat:@"https://api.yotpo.com/products/%@/%@/reviews.json?count=100&page=1", self.API_KEY, self.product.third_party_id]);
    
    [request2 setHTTPMethod: @"GET"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    NSURLConnectionWithTag *urlConnection2 = [[NSURLConnectionWithTag alloc] initWithRequest:request2 delegate:self tag:YOPTO_PRODUCT_REVIEW];
    
    
    
    NSString *myRequestString3 = [NSString stringWithFormat:@"app_uuid=%@&product_name=%@user_id=%@", self.config.APP_UUID, self.product.name, self.config.user_id];
    
    // Create Data from request
    NSData *myRequestData3 = [NSData dataWithBytes: [myRequestString3 UTF8String] length: [myRequestString3 length]];
    NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, CHECK_PRODUCT_PURCHASE]]];
    
    NSLog(@"%@", myRequestString);
    
    // set Request Type
    [request3 setHTTPMethod: @"POST"];
    // Set content-type
    [request3 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request3 setHTTPBody: myRequestData3];
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request3];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *d = (NSMutableData *)obj;
            NSString *response = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@", response);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (dic != nil){
                int success = [[dic objectForKey:@"purchased"] intValue];
                if (success == 1){
                    
                    product_purchased = YES;
                    
                    
                    
                } else {
                    
                    
                }
            }
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        updating = 0;
    };
    [connection start];
    
    
}
-(void)post_yopto_review:(int)score title:(NSString *)title message:(NSString *)message name:(NSString *)name{
    
    NSString *myRequestString = [NSString stringWithFormat:@"appkey=%@&sku=%@&product_title=%@&display_name=%@&email=%@&review_content=%@&review_title=%@&review_score=%d", self.API_KEY, self.product.third_party_id, self.product.name, name, self.config.email, message, title, score];
    NSData *myRequestData2 = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"https://api.yotpo.com/v1/widget/reviews"]]];
    [request2 setHTTPMethod: @"POST"];
    [request2 setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request2 setHTTPBody: myRequestData2];
    NSURLConnectionWithTag *urlConnection2 = [[NSURLConnectionWithTag alloc] initWithRequest:request2 delegate:self tag:YOPTO_ADD_REVIEW];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    @try {
        NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
        
        [conn.receivedData appendData:data];
        
    }
    @catch (NSException *exception) {
        
        
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [self build_preview];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    
    
    // @try {
    if (conn.tag == YOPTO_BOTTOM_LINE ){
        NSString *myxml = [[NSString alloc] initWithData:conn.receivedData encoding:NSASCIIStringEncoding];
        NSLog(@"%@", myxml);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:conn.receivedData options:0 error:nil];
        self.totalrating = [[[[dic objectForKey:@"response"] objectForKey:@"bottomline"] objectForKey:@"average_score"] floatValue];
        self.totalreview = [[[[dic objectForKey:@"response"] objectForKey:@"bottomline"] objectForKey:@"total_reviews"] intValue];
    } else if (conn.tag == YOPTO_PRODUCT_REVIEW ){
        NSString *myxml = [[NSString alloc] initWithData:conn.receivedData encoding:NSASCIIStringEncoding];
        NSLog(@"%@", myxml);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:conn.receivedData options:0 error:nil];
        NSArray *a = [[dic objectForKey:@"response"] objectForKey:@"reviews"];
        self.reviews = [[NSMutableArray alloc] init];
        for (NSDictionary *d in a){
            ProductReview *pr = [[ProductReview alloc] init];
            pr.name = [[d objectForKey:@"user"] objectForKey:@"display_name"];
            pr.text = [d objectForKey:@"content"];
            pr.title = [d objectForKey:@"title"];
            pr.rating = [[d objectForKey:@"score"] floatValue];
            NSString *create = [d objectForKey:@"created_at"];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
            NSDate *da = [format dateFromString:create];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            pr.timestamp = [format stringFromDate:da];
            [self.reviews addObject:pr];
        }
        [self build_preview];
    } else if (conn.tag == YOPTO_ADD_REVIEW){
        NSString *myxml = [[NSString alloc] initWithData:conn.receivedData encoding:NSASCIIStringEncoding];
        NSLog(@"%@", myxml);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:conn.receivedData options:0 error:nil];
        if ([[dic objectForKey:@"message"] isEqualToString:@"ok"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your review is posted." message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
            [self show_add:NO animated:NO];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your review failed to save." message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}



-(void)show_add:(BOOL)show animated:(BOOL) animated{
    if ([self.reviewSource isEqualToString:@"Yotpo"]){
        if (!product_purchased) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"You haven't purchased this product."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    if (show) {
        self.navigationItem.leftBarButtonItem = closebtn;
        self.navigationItem.rightBarButtonItem = savebtn;
        if (animated){
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 add_review.frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight);
                                 
                                 
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        } else {
            add_review.frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight);
        }
    } else {
        self.navigationItem.leftBarButtonItem = backbtn;
        self.navigationItem.rightBarButtonItem = addbtn;
        if (animated){
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 add_review.frame = CGRectMake(0, self.config.screenHeight, self.config.screenWidth, self.config.screenHeight);
                                 
                                 
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        } else {
            add_review.frame = CGRectMake(0, self.config.screenHeight, self.config.screenWidth, self.config.screenHeight);
        }
    }
}

-(IBAction)add:(id)sender{
    if ([self.reviewSource isEqualToString:@"Yotpo"]){
        if (!product_purchased) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"You haven't purchased this product."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    if (self.config.email == nil || self.config.email.length == 0){
        LoginViewController *lefty = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        lefty.config = self.config;
        [self presentViewController:lefty animated:YES completion:nil];
        return;
    }
    [self show_add:YES animated:YES];
}
-(IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)close_review{
    if (self.reviews.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
        [self show_add:NO animated:NO];
    } else {
        [self show_add:NO animated:YES];
    }
}

-(void)save_review{
    
    if (review_title.text.length == 0 || review_title.clearsOnBeginEditing){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Please provide a review title."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (review_name.text.length == 0 || review_name.clearsOnBeginEditing){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[self.config localisedString:@"Please provide a review display name."] message:nil delegate:nil cancelButtonTitle:[self.config localisedString:@"Close"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *detail = review_message.text;
    //if (review_message.tag == 1) detail = @"";
    int score = 0;
    
    for (UIButton *b in star_buttons){
        if (b.tag == 1) score++;
    }
    
    if ([self.reviewSource isEqualToString:@"Yotpo"]){
        
        [self post_yopto_review:score title:review_title.text message:detail name:review_name.text];
    } else {
        [self post_review:score withTitle:review_title.text  withText:detail name:review_name.text];
    }
}


@end




@implementation ProductReviewViewControllerModuleDesign



@end

@implementation ProductReviewItemView



@end

@implementation ProductReview



@end
