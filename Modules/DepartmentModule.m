//
//  DepartmentModule.m
//  Setup The Upset
//
//  Created by Hanqing Hu on 2/6/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "DepartmentModule.h"
#import "ProductViewController.h"
const int PROMO_LOAD = 1;
const int WORD_LOAD = 2;
const int SOCIAL_LOAD = 3;
const int SOCIAL_IMAGE_LOAD = 4;
@implementation DepartmentModule

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)build_department{
    
    if (self.type == nil || self.type.length == 0 || [self.type isEqualToString:@"multipage"]){
        [self sync_load_word];
        typekey = 1;
        if ([self.config.departments count] <=3){
            
            finite = [[MultiPageView alloc] init];
            NSDictionary *designs = [self.config.design objectForKey:@"design"];
            NSMutableDictionary *design = [designs objectForKey:self.stype_id];
            [Design style:[[DOM alloc] initWithView:finite parent:nil] design:design config:self.config];
            finite.delegate = self;
            if ([self.config.departments count] > 1){
                finite.showTitle = YES;
            } else {
                finite.showTitle = NO;
            }
            NSMutableArray *keys = [[NSMutableArray alloc] init];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            NSMutableArray *types = [[NSMutableArray alloc] init];
            
            for (Department *d in self.config.departments){
                [keys addObject:d.department_id];
                [values addObject:[d.name uppercaseString]];
                if ([d.department_type isEqualToString:@"social"]){
                    [types addObject:[NSNumber numberWithBool:YES]];
                } else  [types addObject:[NSNumber numberWithBool:NO]];
            }
            
            //values = [NSMutableArray arrayWithObjects:@"Jewery",@"Women", nil];
            
            [finite createPagesWithTitles:values ids:keys types:types];
            
            [self addSubview:finite];
            //return finite;
        } else {
            
            infinite = [[MultiPageInfinateView alloc] init];
            NSDictionary *designs = [self.config.design objectForKey:@"design"];
            NSMutableDictionary *design = [designs objectForKey:self.stype_id];
            [Design style:[[DOM alloc] initWithView:infinite parent:nil] design:design config:self.config];
            infinite.delegate = self;
            if ([self.config.departments count] > 1){
                infinite.showTitle = YES;
            } else {
                infinite.showTitle = NO;
            }
            NSMutableArray *keys = [[NSMutableArray alloc] init];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            NSMutableArray *types = [[NSMutableArray alloc] init];
            for (Department *d in self.config.departments){
                [keys addObject:d.department_id];
                [values addObject:[d.name uppercaseString]];
                if ([d.department_type isEqualToString:@"social"]){
                    [types addObject:[NSNumber numberWithBool:YES]];
                } else  [types addObject:[NSNumber numberWithBool:NO]];
            }
            
            [infinite createPagesWithTitles:values ids:keys types:types];
            [self addSubview:infinite];
            
            //return infinite;
        }
    } else {
        //we level of views, DepartmentModuleView.flow_layout keeps track of it's subview's loading and positioning. After all is loaded, the flow_layout tracks the parent view's layout
        
        NSDictionary *designs = [self.config.design objectForKey:@"design"];
        NSMutableDictionary *design = [designs objectForKey:self.stype_id];
        [Design style:[[DOM alloc] initWithView:self parent:nil] design:design config:self.config];
        
        flow_layout = [[NSMutableArray alloc] init];
        module_threads = [[NSMutableArray alloc] init];
        for (Department *d in self.config.departments){
            if ([d.department_type isEqualToString:@"product"]){
                DepartmentModuleView *dmv = [[DepartmentModuleView alloc] init];
                CGRect frame = dmv.frame;
                frame.size.width = self.config.screenWidth;
                dmv.frame = frame;
                DOM *dmvdom = [[DOM alloc] initWithView:dmv parent:self];
                [flow_layout addObject:dmvdom];
                [module_threads addObject:dmv];
                [self load_promotion:d inView:dmv];
            }
        }
        //return scroll;
    }
    //return nil;
}



-(void)pageNeedsUpdate:(MPPage *)page{
    if (page.updating == true) return;
    [page pageReset];
    page.updating = true;
    if (finite != nil)
        [finite startUpdatePage:page];
    if (infinite != nil) [infinite startUpdatePage:page];
    Department *d = nil;
    for (Department *dep in self.config.departments){
        if ([page.pageid isEqualToString:[dep department_id]]){
            d = dep;
        }
    }
    if ([d.department_type isEqualToString:@"product"]){
        //[NSThread detachNewThreadSelector:@selector(load_promotion:) toTarget:self withObject:page];
        [self load_promotion:page];
        
    } else {
        [self loadsocial:d page:page];
    }
}
-(void)mpSearchDidSearch:(NSString *)terms inPage:(MPPage *)page{
    ProductViewController *pv = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    pv.config = self.config;
    pv.searchTerm = terms;
    pv.departmentid = page.pageid;
    pv.titleText = [NSString stringWithFormat:@"\"%@\"", terms];
    [self.parent.navigationController pushViewController:pv animated:YES];
    
}
-(NSArray *)mpSearchChanged:(NSString *)terms inPage:(MPPage *)page{
    NSMutableArray *display = [[NSMutableArray alloc] init];
    if (searchwords == nil || searchwords.count == 0) return display;
    NSArray *words = [searchwords objectForKey:page.pageid];
    
    for(NSString *curString in words) {
        NSString *dstr =[NSString stringWithFormat:@"%@", curString];
        NSString *str = [dstr lowercaseString];
        terms = [terms lowercaseString];
        if (str != nil && ![ str isKindOfClass:[NSNull class]] && str.length > 0){
            NSRange substringRange = [str rangeOfString:terms];
            if (substringRange.location == 0) {
                [display addObject:dstr];
            }
        }
    }
    
    return display;
}
-(void)pageNeedsRefresh:(MPPage *)page{
    //[pages startUpdatePage:page];
    if (page.updating == YES) return;
    [page pageReset];
    page.updating = YES;
    int deptype = 0;
    Department *social = nil;
    for (Department *d in self.config.departments){
        if ([d.department_id isEqualToString:page.pageid]){
            if ([d.department_type isEqualToString:@"product"]) deptype = 0;
            else {
                deptype = 1;
                social = d;
            };
        }
    }
    
    if (deptype == 0)
        //[NSThread detachNewThreadSelector:@selector(load_promotion:) toTarget:self withObject:page];
        
        [self load_promotion:page];
    
    else [self loadsocial:social page:page];
    
}
-(void)sync_load_word{
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@", self.config.APP_UUID];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GET_SEARCH_WORD]]];
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    searchwords= [dic objectForKey:@"search_words"];
}
-(void)load_word{
    NSString *myRequestString = [NSString stringWithFormat:@"app_uuid=%@", self.config.APP_UUID];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@%@", self.config.API_ROOT, self.config.API_GET_SEARCH_WORD]]];
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    
    
    NSMutableData *received = [receivedData objectAtIndex:WORD_LOAD];
    [received setLength:0];
    NSURLConnectionWithTag *urlConnection = [[NSURLConnectionWithTag alloc] initWithRequest:request delegate:self tag:WORD_LOAD];
    
}

-(void)load_promotion:(MPPage *)page{
    
    
    module_threads = [[NSMutableArray alloc] init];
    
    if ([self.config.design objectForKey:@"components"] == nil) return;
    
    NSArray *comps = [self.design objectForKey:@"components"];
    flow_layout = [[NSMutableArray alloc] init];
    //keep track of previous add component. it's a flow layout so they need to know where the last component was
    for (int i = 0 ; i < comps.count; i++){
        NSDictionary *comp = [comps objectAtIndex:i];
        NSString *type = [comp objectForKey:@"type"];
        if ([type isEqualToString:@"UILabel"]){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            UILabel *label = [[UILabel alloc] init];
            label.text = [comp objectForKey:@"content"];
            DOM *label_dom = [[DOM alloc] initWithView:label parent:page];
            [Design style:label_dom design:designs config:self.config];
            
            [flow_layout addObject:label_dom];
            
            
        }
        else if ([type isEqualToString:@"CollectionModule"]){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            NSArray *component = [comp objectForKey:@"components"];
            NSString *type = [comp objectForKey:@"collection_type"];
            CollectionModule *col = [[CollectionModule alloc] init];
            col.components = component;
            col.type = type;
            col.delegate = self;
            DOM *coldom = [[DOM alloc] initWithView:col parent:page];
            [Design style:coldom design:designs config:self.config];
            
            // [col sync_get_collection:self.config department:page.pageid];
            NSLog(@"%f", col.frame.size.height);
            
            [flow_layout addObject:coldom];
            [module_threads addObject:coldom];
        }
        else if ([type isEqualToString:@"BillboardModule"]){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            
            BillboardModule *bill = [[BillboardModule alloc] init];
            
            bill.delegate = self;
            bill.animationParent = self;
            bill.parent = self.parent;
            DOM *billdom = [[DOM alloc] initWithView:bill parent:page];
            [Design style:billdom design:designs config:self.config];
            
            NSLog(@"%f, %f, %f, %f", bill.frame.origin.x, bill.frame.origin.y, bill.frame.size.height, bill.frame.size.width);
            NSDictionary *compstyle = [comp objectForKey:@"component_styles"];
            bill.design_view = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"view"]];
            bill.design_preview = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"preview_image"]];
            bill.design_title = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"title"]];
            bill.design_desc_back = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"description_background"]];
            bill.design_desc = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"description"]];
            bill.design_page_indicator = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"page_indicator"]];
            
            //[bill sync_get_bilboard:self.config department:page.pageid];
            
            
            [flow_layout addObject:billdom];
            [module_threads addObject:billdom];
        }
    }
    
    
    
    for (DOM *d in flow_layout){
        if ([d.view isKindOfClass:[CollectionModule class]]){
            CollectionModule *col = (CollectionModule *)d.view;
            [col get_collection:self.config department:page.pageid];
        } else if ([d.view isKindOfClass:[BillboardModule class]]){
            BillboardModule *bill = (BillboardModule *)d.view;
            [bill get_bilboard:self.config department:page.pageid];
            
        } else {
            [self not_module_finish_display:d];
        }
        
    }
    
    
    page.hasMoreData = false;
    [page stopRefresh];
    page.updating = false;
    
    
    if (finite != nil)
        [finite endUpdatePage:page];
    if (infinite != nil) [infinite endUpdatePage:page];
    
}

-(void)load_promotion:(Department *)dep inView:(DepartmentModuleView *)view{
    //each DepartmentModuleview need to track its sub view
    view.flow_layout = [[NSMutableArray alloc] init];
    view.module_count = 0;
    if ([self.config.design objectForKey:@"components"] == nil) return;
    
    NSArray *comps = [self.design objectForKey:@"components"];
    
    //keep track of previous add component. it's a flow layout so they need to know where the last component was
    for (int i = 0 ; i < comps.count; i++){
        NSDictionary *comp = [comps objectAtIndex:i];
        NSString *type = [comp objectForKey:@"type"];
        if ([type isEqualToString:@"Title"] && self.config.departments.count > 1){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            UILabel *label = [[UILabel alloc] init];
            label.text = dep.name;
            DOM *label_dom = [[DOM alloc] initWithView:label parent:view];
            [Design style:label_dom design:designs config:self.config];
            
            [view.flow_layout addObject:label_dom];
            view.module_count++;
        } if ([type isEqualToString:@"Title Holder"] && self.config.departments.count == 1){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            UILabel *label = [[UILabel alloc] init];
            
            DOM *label_dom = [[DOM alloc] initWithView:label parent:view];
            [Design style:label_dom design:designs config:self.config];
            
            [view.flow_layout addObject:label_dom];
            view.module_count++;
        }
        else if ([type isEqualToString:@"UILabel"]){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            UILabel *label = [[UILabel alloc] init];
            label.text = [comp objectForKey:@"content"];
            DOM *label_dom = [[DOM alloc] initWithView:label parent:view];
            [Design style:label_dom design:designs config:self.config];
            
            [view.flow_layout addObject:label_dom];
            view.module_count++;
        }
        else if ([type isEqualToString:@"CollectionModule"]){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            NSArray *component = [comp objectForKey:@"components"];
            NSString *type = [comp objectForKey:@"collection_type"];
            CollectionModule *col = [[CollectionModule alloc] init];
            col.components = component;
            col.type = type;
            col.delegate = self;
            col.parent = view;
            DOM *coldom = [[DOM alloc] initWithView:col parent:view];
            [Design style:coldom design:designs config:self.config];
            // [col sync_get_collection:self.config department:page.pageid];
            NSLog(@"%f", col.frame.size.width);
            
            [view.flow_layout addObject:coldom];
            view.module_count++;
        }
        else if ([type isEqualToString:@"BillboardModule"]){
            NSString *css = [comp objectForKey:@"style_id"];
            NSDictionary *designs = [[self.config.design objectForKey:@"design"] objectForKey:css];
            
            BillboardModule *bill = [[BillboardModule alloc] init];
            
            bill.delegate = self;
            bill.animationParent = self;
            bill.parent = self.parent;
            DOM *billdom = [[DOM alloc] initWithView:bill parent:view];
            [Design style:billdom design:designs config:self.config];
            
            NSLog(@"%f, %f, %f, %f", bill.frame.origin.x, bill.frame.origin.y, bill.frame.size.height, bill.frame.size.width);
            NSDictionary *compstyle = [comp objectForKey:@"component_styles"];
            bill.design_view = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"view"]];
            bill.design_preview = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"preview_image"]];
            bill.design_title = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"title"]];
            bill.design_desc_back = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"description_background"]];
            bill.design_desc = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"description"]];
            bill.design_page_indicator = [[self.config.design objectForKey:@"design"] objectForKey:[compstyle objectForKey:@"page_indicator"]];
            
            //[bill sync_get_bilboard:self.config department:page.pageid];
            
            
            [view.flow_layout addObject:billdom];
            view.module_count++;
        }
    }
    for (DOM *d in view.flow_layout){
        if ([d.view isKindOfClass:[CollectionModule class]]){
            CollectionModule *col = (CollectionModule *)d.view;
            [col get_collection:self.config department:dep.department_id];
        } else if ([d.view isKindOfClass:[BillboardModule class]]){
            BillboardModule *bill = (BillboardModule *)d.view;
            [bill get_bilboard:self.config department:dep.department_id];
            
        } else {
            [self not_module_finish_display:d];
        }
        
    }
    
    
    
    
}
-(void)not_module_finish_display:(DOM *)view{
    if (typekey == 1){
        for (int i = 0 ; i < module_threads.count; i++){
            DOM *d = [module_threads objectAtIndex:i];
            if (d == view){
                [module_threads removeObjectAtIndex:i];
                
                if (module_threads.count == 0) [self module_finish_loading:(MPPage *)d.parent];
                break;
            }
        }
    } else {
        
        DepartmentModuleView *dmv = (DepartmentModuleView *)view.parent;
        dmv.module_count--;
        if (dmv.module_count == 0) [self module_finish_loading_in_view:dmv];
        NSLog(@"%d", dmv.module_count);
    }
}
-(void)collection_finish_display:(CollectionModule *)module{
    if (typekey == 1){
        for (int i = 0 ; i < module_threads.count; i++){
            DOM *d = [module_threads objectAtIndex:i];
            if (d.view == module){
                [module_threads removeObjectAtIndex:i];
                
                if (module_threads.count == 0) [self module_finish_loading:(MPPage *)d.parent];
                break;
            }
        }
    } else {
        
        DepartmentModuleView *dmv = (DepartmentModuleView *)module.parent;
        dmv.module_count--;
        if (dmv.module_count == 0) [self module_finish_loading_in_view:dmv];
    }
}
-(void)billboard_finish_display:(BillboardModule *)module{
    
    if (module.billboards.count > 1){
        if (finite != nil) {[finite blocking_gesture:module];}
        if (infinite != nil) {[infinite blocking_gesture:module];}
    }
    
    if (typekey == 1){
        for (int i = 0 ; i < module_threads.count; i++){
            DOM *d = [module_threads objectAtIndex:i];
            if (d.view == module){
                [module_threads removeObjectAtIndex:i];
                //NSLog(@"2***");
                if (module_threads.count == 0) {
                    [self module_finish_loading:(MPPage *)d.parent];
                }
                break;
            }
        }
    } else {
        DepartmentModuleView *dmv = (DepartmentModuleView *)module.parent;
        dmv.module_count--;
        if (dmv.module_count == 0) [self module_finish_loading_in_view:dmv];
    }
}
-(void)module_finish_loading:(MPPage *)page{
    [Design flow_layout:flow_layout parent:page config:self.config];
    for (DOM *d in flow_layout){
        if (typekey == 1)
            [page appendView:(UIView *)d.view withFrame:((UIView *)d.view).frame];
        else [self addSubview:d.view];
    }
    
    if (finite != nil) {
        self.frame = finite.frame;
        [self.delegate department_finish_display:self];
    }
    else {
        self.frame = infinite.frame;
        [self.delegate department_finish_display:self];
    }
    
}

-(void)module_finish_loading_in_view:(DepartmentModuleView *)view{
    [Design flow_layout:view.flow_layout parent:view config:self.config];
    CGRect frame = view.frame;
    for (DOM *d in view.flow_layout){
        UIView *dview = (UIView *)d.view;
        
        [view addSubview:dview];
        frame.size.height = dview.frame.origin.y+dview.frame.size.height;
        view.frame = frame;
        
    }
    for (int i = 0 ; i < module_threads.count; i++){
        DepartmentModuleView *v = [module_threads objectAtIndex:i];
        if (v == view) {
            [module_threads removeObjectAtIndex:i];
            break;
        }
    }
    if (module_threads.count == 0){
        [Design flow_layout:flow_layout parent:self config:self.config];
        for (DOM *dv in flow_layout){
            UIView *v = (UIView *)dv.view;
            [self addSubview:v];
            CGRect frame = self.frame;
            frame.size.height = v.frame.origin.y+v.frame.size.height;
            self.frame = frame;
            
        }
        
        
        [self.delegate department_finish_display:self];
    }
    
}


-(void)collection_touched:(Promotion *)promo{
    // NSString *filter = @"";
    //NSString *t = @"Shop";
    
    if (finite != nil)
        [finite pageResign];
    if (infinite!=nil)[infinite pageResign];
    ProductViewController *pv = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    pv.config = self.config;
    pv.filter = promo.product_filter;
    pv.departmentid = promo.departmentid;
    pv.titleText = promo.title;
    [self.parent.navigationController pushViewController:pv animated:YES];
}



-(void)loadsocial:(Department *)dep page:(MPPage *)page{
    
    
    
    NSMutableArray *flow_layout = [[NSMutableArray alloc] init];
    //keep track of previous add component. it's a flow layout so they need to know where the last component was
    
    NSString *url = [dep.content_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //if (scm != nil) [scm removeFromSuperview];
    
    SocialFeedModule *scm = [[SocialFeedModule alloc] init];
    scm.delegate = self;
    scm.super_view = page;
    scm.base_url = dep.image_url;
    scm.feed_type = dep.department_id;
    scm.social_username = dep.social_username;
    
    
    
    [scm get_social_feed:[NSURL URLWithString: url] config:self.config];
    
    
    
    
}

-(void)social_finish_loading:(SocialFeedModule *)module{
    MPPage *page = (MPPage *)module.super_view;
    [page appendView:module withFrame:module.frame];
    
    NSLog(@"%f, %f, %f, %f", module.frame.origin.x, module.frame.origin.y, module.frame.size.width, module.frame.size.height);
    page.hasMoreData = false;
    [page stopRefresh];
    page.updating = false;
    
    
    if (finite != nil)
        [finite endUpdatePage:page];
    if (infinite != nil) [infinite endUpdatePage:page];
    
    
}

-(void)billboard_html_touched:(BillboardDetailPage *)detail_page{
    detail_page.hidden = NO;
    detail_page.frame = CGRectMake(self.config.screenWidth/2, detail_page.touchLocation.y, 0, 0);
    [self.parent.view addSubview:detail_page];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         detail_page.frame = CGRectMake(0, 0, self.config.screenWidth, self.config.screenHeight);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}
-(void)billboard_product_touched:(Billboard *)b{
    NSString *t = @"Shop";
    
    if (finite != nil)
        [finite pageResign];
    if (infinite!=nil)[infinite pageResign];
    ProductViewController *pv = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
    pv.config = self.config;
    pv.filter = b.product_filter;
    pv.departmentid = b.department_id;
    pv.titleText = t;
    [self.parent.navigationController pushViewController:pv animated:YES];
}
-(void)billboard_closed:(BillboardDetailPage *)detail_page{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         detail_page.frame = CGRectMake(self.config.screenWidth/2, detail_page.touchLocation.y, 0, 0);
                     }
                     completion:^(BOOL finished){
                         detail_page.hidden = YES;
                         [detail_page removeFromSuperview];
                     }];
    
}


-(void)socialsel:(LabelWithData *)v{
    
    NSString *message = v.sharetext;
    UIImage *shareImage = v.shareimgView.image;
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
    
    [self.parent presentViewController:activityViewController animated:YES completion:nil];
    
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    @try {
        
        //NSMutableData *received = [receivedData objectAtIndex:conn.tag];
        //[received appendData:data];
        [conn.receivedData appendData:data];
        
    }
    @catch (NSException *exception) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong..." message:@"Please try again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        [alert show];
        
        if (finite != nil)
            [finite endUpdatePage:conn.page];
        if (infinite!=nil)[infinite endUpdatePage:conn.page];
        [conn.page stopRefresh];
        
    }
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    if (finite != nil)
        [finite endUpdatePage:conn.page];
    if (infinite!=nil)[infinite endUpdatePage:conn.page];
    [conn.page stopRefresh];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSURLConnectionWithTag *conn = (NSURLConnectionWithTag *)connection;
    NSMutableData *received = [receivedData objectAtIndex:conn.tag];
    
    @try {
        if (conn.tag == WORD_LOAD){
            NSString *myxml = [[NSString alloc] initWithData:conn.receivedData encoding:NSASCIIStringEncoding];
            NSLog(@"%@", myxml);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:conn.receivedData options:0 error:nil];
            searchwords= [dic objectForKey:@"search_words"];
            
            
        }
        
    }
    @catch (NSException *exception) {
        //NSLog(exception.description);
        [conn.page stopRefresh];
        if (finite != nil)
            [finite endUpdatePage:conn.page];
        if (infinite!=nil)[infinite endUpdatePage:conn.page];
    }
    @finally {
        
        //searchBarState = 0;
    }
    
}



@end


@implementation DepartmentModuleView



@end
