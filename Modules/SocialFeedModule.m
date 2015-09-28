//
//  SocialFeedModule.m
//  Twixxies
//
//  Created by Hanqing Hu on 12/15/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "SocialFeedModule.h"
#import "ViewWithData.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "NSString+FontAwesome.h"
#import "Design.h"
#import "NSString+FontAwesome.h"
#import "SDImageCache.h"
#import "SDWebImageDownloader.h"
#import "NSURLConnectionBlock.h"
@implementation SocialFeedModule
@synthesize feed_type;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)get_social_feed:(NSURL *)url config:(Config *)config{
    
    self.userInteractionEnabled = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: url];
    
    NSLog(@"%@", request.description);
    
    
    // set Request Type
    [request setHTTPMethod: @"GET"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    //[request setHTTPBody: myRequestData];
    // Now send a request and get Response
    
    
    NSURLConnectionBlock *connection = [[NSURLConnectionBlock alloc] initWithRequest:request];
    connection.completion = ^(id obj, NSError *err) {
        
        if (!err) {
            //It's ok, do domething with the response data (obj)
            NSMutableData *returnData = (NSMutableData *)obj;
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
            
            
            if ([self.feed_type isEqualToString:@"Facebook"]){
                self.social_feeds = [[NSMutableArray alloc] init];
                for (NSDictionary *d in [dic objectForKey:@"data"]){
                    
                    [self.social_feeds addObject:d];
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [self display_facebook:config];
                });
                
                
                
            }
            if ([self.feed_type isEqualToString:@"Twitter"]){
                
                self.social_feeds = [dic objectForKey:@"content"] ;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self display_twitter:config];
                });
                
                
            }
            // Log Response
            NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            
            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
    
    
    
    
    
    
    //NSMutableData *received = [receivedData objectAtIndex:SOCIAL_LOAD];
    //[received setLength:0];
    // NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:SOCIAL_LOAD page:page];
}

-(void)display_facebook:(Config *)config{
    self.subvs = nil;
    self.subvs = [[NSMutableArray alloc] init];
    //self.backgroundColor = [UIColor colorWithRed:233/255.0 green:234/255.0 blue:237/255.0 alpha:1];
    
    /*UILabel *logo = [[UILabel alloc] init];
     logo.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
     logo.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook-square"];
     logo.textAlignment = NSTextAlignmentCenter;
     logo.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:224/255.0 alpha:1];
     logo.frame = CGRectMake(config.screenWidth/2-30, 10, 60, 60);
     [self addSubview:logo];*/
    
    
    NSMutableArray *evs = [[NSMutableArray alloc] init];
    //float contentHeight = [page.pageviews count]*164;
    NSMutableArray *countimg = [[NSMutableArray alloc] init];
    
    for (int i=0;i<self.social_feeds.count;i++){
        
        
        NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
        NSDictionary *obj = [self.social_feeds objectAtIndex:i];
        
        
        CGRect frame = CGRectMake(-1,80, config.screenWidth+2, 0);
        if (i > 0){
            UIView *prev = [self.subvs objectAtIndex:i-1];
            frame = CGRectMake(-1, prev.frame.origin.y+prev.frame.size.height, config.screenWidth+2, 0);
        }
        ViewWithData *ev = [[ViewWithData alloc] init];
        ev.itemID = [obj objectForKey:@"id"] ;
        ev.frame = frame;
        ev.backgroundColor = [UIColor blueColor];
        //ev.pageID = page.pageid;
        ev.userInteractionEnabled = YES;
        ev.backgroundColor = [UIColor blueColor];
        [self.subvs addObject:ev];
        
        [self addSubview:ev];
        [vs setObject:ev forKey:@"main"];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = appicon;
        [ev addSubview:icon];
        [vs setObject:icon forKey:@"appicon"];
        
        UILabel *author = [[UILabel alloc] init];
        author.text = [[obj objectForKey:@"from"] objectForKey:@"name"];
        author.font = [UIFont boldSystemFontOfSize:12];
        author.textColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
        [ev addSubview:author];
        [vs setObject:author forKey:@"author"];
        
        UILabel *time = [[UILabel alloc] init];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        NSDate *date = [df dateFromString:[obj objectForKey:@"created_time"]];
        [df setDateFormat:@"MMM"];
        NSString *month = [df stringFromDate:date];
        [df setDateFormat:@"dd"];
        NSString *day = [df stringFromDate:date];
        [df setDateFormat:@"hh:mm a"];
        NSString *hour = [df stringFromDate:date];
        
        UIView *datepane = [[UIView alloc] initWithFrame:CGRectMake(10, 14, 40, 35)];
        datepane.layer.borderColor = [[UIColor colorWithRed:77.0/255.0 green:101.0/255.0 blue:154.0/255.0 alpha:1] CGColor];
        datepane.layer.borderWidth = 0.5;
        UILabel *monthlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, datepane.frame.size.width, 15)];
        monthlabel.backgroundColor = [UIColor colorWithCGColor:datepane.layer.borderColor];
        monthlabel.text = month;
        monthlabel.font = [UIFont systemFontOfSize:10];
        monthlabel.textColor = [UIColor whiteColor];
        monthlabel.textAlignment = NSTextAlignmentCenter;
        [datepane addSubview:monthlabel];
        UILabel *datelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, monthlabel.frame.size.height, datepane.frame.size.width, datepane.frame.size.height-monthlabel.frame.size.height)];
        datelabel.font = [UIFont systemFontOfSize:12];
        datelabel.textColor = monthlabel.backgroundColor;
        datelabel.textAlignment = NSTextAlignmentCenter;
        datelabel.text = day;
        [datepane addSubview:datelabel];
        [ev addSubview:datepane];
        UILabel *hourlabel = [[UILabel alloc] initWithFrame:CGRectMake(datepane.frame.origin.x, datepane.frame.origin.y+datepane.frame.size.height, datepane.frame.size.width, 20)];
        hourlabel.textColor = [UIColor lightGrayColor];
        hourlabel.font = [UIFont systemFontOfSize:8];
        hourlabel.text = hour;
        hourlabel.textAlignment = NSTextAlignmentCenter;
        [ev addSubview:hourlabel];
        
        
        
        UITextView *text = [[UITextView alloc] init];
        //text.frame = frame;
        text.backgroundColor = [UIColor clearColor];
        text.userInteractionEnabled = YES;
        text.scrollEnabled = NO;
        text.editable = NO;
        
        text.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
        text.font = [UIFont systemFontOfSize:12];
        text.text = [obj objectForKey:@"message"];
        //[tv addSubview:text];
        
        [ev addSubview:text];
        [vs setObject:text forKey:@"text"];
        
        
        // frame = CGRectMake(ev.frame.size.width*0.05 ,ev.frame.size.width/719*480*0.05, ev.frame.size.width*0.9, ev.frame.size.width/719*480*0.9);
        UIImageView *backimg = [[UIImageView alloc] init];
        //logoimg.backgroundColor = [UIColor blackColor];
        backimg.contentMode = UIViewContentModeScaleAspectFit;
        
        [ev addSubview:backimg];
        
        [vs setObject:backimg forKey:@"image"];
        
        
        //frame = CGRectMake(0,0, ev.frame.size.width, 40);
        UIView *shareview = [[UIView alloc] init];
        shareview.tag = 1;
        shareview.userInteractionEnabled = YES;
        [Design style:[[DOM alloc] initWithView:shareview parent:nil] design:[[config.design objectForKey:@"design"] objectForKey:@"social_button_background"] config:config];
        
        
        UILabel *shareicon = [[UILabel alloc] initWithFrame:CGRectMake(config.screenWidth-75, 0, 15, 30)];
        shareicon.font = [IonIcons fontWithSize:18];
        shareicon.text = icon_ios7_redo;
        //shareicon.textColor = [UIColor lightGrayColor];
        [Design style:[[DOM alloc] initWithView:shareicon parent:nil] design:[[config.design objectForKey:@"design"] objectForKey:@"social_button"] config:config];
        [shareview addSubview:shareicon];
        LabelWithData *sharebtn = [[LabelWithData alloc] initWithFrame:CGRectMake(config.screenWidth-60, 0, 60, 30)];
        [shareview addSubview:sharebtn];
        sharebtn.userInteractionEnabled = YES;
        sharebtn.textColor = shareicon.textColor;
        sharebtn.text = [config localisedString:@"Share"];
        [Design style:[[DOM alloc] initWithView:sharebtn parent:nil] design:[[config.design objectForKey:@"design"] objectForKey:@"social_button"] config:config];
        
        sharebtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialsel:)];
        tap.numberOfTapsRequired = 1;
        [sharebtn addGestureRecognizer:tap];
        
        
        [vs setObject:shareview forKey:@"share_pane"];
        //[vs setObject:sharebtn forKey:@"share_btn"];
        [ev addSubview:shareview];
        ev.subpages = vs;
        [evs addObject:ev];
        
        if ([obj objectForKey:@"object_id"] == nil) {
            [countimg addObject:ev];
            backimg.hidden = YES;
            sharebtn.sharetext = text.text;
            if (countimg.count == self.social_feeds.count) [self finish_display_facebook:evs config:config];
            continue;
        }
        
        
        NSString *object_id = [obj objectForKey:@"object_id"];
        
        
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSString *url = [NSString stringWithFormat:@"%@%@", self.base_url, object_id];
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
            
            //NSLog(@"%@", request.description);
            
            
            // set Request Type
            [request setHTTPMethod: @"GET"];
            // Set content-type
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
            // Set Request Body
            //[request setHTTPBody: myRequestData];
            // Now send a request and get Response
            NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
            // Log Response
            NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
            // NSLog(@"%@", response);
            
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
            
            NSDictionary *post = [dic objectForKey:object_id];
            
            NSString *title= [post objectForKey:@"name"];
            sharebtn.shareurl = [post objectForKey:@"link"];
            
            NSString *imgurl = [post objectForKey:@"source"];
            
            
            if (imgurl == nil){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    backimg.image = nil;
                    backimg.image = nil;
                    backimg.hidden = true;
                    text.text = title;
                    sharebtn.sharetext = title;
                    //ev.hidden = YES;
                    //ev.subpages = vs;
                    [countimg addObject:ev];
                    if (countimg.count == self.social_feeds.count) [self finish_display_facebook:evs config:config];
                    
                });
                return;
            }
            imgurl = [imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [Config loadImageURL:imgurl toImageView:backimg withCacheKey:imgurl trim:YES sizeMultiplyer:1 completion:^{
                
            }];
            
            /*NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]];
             
             UIImage *i = [UIImage imageWithData:data];
             CGSize newSize=CGSizeMake(i.size.width, i.size.height); // I am giving resolution 50*50 , you can change your need
             //NSLog(@"%f, %f", i.size.width, i.size.height);
             UIGraphicsBeginImageContext(newSize);
             [i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
             UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             
             float ratio = 480/719.0;
             
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
             data = nil;*/
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                text.text = title;
                
                sharebtn.shareimgView = backimg;
                sharebtn.sharetext = title;
                //ev.subpages = vs;
                [countimg addObject:ev];
                if (countimg.count == self.social_feeds.count) [self finish_display_facebook:evs config:config];
                
            });
            
            
        });
        
        
        
        
        
        
        
        
    }
    
    //page.updating = false;
    
}
/*
 -(void)display_facebook:(Config *)config{
 self.subvs = nil;
 self.subvs = [[NSMutableArray alloc] init];
 self.backgroundColor = [UIColor colorWithRed:233/255.0 green:234/255.0 blue:237/255.0 alpha:1];
 
 UILabel *logo = [[UILabel alloc] init];
 logo.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
 logo.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-facebook-square"];
 logo.textAlignment = NSTextAlignmentCenter;
 logo.textColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:224/255.0 alpha:1];
 logo.frame = CGRectMake(config.screenWidth/2-30, 10, 60, 60);
 [self addSubview:logo];
 
 
 NSMutableArray *evs = [[NSMutableArray alloc] init];
 //float contentHeight = [page.pageviews count]*164;
 NSMutableArray *countimg = [[NSMutableArray alloc] init];
 
 for (int i=0;i<self.social_feeds.count;i++){
 
 
 NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
 NSDictionary *obj = [self.social_feeds objectAtIndex:i];
 
 
 CGRect frame = CGRectMake(-1,80, config.screenWidth+2, 0);
 if (i > 0){
 UIView *prev = [self.subvs objectAtIndex:i-1];
 frame = CGRectMake(-1, prev.frame.origin.y+prev.frame.size.height, config.screenWidth+2, 0);
 }
 ViewWithData *ev = [[ViewWithData alloc] init];
 ev.itemID = [obj objectForKey:@"id"] ;
 ev.frame = frame;
 ev.backgroundColor = [UIColor blueColor];
 //ev.pageID = page.pageid;
 ev.userInteractionEnabled = YES;
 ev.backgroundColor = [UIColor blueColor];
 [self.subvs addObject:ev];
 
 [self addSubview:ev];
 [vs setObject:ev forKey:@"main"];
 
 UIImageView *icon = [[UIImageView alloc] init];
 icon.image = appicon;
 [ev addSubview:icon];
 [vs setObject:icon forKey:@"appicon"];
 
 UILabel *author = [[UILabel alloc] init];
 author.text = [[obj objectForKey:@"from"] objectForKey:@"name"];
 [ev addSubview:author];
 [vs setObject:author forKey:@"author"];
 
 UILabel *time = [[UILabel alloc] init];
 NSDateFormatter *df = [[NSDateFormatter alloc] init];
 [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
 NSDate *date = [df dateFromString:[obj objectForKey:@"created_time"]];
 [df setDateFormat:@"eee MMM dd, yyyy hh:mm"];
 NSString *dateStr = [df stringFromDate:date];
 time.text = dateStr;
 [ev addSubview:time];
 [vs setObject:time forKey:@"time"];
 
 
 
 UITextView *text = [[UITextView alloc] init];
 //text.frame = frame;
 text.backgroundColor = [UIColor clearColor];
 text.userInteractionEnabled = YES;
 text.scrollEnabled = NO;
 text.editable = NO;
 
 text.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1];
 text.font = [UIFont systemFontOfSize:12];
 text.text = [obj objectForKey:@"message"];
 //[tv addSubview:text];
 
 [ev addSubview:text];
 [vs setObject:text forKey:@"text"];
 
 
 // frame = CGRectMake(ev.frame.size.width*0.05 ,ev.frame.size.width/719*480*0.05, ev.frame.size.width*0.9, ev.frame.size.width/719*480*0.9);
 UIImageView *backimg = [[UIImageView alloc] init];
 //logoimg.backgroundColor = [UIColor blackColor];
 backimg.contentMode = UIViewContentModeScaleAspectFit;
 
 [ev addSubview:backimg];
 
 [vs setObject:backimg forKey:@"image"];
 
 
 //frame = CGRectMake(0,0, ev.frame.size.width, 40);
 UIView *shareview = [[UIView alloc] init];
 shareview.tag = 1;
 shareview.userInteractionEnabled = YES;
 
 
 LabelWithData *sharebtn = [[LabelWithData alloc] init];
 //sharebtn.text = icon_share;
 [shareview addSubview:sharebtn];
 sharebtn.text= @"Share";
 //UILabel *icon = [IonIcons labelWithIcon:icon_share size:28 color:[UIColor lightGrayColor]];
 //icon.textAlignment = NSTextAlignmentCenter;
 //icon.frame = CGRectMake(0, 0, sharebtn.frame.size.width, sharebtn.frame.size.height);
 //[sharebtn addSubview:icon];
 
 sharebtn.userInteractionEnabled = YES;
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialsel:)];
 tap.numberOfTapsRequired = 1;
 [sharebtn addGestureRecognizer:tap];
 
 
 [vs setObject:shareview forKey:@"share_pane"];
 [vs setObject:sharebtn forKey:@"share_btn"];
 [ev addSubview:shareview];
 ev.subpages = vs;
 [evs addObject:ev];
 
 if ([obj objectForKey:@"object_id"] == nil) {
 [countimg addObject:ev];
 backimg.hidden = YES;
 sharebtn.sharetext = text.text;
 if (countimg.count == self.social_feeds.count) [self finish_display_facebook:evs config:config];
 continue;
 }
 
 
 NSString *object_id = [obj objectForKey:@"object_id"];
 
 
 
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
 dispatch_async(queue, ^{
 NSString *url = [NSString stringWithFormat:@"%@%@", self.base_url, object_id];
 url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: url]];
 
 //NSLog(@"%@", request.description);
 
 
 // set Request Type
 [request setHTTPMethod: @"GET"];
 // Set content-type
 [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
 // Set Request Body
 //[request setHTTPBody: myRequestData];
 // Now send a request and get Response
 NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
 // Log Response
 NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
 // NSLog(@"%@", response);
 
 
 
 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
 
 NSDictionary *post = [dic objectForKey:object_id];
 
 NSString *title= [post objectForKey:@"name"];
 sharebtn.shareurl = [post objectForKey:@"link"];
 
 NSString *imgurl = [post objectForKey:@"source"];
 
 NSLog(@"%@ %@ %@, %@", object_id, request.description, response, imgurl);
 
 
 if (imgurl == nil){
 
 dispatch_async(dispatch_get_main_queue(), ^{
 backimg.image = nil;
 backimg.image = nil;
 backimg.hidden = true;
 text.text = title;
 sharebtn.sharetext = title;
 //ev.hidden = YES;
 //ev.subpages = vs;
 [countimg addObject:ev];
 if (countimg.count == self.social_feeds.count) [self finish_display_facebook:evs config:config];
 //CGRect frame = CGRectMake(0, scroll.height, <#CGFloat width#>, <#CGFloat height#>)
 });
 return;
 }
 imgurl = [imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 
 
 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]];
 
 UIImage *i = [UIImage imageWithData:data];
 CGSize newSize=CGSizeMake(i.size.width, i.size.height); // I am giving resolution 50*50 , you can change your need
 //NSLog(@"%f, %f", i.size.width, i.size.height);
 UIGraphicsBeginImageContext(newSize);
 [i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 float ratio = 480/719.0;
 
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
 backimg.image = nil;
 backimg.image = newImage;
 text.text = title;
 
 sharebtn.shareimg = newImage;
 sharebtn.sharetext = title;
 //ev.subpages = vs;
 [countimg addObject:ev];
 if (countimg.count == self.social_feeds.count) [self finish_display_facebook:evs config:config];
 
 });
 
 
 });
 
 
 
 
 
 
 
 
 }
 
 //page.updating = false;
 
 }
 */


-(void)finish_display_facebook:(NSMutableArray *)evs config:(Config *)config{
    //[page pageReset];
    CGRect prev = CGRectMake(0, 0, 0, 0);
    for (int i=0;i<evs.count;i++){
        
        ViewWithData *ev = [evs objectAtIndex:i];
        if (ev.hidden == YES) continue;
        [Design department_facebook:ev.subpages config:config prevFrame:prev];
        NSLog(@"%f, %f", prev.origin.y,prev.size.height);
        prev = ev.frame;
        //[page appendView:ev withFrame:ev.frame];
        [self addSubview:ev];
        
        if (i == self.social_feeds.count - 1){
            CGRect frame = self.frame;
            
            frame.size.height = ev.frame.origin.y+ ev.frame.size.height;
            frame.size.width = config.screenWidth;
            self.frame = frame;
        }
        
    }
    
    
    [self.delegate social_finish_loading:self];
    
    /*if (finite != nil)
     [finite endUpdatePage:page];
     if (infinite!=nil)[infinite endUpdatePage:page];
     [page stopRefresh];*/
    //[Design department_social_page:page config:self.config];
    
    
}


-(void)display_twitter:(Config *)config{
    //  self.backgroundColor = [UIColor colorWithRed:159/255.0 green:196/255.0 blue:214/255.0 alpha:1];
    
    
    /*UILabel *logo = [[UILabel alloc] init];
     logo.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
     logo.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-twitter"];
     logo.textAlignment = NSTextAlignmentCenter;
     logo.textColor = [UIColor colorWithRed:151/255.0 green:186/255.0 blue:204/255.0 alpha:1];
     logo.frame = CGRectMake(config.screenWidth/2-30, 10, 60, 60);
     [self addSubview:logo];*/
    
    CGRect prev = CGRectMake(0, 0, 0, 0);
    for (int i=0;i<self.social_feeds.count;i++){
        
        
        NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
        
        NSDictionary *tw = [self.social_feeds objectAtIndex:i];
        
        
        
        ViewWithData *ev = [[ViewWithData alloc] init];
        ev.itemID = [tw objectForKey:@"id_str"];
        //ev.pageID = page.pageid;
        ev.backgroundColor = [UIColor whiteColor];
        [vs setObject:ev forKey:@"main"];
        
        /*UIImageView *icon = [[UIImageView alloc] init];
         icon.image = appicon;
         [ev addSubview:icon];
         [vs setObject:icon forKey:@"appicon"];*/
        
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //Wed Dec 01 17:08:03 +0000 2010
        [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *date = [df dateFromString:[tw objectForKey:@"created_at"]];
        [df setDateFormat:@"MMM"];
        NSString *month = [df stringFromDate:date];
        [df setDateFormat:@"dd"];
        NSString *day = [df stringFromDate:date];
        [df setDateFormat:@"hh:mm a"];
        NSString *hour = [df stringFromDate:date];
        
        UIView *datepane = [[UIView alloc] initWithFrame:CGRectMake(10, 14, 40, 35)];
        datepane.layer.borderColor = [[UIColor colorWithRed:77.0/255.0 green:101.0/255.0 blue:154.0/255.0 alpha:1] CGColor];
        datepane.layer.borderWidth = 0.5;
        UILabel *monthlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, datepane.frame.size.width, 15)];
        monthlabel.backgroundColor = [UIColor colorWithCGColor:datepane.layer.borderColor];
        monthlabel.text = month;
        monthlabel.font = [UIFont systemFontOfSize:10];
        monthlabel.textColor = [UIColor whiteColor];
        monthlabel.textAlignment = NSTextAlignmentCenter;
        [datepane addSubview:monthlabel];
        UILabel *datelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, monthlabel.frame.size.height, datepane.frame.size.width, datepane.frame.size.height-monthlabel.frame.size.height)];
        datelabel.font = [UIFont systemFontOfSize:12];
        datelabel.textColor = monthlabel.backgroundColor;
        datelabel.textAlignment = NSTextAlignmentCenter;
        datelabel.text = day;
        [datepane addSubview:datelabel];
        [ev addSubview:datepane];
        UILabel *hourlabel = [[UILabel alloc] initWithFrame:CGRectMake(datepane.frame.origin.x, datepane.frame.origin.y+datepane.frame.size.height, datepane.frame.size.width, 20)];
        hourlabel.textColor = [UIColor lightGrayColor];
        hourlabel.font = [UIFont systemFontOfSize:8];
        hourlabel.text = hour;
        hourlabel.textAlignment = NSTextAlignmentCenter;
        [ev addSubview:hourlabel];
        
        
        UILabel *author = [[UILabel alloc] init];
        author.text = self.social_username;
        NSString *str = [NSString stringWithFormat:@"%@", self.social_username];
        author.text = str;
        author.font = [UIFont boldSystemFontOfSize:13];
        author.textColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
        [ev addSubview:author];
        [vs setObject:author forKey:@"author"];
        
        
        
        UITextView *text = [[UITextView alloc] init];
        text.userInteractionEnabled = YES;
        text.scrollEnabled = NO;
        text.editable = NO;
        
        [ev addSubview:text];
        
        text.text = [tw objectForKey:@"text"];
        [vs setObject:text forKey:@"text"];
        
        
        
        UIView *shareview = [[UIView alloc] init];
        shareview.tag = 1;
        shareview.userInteractionEnabled = YES;
        [Design style:[[DOM alloc] initWithView:shareview parent:nil] design:[[config.design objectForKey:@"design"] objectForKey:@"social_button_background"] config:config];
        
        UILabel *shareicon = [[UILabel alloc] initWithFrame:CGRectMake(config.screenWidth-75, 0, 15, 30)];
        shareicon.font = [IonIcons fontWithSize:18];
        shareicon.text = icon_ios7_redo;
        //shareicon.textColor = [UIColor lightGrayColor];
        [Design style:[[DOM alloc] initWithView:shareicon parent:nil] design:[[config.design objectForKey:@"design"] objectForKey:@"social_button"] config:config];
        [shareview addSubview:shareicon];
        LabelWithData *sharebtn = [[LabelWithData alloc] initWithFrame:CGRectMake(config.screenWidth-60, 0, 60, 30)];
        [shareview addSubview:sharebtn];
        sharebtn.userInteractionEnabled = YES;
        sharebtn.textColor = shareicon.textColor;
        sharebtn.text = [config localisedString:@"Share"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialsel:)];
        tap.numberOfTapsRequired = 1;
        [sharebtn addGestureRecognizer:tap];
        sharebtn.sharetext = text.text;
        
        UILabel *retweeticon = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 20, 30)];
        retweeticon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
        retweeticon.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-retweet"];
        retweeticon.textColor = shareicon.textColor;
        [shareview addSubview:retweeticon];
        LabelWithData *retweet = [[LabelWithData alloc] initWithFrame:CGRectMake(52, 0, 60, 30)];
        [shareview addSubview:retweet];
        retweet.textColor = shareicon.textColor;
        retweet.userInteractionEnabled = YES;
        retweet.text = [NSString stringWithFormat:@"%d",[[tw objectForKey:@"retweet_count"] intValue]];;
        
        UILabel *favicon = [[UILabel alloc] initWithFrame:CGRectMake(config.screenWidth/2-15, 0, 15, 30)];
        favicon.font = [IonIcons fontWithSize:18];
        favicon.text = icon_ios7_star;
        favicon.textColor = shareicon.textColor;
        [shareview addSubview:favicon];
        LabelWithData *fav = [[LabelWithData alloc] initWithFrame:CGRectMake(config.screenWidth/2+2, 0, 80, 30)];
        [shareview addSubview:fav];
        fav.userInteractionEnabled = YES;
        fav.textColor = shareicon.textColor;
        fav.text = [NSString stringWithFormat:@"%d",[[tw objectForKey:@"favorite_count"] intValue]];
        
        
        [ev addSubview:shareview];
        
        [vs setObject:shareview forKey:@"share_pane"];
        //[vs setObject:sharebtn forKey:@"share_btn"];
        
        
        
        UIImageView *backimg = [[UIImageView alloc] init];
        //logoimg.backgroundColor = [UIColor blackColor];
        backimg.contentMode = UIViewContentModeScaleAspectFit;
        [ev addSubview:backimg];
        [vs setObject:backimg forKey:@"image"];
        
        NSString *imgurl = nil;
        NSArray *media = [[tw objectForKey:@"entities"] objectForKey:@"media"];
        
        if (media.count > 0){
            backimg.hidden = NO;
            
            imgurl = [[media objectAtIndex:0] objectForKey:@"media_url"];
            imgurl = [imgurl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [Config loadImageURL:imgurl toImageView:backimg withCacheKey:imgurl trim:YES sizeMultiplyer:1 completion:^{
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                sharebtn.shareimgView = backimg;
            });
            /*
             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
             dispatch_async(queue, ^{
             
             
             
             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]];
             UIImage *i = [UIImage imageWithData:data];
             CGSize newSize=CGSizeMake(i.size.width, i.size.height); // I am giving resolution 50*50 , you can change your need
             //NSLog(@"%f, %f", i.size.width, i.size.height);
             UIGraphicsBeginImageContext(newSize);
             [i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
             UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             
             float ratio = 480/719.0;
             
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
             backimg.image = nil;
             backimg.image = newImage;
             sharebtn.shareimgView = backimg;
             });
             
             
             });*/
            
            
        } else {
            
            backimg.hidden = YES;
        }
        
        
        
        ev.subpages = vs;
        [Design department_twitter:vs config:config prevFrame:prev];
        prev = ev.frame;
        
        [self addSubview:ev];
        
        
        
        if (i == self.social_feeds.count - 1){
            CGRect frame = self.frame;
            
            frame.size.height = ev.frame.origin.y+ ev.frame.size.height;
            frame.size.width = config.screenWidth;
            self.frame = frame;
            
        }
        //[page appendView:ev withFrame:ev.frame];
        
        
    }
    
    
    
    
    [self.delegate social_finish_loading:self];
    
    
    
    //[Design department_social_page:page config:self.config];
    // page.updating = false;
    
}

/*
 -(void)display_twitter:(Config *)config{
 self.backgroundColor = [UIColor colorWithRed:159/255.0 green:196/255.0 blue:214/255.0 alpha:1];
 
 
 UILabel *logo = [[UILabel alloc] init];
 logo.font = [UIFont fontWithName:kFontAwesomeFamilyName size:55];
 logo.text = [NSString fontAwesomeIconStringForIconIdentifier:@"fa-twitter"];
 logo.textAlignment = NSTextAlignmentCenter;
 logo.textColor = [UIColor colorWithRed:151/255.0 green:186/255.0 blue:204/255.0 alpha:1];
 logo.frame = CGRectMake(config.screenWidth/2-30, 10, 60, 60);
 [self addSubview:logo];
 
 CGRect prev = CGRectMake(0, 70, 0, 0);
 for (int i=0;i<self.social_feeds.count;i++){
 
 
 NSMutableDictionary *vs = [[NSMutableDictionary alloc] init];
 
 NSDictionary *tw = [self.social_feeds objectAtIndex:i];
 
 
 
 ViewWithData *ev = [[ViewWithData alloc] init];
 ev.itemID = [tw objectForKey:@"id_str"];
 //ev.pageID = page.pageid;
 ev.backgroundColor = [UIColor whiteColor];
 [vs setObject:ev forKey:@"main"];
 
 UIImageView *icon = [[UIImageView alloc] init];
 icon.image = appicon;
 [ev addSubview:icon];
 [vs setObject:icon forKey:@"appicon"];
 
 UILabel *author = [[UILabel alloc] init];
 author.text = self.social_username;
 
 
 NSDateFormatter *df = [[NSDateFormatter alloc] init];
 //Wed Dec 01 17:08:03 +0000 2010
 [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
 NSDate *date = [df dateFromString:[tw objectForKey:@"created_at"]];
 [df setDateFormat:@"MMM dd"];
 NSString *dateStr = [df stringFromDate:date];
 
 NSString *str = [NSString stringWithFormat:@"%@   %@", self.social_username, dateStr];
 //NSLog(@"%d, %d, %d", self.social_username.length, dateStr.length, str.length);
 NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str];
 [attrstr addAttribute:NSFontAttributeName value:(id)[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, self.social_username.length)];
 [attrstr addAttribute:NSForegroundColorAttributeName value:(id)[UIColor blackColor] range:NSMakeRange(0, self.social_username.length)];
 [attrstr addAttribute:NSFontAttributeName value:(id)[UIFont systemFontOfSize:12] range:NSMakeRange(self.social_username.length, str.length-self.social_username.length)];
 [attrstr addAttribute:NSForegroundColorAttributeName value:(id)[UIColor lightGrayColor] range:NSMakeRange(self.social_username.length, str.length-self.social_username.length)];
 
 author.attributedText = attrstr;
 
 [ev addSubview:author];
 [vs setObject:author forKey:@"author"];
 
 
 
 UITextView *text = [[UITextView alloc] init];
 text.userInteractionEnabled = YES;
 text.scrollEnabled = NO;
 text.editable = NO;
 [ev addSubview:text];
 
 text.text = [tw objectForKey:@"text"];
 [vs setObject:text forKey:@"text"];
 
 
 
 UIView *shareview = [[UIView alloc] init];
 shareview.tag = 1;
 shareview.userInteractionEnabled = YES;
 LabelWithData *sharebtn = [[LabelWithData alloc] init];
 [shareview addSubview:sharebtn];
 sharebtn.userInteractionEnabled = YES;
 //sharebtn.text = icon_share;
 sharebtn.text = @"Share";
 
 UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(socialsel:)];
 tap.numberOfTapsRequired = 1;
 [sharebtn addGestureRecognizer:tap];
 sharebtn.sharetext = text.text;
 [ev addSubview:shareview];
 
 [vs setObject:shareview forKey:@"share_pane"];
 [vs setObject:sharebtn forKey:@"share_btn"];
 
 
 
 UIImageView *backimg = [[UIImageView alloc] init];
 //logoimg.backgroundColor = [UIColor blackColor];
 backimg.contentMode = UIViewContentModeScaleAspectFit;
 [ev addSubview:backimg];
 [vs setObject:backimg forKey:@"image"];
 
 NSString *imgurl = nil;
 NSArray *media = [[tw objectForKey:@"entities"] objectForKey:@"media"];
 
 if (media.count > 0){
 backimg.hidden = NO;
 
 imgurl = [[media objectAtIndex:0] objectForKey:@"media_url"];
 
 
 
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
 dispatch_async(queue, ^{
 
 
 
 NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]];
 UIImage *i = [UIImage imageWithData:data];
 CGSize newSize=CGSizeMake(i.size.width, i.size.height); // I am giving resolution 50*50 , you can change your need
 //NSLog(@"%f, %f", i.size.width, i.size.height);
 UIGraphicsBeginImageContext(newSize);
 [i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
 UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 float ratio = 480/719.0;
 
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
 backimg.image = nil;
 backimg.image = newImage;
 sharebtn.shareimg = backimg.image;
 });
 
 
 });
 
 
 } else {
 
 backimg.hidden = YES;
 }
 
 
 
 ev.subpages = vs;
 [Design department_twitter:vs config:config prevFrame:prev];
 prev = ev.frame;
 
 [self addSubview:ev];
 
 
 
 if (i == self.social_feeds.count - 1){
 CGRect frame = self.frame;
 
 frame.size.height = ev.frame.origin.y+ ev.frame.size.height;
 frame.size.width = config.screenWidth;
 self.frame = frame;
 
 }
 //[page appendView:ev withFrame:ev.frame];
 
 
 }
 
 
 
 
 [self.delegate social_finish_loading:self];
 
 
 
 //[Design department_social_page:page config:self.config];
 // page.updating = false;
 
 }*/


-(void)socialsel:(UITapGestureRecognizer *)ges{
    LabelWithData *v = (LabelWithData *)ges.view;
    
    [self.delegate socialsel:v];
    
    /*NSString *message = v.sharetext;
     UIImage *shareImage = v.shareimg;
     NSURL *shareUrl = [NSURL URLWithString:[v.shareurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     
     NSArray *activityItems = [NSArray arrayWithObjects:message, shareImage, shareUrl, nil];
     ;
     
     UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
     activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     
     [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed){
     if (completed){
     // [NSThread detachNewThreadSelector:@selector(send_user_share) toTarget:self withObject:nil];
     }
     }];
     
     [self presentViewController:activityViewController animated:YES completion:nil];*/
    
}






@end
