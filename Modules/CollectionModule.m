 //
//  CollectionModule.m
//  Ecommerce
//
//  Created by Hanqing Hu on 12/4/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "CollectionModule.h"
#import "ViewWithData.h"
#import "Design.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
#import "NSURLConnectionBlock.h"
@implementation CollectionModule

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)get_collection:(Config *)config department:(NSString *)department_id{
    if (self.type == nil || self.type.length == 0) self.type = @"null";
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@&department=%@&type=%@", config.APP_UUID, department_id, self.type];
    
    NSLog(@"%@", myRequestString);
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", config.API_ROOT, config.API_PROMOTION]]];
    
    NSLog(@"%@", request.description);
    
    
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
            
            self.collections = nil;
            self.collections = [[NSMutableArray alloc] init];
            
            
            if (returnData != nil && ![returnData isKindOfClass:[NSNull class]]){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
                NSArray *a = [dic objectForKey:@"promotions"];
                
                NSMutableArray *ps = [[NSMutableArray alloc] init];
                for (NSDictionary *d in a){
                    Promotion *e = [[Promotion alloc] init];
                    [e promotion_from_dictionary:d];
                    [ps addObject:e];
                    [self.collections addObject:e];
                    // [promos addObject:e];
                }
            }
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            [self build_component:config];
            //});

            
        } else {
            //There was an error
            NSLog(@"%@", err.description);
        }
        
    };
    [connection start];
    
    
    
    
}
/*the group structure is as follows:
 {"groups":[{"name":"shirt", collections:[]}]}
 
 */

-(void)build_component:(Config *)config{
    //figure out grouping
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    if ([self.groupby isEqualToString:@"category"]){
        for (Promotion *p in self.collections){
            if (![self search_group:groups andAdd:p ofName:p.category]){
                [groups addObject:[self construct_group_with:p withName:p.category]];
            }
        }
    } else {
        NSMutableDictionary *g = [[NSMutableDictionary alloc] init];
        [g setObject:@"" forKey:@"name"];
        [g setObject:self.collections forKey:@"collections"];
        [groups addObject:g];
    }
    
    image_queue = [[NSMutableArray alloc] init];
    //figure out components and build view
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (NSDictionary *g in groups){
        for (NSDictionary *c in self.components){
            NSString *type = [c objectForKey:@"type"];
            if ([type isEqualToString:@"group title"]){
                UILabel *title = [[UILabel alloc] init];
                title.text = [g objectForKey:@"name"];
                
                DOM *d = [[DOM alloc] initWithView:title parent:self];
                [Design style:d design:[[config.design objectForKey:@"design"] objectForKey:[c objectForKey:@"style_id"]] config:config];
                [self addSubview:title];
                [views addObject:d];
            }
            if ([type isEqualToString:@"all collections"]){
                CollectionViewDesign *design = [self getCollectionViewDesign:c withConfig:config];
                UIView *v = [self display_view:config withCollecitons:[g objectForKey:@"collections"] design:design];
                DOM *d = [[DOM alloc] initWithView:v parent:self];
                [Design style:d design:[[config.design objectForKey:@"design"] objectForKey:[c objectForKey:@"style_id"]] config:config];
                [self addSubview:v];
                [views addObject:d];
            }
            if ([type isEqualToString:@"featured"]){
                CollectionViewDesign *design = [self getCollectionViewDesign:c withConfig:config];
                NSMutableArray *featured = [[NSMutableArray alloc] init];
                for (Promotion *p in [g objectForKey:@"collections"]){
                    if ([p.type isEqualToString:@"featured"]) [featured addObject:p];
                }
                UIView *v =[self display_view:config withCollecitons:featured design:design];
                DOM *d = [[DOM alloc] initWithView:v parent:self];
                [Design style:d design:[[config.design objectForKey:@"design"] objectForKey:[c objectForKey:@"style_id"]] config:config];
                NSLog(@"%f", v.frame.size.height);
                [self addSubview:v];
                [views addObject:d];
            }
            if ([type isEqualToString:@"default"]){
                CollectionViewDesign *design = [self getCollectionViewDesign:c withConfig:config];
                NSMutableArray *defaultpromo = [[NSMutableArray alloc] init];
                for (Promotion *p in [g objectForKey:@"collections"]){
                    if (p.type==nil || p.type.length == 0 || [p.type isEqualToString:@"default"]) [defaultpromo addObject:p];
                }
                UIView *v =[self display_view:config withCollecitons:defaultpromo design:design];
                DOM *d = [[DOM alloc] initWithView:v parent:self];
                [Design style:d design:[[config.design objectForKey:@"design"] objectForKey:[c objectForKey:@"style_id"]] config:config];
                [self addSubview:v];
                [views addObject:d];
            }
        }
    }
    [Design flow_layout:views parent:self config:config];
    if (views.count > 0){
        CGRect frame = self.frame;
        DOM *lastdom = [views objectAtIndex:views.count-1];
        UIView *last = lastdom.view;
        frame.size.height = last.frame.origin.y+last.frame.size.height;
        
        self.frame = frame;
    }
    [self load_images];
    [self.delegate collection_finish_display:self];
    
}

-(CollectionViewDesign *)getCollectionViewDesign:(NSDictionary *)component withConfig:(Config *)config{
    CollectionViewDesign *col = [[CollectionViewDesign alloc] init];
    NSDictionary *style = [component objectForKey:@"style"];
    col.design_view = [[config.design objectForKey:@"design"] objectForKey:[style objectForKey:@"view"]];
    col.design_image = [[config.design objectForKey:@"design"] objectForKey:[style objectForKey:@"image"]];
    col.design_desc_back = [[config.design objectForKey:@"design"] objectForKey:[style objectForKey:@"description_background"]];
    col.design_desc = [[config.design objectForKey:@"design"] objectForKey:[style objectForKey:@"description"]];
    col.design_ends_on = [[config.design objectForKey:@"design"] objectForKey:[style objectForKey:@"ends_on"]];
    col.design_gradient = [[config.design objectForKey:@"design"] objectForKey:[style objectForKey:@"gradient"]];
    col.column = [[component objectForKey:@"column"] intValue];
    col.column_spacing = [component objectForKey:@"column_spacing"];
    return col;
}

-(BOOL)search_group:(NSMutableArray *)groups andAdd:(Promotion *)p ofName:(NSString *)name {
    for (NSMutableDictionary *g in groups){
        NSString *gname = [g objectForKey:@"name"];
        if ([gname isEqualToString:name]){
            NSMutableArray *cols = [g objectForKey:@"collections"];
            [cols addObject:p];
            return true;
        }
    }
    return false;
}

-(NSMutableDictionary *)construct_group_with:(Promotion *)p withName:(NSString *)name{
    NSMutableDictionary *g = [[NSMutableDictionary alloc] init];
    [g setObject:name forKey:@"name"];
    NSMutableArray *cols = [[NSMutableArray alloc] init];
    [cols addObject:p];
    [g setObject:cols forKey:@"collections"];
    return g;
}



-(UIView *)display_view:(Config *)config withCollecitons:(NSArray *)cols design:(CollectionViewDesign *)design{
    UIView *component_view = [[UIView alloc] init];
    component_view.userInteractionEnabled = YES;
    if (cols == nil || [cols isKindOfClass:[NSNull class]]) return component_view;
    NSMutableArray *subvs = [[NSMutableArray alloc] init];
    
    for (int i=0;i<cols.count;i++){
        UIView *prev = nil;
        if (i > 0) prev = [subvs objectAtIndex:i-1];
        
        Promotion *e = [cols objectAtIndex:i];
        
        CollectionView *ev = [[CollectionView alloc] init];
       
        ev.promotion = e;
        ev.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [ev addGestureRecognizer:singleTap];
        //figure out column alignment
        CGRect frame = ev.frame;
        frame.origin.x = self.frame.size.width/design.column * (i%design.column);
        frame.size.width = self.frame.size.width/design.column;
        if (i/design.column > 0){
            UIView *prev = [subvs objectAtIndex:i-design.column];
            frame.origin.y = prev.frame.origin.y+prev.frame.size.height;
        }
        //figure out column row and col spacing
        if (design.column_spacing != nil){
            float col_spacing = [[design.column_spacing objectAtIndex:0] floatValue];
            float row_spacing = [[design.column_spacing objectAtIndex:1] floatValue];
            float first_row = [[design.column_spacing objectAtIndex:2] floatValue];
            if (i/design.column > 0){
                frame.origin.y += row_spacing;
            } else {
                frame.origin.y += first_row;
            }
            if (design.column <= 1){
                frame.origin.x += col_spacing;
                frame.size.width -= col_spacing*2;
            } else {
                if (i%design.column == 0){
                    frame.origin.x += col_spacing;
                    frame.size.width -= col_spacing/2+col_spacing;
                }
                if (i%design.column == design.column - 1){
                    frame.origin.x += col_spacing/2;
                    frame.size.width -= col_spacing + col_spacing/2;
                }
                if (i%design.column != 0 && i%design.column != design.column - 1) {
                    frame.origin.x += col_spacing/2;
                    frame.size.width -= col_spacing/2 + col_spacing/2;
                }
            }
        }
        ev.frame = frame;
        [Design style:[[DOM alloc] initWithView:ev parent:self] design:design.design_view config:config];
        [subvs addObject:ev];
        
        
        
        
        
       
        
        ImageWithData *backimg = [[ImageWithData alloc] init];
        backimg.tag = 1;
        //logoimg.backgroundColor = [UIColor blackColor];
        backimg.contentMode = UIViewContentModeScaleAspectFit;
        
        [Design style:[[DOM alloc] initWithView:backimg parent:ev] design:design.design_image config:config];
        [Design style:[[DOM alloc] initWithView:backimg parent:backimg] design:design.design_gradient config:config];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(backimg.frame.size.width/2 - indicator.frame.size.width/2, backimg.frame.size.height/2 - indicator.frame.size.height/2, indicator.frame.size.width, indicator.frame.size.height);
        indicator.hidesWhenStopped = YES;
        [indicator startAnimating];
        backimg.indicator = indicator;
        [ev addSubview:indicator];
        
        [ev addSubview:backimg];
        
       
        NSString *url = [e.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (url.length > 0){
            backimg.url = [NSURL URLWithString:url];
            backimg.item_id = e.promotion_id;
            [image_queue addObject:backimg];
        }
        
        /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSString *url = [e.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *img = [NSString stringWithFormat:@"%@", url];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
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
                backimg.image = nil;
                backimg.image = newImage;
            });
        });*/
        
        // frame = CGRectMake(ev.frame.size.width-180, ev.frame.size.height/2, 180, ev.frame.size.height/2-10);
        
        if (e.show_preview_text == 1){
            UIView *tv = [[UIView alloc] init];
            [Design style:[[DOM alloc] initWithView:tv parent:ev] design:design.design_desc_back config:config];
        
        
        
            UITextView *text = [[UITextView alloc] init];
        
            text.userInteractionEnabled = NO;
            text.scrollEnabled = NO;
            text.text = e.title;
            [Design style:[[DOM alloc] initWithView:text parent:tv] design:design.design_desc config:config];
        
            [tv addSubview:text];
        
            UILabel *end = [[UILabel alloc] init];
            end.tag = 4;
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *enddate = [format dateFromString:e.enddate];
            [format setDateFormat:@"MM/dd/yyyy"];
            NSString *ed = [format stringFromDate:enddate];
            if (ed != nil){
                end.text = [NSString stringWithFormat:@"%@: %@", [config localisedString:@"Ends on"], ed];
            }
            [tv addSubview:end];
            [Design style:[[DOM alloc] initWithView:end parent:tv] design:design.design_ends_on config:config];
            if (e.title == nil || e.title.length == 0) tv.hidden = YES;
            [ev addSubview:tv];
        }
        [component_view addSubview:ev];
        
    }
    if (subvs.count > 0){
        CGRect frame = self.frame;
        UIView *last = [subvs objectAtIndex:subvs.count-1];
        frame.size.height = last.frame.origin.y+last.frame.size.height;
        component_view.frame = frame;
    }
    
    return component_view;
    /*if (self.subviews.count > 0){
        CGRect frame = self.frame;
        UIView *last = [self.subviews objectAtIndex:self.subviews.count-1];
        frame.size.height = last.frame.origin.y+last.frame.size.height;
        self.frame = frame;
    }*/
    
}

-(void)singleTap:(UITapGestureRecognizer *)ges{
    CollectionView *v = (CollectionView *)ges.view;
    [self.delegate collection_touched:v.promotion];
}

-(void)load_images{
    for (ImageWithData *img in image_queue){
        
        
        [Config loadImageURL:[img.url absoluteString] toImageView:img withCacheKey:[img.url absoluteString] trim:YES sizeMultiplyer:1 completion:^{
            [img.indicator stopAnimating];
        }];
     /*  [[SDImageCache sharedImageCache] queryDiskCacheForKey:key done:^(UIImage *image, SDImageCacheType cacheType) {
           if (image != nil){
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   img.image = nil;
                   img.image = image;
               });
           } else {
               [SDWebImageDownloader.sharedDownloader downloadImageWithURL:img.url
                                                                   options:0
                                                                  progress:^(NSInteger receivedSize, NSInteger expectedSize)
                {
                    // progression tracking code
                }
                                                                 completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                {
                    if (image && finished)
                    {
                        CGSize newSize=CGSizeMake(image.size.width, image.size.height);
                        
                        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                        
                        float ratio = img.frame.size.height/img.frame.size.width;
                        
                        if (newSize.height/newSize.width < ratio){
                            
                            CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(newSize.width/2-newSize.height/ratio/2, 0, newSize.height/ratio, newSize.height));
                            //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                            //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                            newImage = [UIImage imageWithCGImage:imageref];
                            CGImageRelease(imageref);
                        } else if (newSize.height/newSize.width > ratio) {
                            CGImageRef imageref = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, newSize.height/2-newSize.width*ratio/2, newSize.width, newSize.width*ratio));
                            //[i drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                            //UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                            newImage = [UIImage imageWithCGImage:imageref];
                            CGImageRelease(imageref);
                            
                        }
                        
                        
                        //[self forceImageDecompression:image];
                        image = nil;
                        data = nil;
                        // do something with image
                        dispatch_async(dispatch_get_main_queue(), ^{
                            img.image = nil;
                            img.image = newImage;
                            [[SDImageCache sharedImageCache] storeImage:newImage forKey:key];
                        });
                    }
                }];
           }
        }];*/
        
        
        
        
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

@implementation CollectionView



@end

@implementation CollectionViewDesign



@end
