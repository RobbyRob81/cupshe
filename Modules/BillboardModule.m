//
//  BillboardModule.m
//  Ecommerce
//
//  Created by Hanqing Hu on 1/5/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "BillboardModule.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "NSURLConnectionBlock.h"
@implementation BillboardModule

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)get_bilboard:(Config *)config department:(NSString *)department_id{
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&department=%@", config.APP_UUID, department_id];
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", config.API_ROOT, config.API_BILLBOARD]]];
    
    //NSLog(@"%@", request.description);
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *returnData = (NSMutableData *)obj;
            
            self.billboards = nil;
            self.billboards = [[NSMutableArray alloc] init];
            
            if (returnData != nil && ![returnData isKindOfClass:[NSNull class]]){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
                NSArray *a = [dic objectForKey:@"billboards"];
                
                NSMutableArray *ps = [[NSMutableArray alloc] init];
                for (NSDictionary *d in a){
                    Billboard *e = [[Billboard alloc] init];
                    [e billboard_from_dictionary:d];
                    [ps addObject:e];
                    [self.billboards addObject:e];
                    // [promos addObject:e];
                }
            }
            
           [self display_view:config];
            

            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
    
    
    
    
}

-(void)get_bilboard:(Config *)config{
    
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&department=%d", config.APP_UUID, -1];
    
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", config.API_ROOT, config.API_BILLBOARD]]];
    
    //NSLog(@"%@", request.description);
    
    
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *returnData = (NSMutableData *)obj;
            
            self.billboards = nil;
            self.billboards = [[NSMutableArray alloc] init];
            
            if (returnData != nil && ![returnData isKindOfClass:[NSNull class]]){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
                NSArray *a = [dic objectForKey:@"billboards"];
                
                NSMutableArray *ps = [[NSMutableArray alloc] init];
                for (NSDictionary *d in a){
                    Billboard *e = [[Billboard alloc] init];
                    [e billboard_from_dictionary:d];
                    [ps addObject:e];
                    [self.billboards addObject:e];
                    // [promos addObject:e];
                }
            }
            
             [self display_view:config];
            
            
            
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
    
  
    
    
  
}

-(void)display_view:(Config *)config{
    self.userInteractionEnabled = YES;
    self.subvs = nil;
    image_queue=nil;
    detail_pages = nil;
    scroll = nil;
    self.subvs = [[NSMutableArray alloc] init];
    image_queue = [[NSMutableArray alloc] init];
    detail_pages = [[NSMutableArray alloc] init];
    scroll = [[UIScrollView alloc] init];
    if (self.billboards.count == 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
    }
    scroll.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    scroll.scrollEnabled = false;
    
    for (int i = 0 ; i < self.billboards.count; i++){
        Billboard *b = [self.billboards objectAtIndex:i];
        
        CGRect frame = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height);
        ViewWithData *view = [[ViewWithData alloc] initWithFrame:frame];
        view.backgroundColor = b.backcolor;
        view.itemID = b.billboard_id;
        if ([b.type isEqualToString:@"message"]){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(html_tapped:)];
        [view addGestureRecognizer:tap];
        } else if ([b.type isEqualToString:@"product"]){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(product_tapped:)];
            [view addGestureRecognizer:tap];
        }
        [Design style:[[DOM alloc] initWithView:view parent:self] design:self.design_view config:config];
        
        ImageWithData *preview = [[ImageWithData alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        preview.contentMode = UIViewContentModeScaleAspectFit;
        preview.url = [NSURL URLWithString:[b.preview_img stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(preview.frame.size.width/2 - indicator.frame.size.width/2, preview.frame.size.height/2 - indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
        indicator.hidesWhenStopped = YES;
        [indicator startAnimating];
        [view addSubview:indicator];
        preview.indicator = indicator;
        
        
        [view addSubview:preview];
        [image_queue addObject:preview];
        [Design style:[[DOM alloc] initWithView:preview parent:view] design:self.design_preview config:config];
        
        if (b.show_preview_text == 1){
            UIView *titleback = [[UIView alloc] init];
            titleback.backgroundColor = [UIColor clearColor];
            [Design style:[[DOM alloc] initWithView:titleback parent:view] design:self.design_desc_back config:config];
            [view addSubview:titleback];
        
            UILabel *title = [[UILabel alloc] init];
            title.backgroundColor = [UIColor clearColor];
            title.text = b.title;
            title.textColor = b.preview_text_color;
            [Design style:[[DOM alloc] initWithView:title parent:titleback] design:self.design_title config:config];
            [titleback addSubview:title];
        
            UITextView *desc = [[UITextView alloc] init];
            desc.backgroundColor = [UIColor clearColor];
            desc.userInteractionEnabled = NO;
            desc.editable = NO;
            desc.text = b.desc;
            desc.textColor = b.preview_text_color;
            [Design style:[[DOM alloc] initWithView:desc parent:titleback] design:self.design_desc config:config];
            [titleback addSubview:desc];
        }
        
        [scroll addSubview:view];
        
        [self.subvs addObject:view];
        
        
        //build detail page
        BillboardDetailPage *detail = [[BillboardDetailPage alloc] init];
        detail.frame = CGRectMake(0, 0, config.screenWidth, config.screenHeight);
        detail.clipsToBounds = YES;
        detail.billboard_id = b.billboard_id;
        ImageWithData *img = [[ImageWithData alloc] init];
        img.url = [NSURL URLWithString:[b.background_img stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        img.frame = CGRectMake(0, 0, detail.frame.size.width, detail.frame.size.height);
        [detail addSubview:img];
        detail.backgroud_img = img;
        UIWebView *web = [[UIWebView alloc] init];
        web.delegate = self;
        web.frame = CGRectMake(0, 64, detail.frame.size.width, detail.frame.size.height-64);
        web.backgroundColor = [UIColor clearColor];
        
        //NSString *html = [NSString stringWithFormat:@"<html><head><style>div {max-width:%0.0fpx;}</style></head><body><div>%@</div></body></html>", config.screenWidth, b.html];
        
        [web loadHTMLString:b.html baseURL:nil];
        [web setOpaque:NO];
        [detail addSubview:web];
        detail.web = web;
        detail.backgroundColor = b.backcolor;
        UIButton *close = [[UIButton alloc] init];
        close.frame = CGRectMake(detail.frame.size.width-60, 20, 60,44);
        [close addTarget:self action:@selector(closed:) forControlEvents:UIControlEventTouchUpInside];
        close.titleLabel.font = [IonIcons fontWithSize:28];
        [close setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [close setTitle:icon_ios7_close forState:UIControlStateNormal];
        detail.close = close;
        [detail addSubview:close];
        
        [detail_pages addObject:detail];
        
    }
    
    scroll.contentSize = CGSizeMake(self.billboards.count * self.frame.size.width, self.frame.size.height);
    scroll.userInteractionEnabled = YES;
    self.toright = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goleft)];
    self.toright.direction = UISwipeGestureRecognizerDirectionRight;
    self.toleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goright)];
    self.toleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [scroll addGestureRecognizer:self.toleft];
    [scroll addGestureRecognizer:self.toright];
    
    
    [self addSubview:scroll];
    
    if (self.billboards.count > 1){
        page = [[DDPageControl alloc] init];
        //page.frame = CGRectMake(0, self.frame.size.height-20, scroll.frame.size.width, 20);
        page.numberOfPages = self.billboards.count;
        page.currentPage = 0;
        page.delegate = self;
        [Design style:[[DOM alloc] initWithView:page parent:self] design:self.design_page_indicator config:config];
        
        //NSLog(@"%f", page.frame.size.width);
        [self addSubview:page];
    }
    
    [self load_images];
    [self.delegate billboard_finish_display:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
    [webView stringByEvaluatingJavaScriptFromString:padding];
    
}
-(void)page_changed:(int)direction{
    if (direction > 0) [self goright];
    else if (direction < 0) [self goleft];
}
-(void)html_tapped:(UITapGestureRecognizer *)ges{
    ViewWithData *v = (ViewWithData *)ges.view;
    
    for (BillboardDetailPage *b in detail_pages){
        if ([v.itemID isEqualToString:b.billboard_id]){
            if (b.backgroud_img.image == nil) {
                [Config loadImageURL:[b.backgroud_img.url absoluteString] toImageView:b.backgroud_img withCacheKey:[b.backgroud_img.url absoluteString] trim:YES sizeMultiplyer:1 completion:^{
                    
                }];
                /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:b.backgroud_img.url];
                    UIImage *image = [UIImage imageWithData:data];
                    CGSize newSize=image.size; // I am giving resolution 50*50 , you can change your need
                    UIGraphicsBeginImageContext(newSize);
                    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    //[self forceImageDecompression:image];
                    image = nil;
                    data = nil;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        b.backgroud_img.image = nil;
                        b.backgroud_img.image = newImage;
                    });
                    
                });*/
            }
            
            b.touchLocation = [ges locationInView:self.animationParent];
            [self.delegate billboard_html_touched:b];
            return;
        }
    }
    
    
}

-(void)product_tapped:(UITapGestureRecognizer *)ges{
    ViewWithData *v = (ViewWithData *)ges.view;
    
    for (Billboard *b in self.billboards){
        if ([v.itemID isEqualToString:b.billboard_id]){
            [self.delegate billboard_product_touched:b];
        }
    }
    
    
}

-(IBAction)closed:(id)sender{
    UIButton *btn = (UIButton *)sender;
    BillboardDetailPage *view = (BillboardDetailPage *)[btn superview];
    [self.delegate billboard_closed:view];
}

-(void)goleft{
    for (int i = 0; i < self.subvs.count; i++){
        UIView *img = [self.subvs objectAtIndex:i];
        if (scroll.contentOffset.x == img.frame.origin.x){
            if (i > 0) {
                UIView *prev = [self.subvs objectAtIndex:i-1];
                //activeImg = prev;
                [self scroll:scroll animateTo:CGPointMake(prev.frame.origin.x, 0)];
                page.currentPage--;
                return;
            }
            
        }
    }
}
-(void)goright{
    for (int i = 0; i < self.subvs.count; i++){
        UIView *img = [self.subvs objectAtIndex:i];
        if (scroll.contentOffset.x == img.frame.origin.x){
            if (i < self.subvs.count - 1) {
                UIImageView *prev = [self.subvs objectAtIndex:i+1];
                //activeImg = prev;
                [self scroll:scroll animateTo:CGPointMake(prev.frame.origin.x, 0)];
                page.currentPage++;
                return;
            }
            
        }
    }
}

-(void)scroll:(UIScrollView *)scrollView animateTo:(CGPoint)point{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentOffset:point];
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)load_images{
    for (ImageWithData *img in image_queue){
        NSString *url = [img.url absoluteString];
        [Config loadImageURL:url toImageView:img withCacheKey:url trim:YES sizeMultiplyer:1 completion:^{
            [img.indicator stopAnimating];
        }];
    }
    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        for (ImageWithData *img in image_queue){
            
            NSData *data = [NSData dataWithContentsOfURL:img.url];
            UIImage *i = [UIImage imageWithData:data];
            CGSize newSize=CGSizeMake(i.size.width, i.size.height); // I am giving resolution 50*50 , you can change your need
            //NSLog(@"%f, %f", i.size.width, i.size.height);
            UIGraphicsBeginImageContext(newSize);
            [i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            float ratio = img.frame.size.height/img.frame.size.width;
            
            if (newSize.height/newSize.width < ratio){
                
                CGImageRef imageref = CGImageCreateWithImageInRect([newImage CGImage], CGRectMake(newSize.width/2-newSize.height/ratio/2, 0, newSize.height/ratio, newSize.height));
                //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                newImage = [UIImage imageWithCGImage:imageref];
                CGImageRelease(imageref);
            } else if (newSize.height/newSize.width > ratio) {
                CGImageRef imageref = CGImageCreateWithImageInRect([newImage CGImage], CGRectMake(0, newSize.height/2-newSize.width*ratio/2, newSize.width, newSize.width*ratio));
                //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                newImage = [UIImage imageWithCGImage:imageref];
                CGImageRelease(imageref);
            }
            //[self forceImageDecompression:image];
            i = nil;
            data = nil;
            
            
            
            
     
            
            dispatch_async(dispatch_get_main_queue(), ^{
                img.image = nil;
                img.image = newImage;
            });
        }
    });*/
    
}



@end

@implementation BillboardDetailPage



@end
