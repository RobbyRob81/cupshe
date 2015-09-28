//
//  BillboardModule.h
//  Ecommerce
//
//  Created by Hanqing Hu on 1/5/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Billboard.h"
#import "ViewWithData.h"
#import "Design.h"
#import "DDPageControl.h"
@protocol BillboardModuleDelegate;
@class BillboardDetailPage;
@interface BillboardModule : UIView <UIScrollViewDelegate, UIWebViewDelegate, DDPageControlDelegate>{
    NSMutableArray *image_queue;
    UIScrollView *scroll;
    DDPageControl *page;
    
    NSMutableArray *detail_pages;
}

@property (nonatomic, strong) NSMutableArray *billboards;

@property (nonatomic, strong) NSMutableDictionary *design_view;
@property (nonatomic, strong) NSMutableDictionary *design_preview;
@property (nonatomic, strong) NSMutableDictionary *design_desc_back;
@property (nonatomic, strong) NSMutableDictionary *design_title;
@property (nonatomic, strong) NSMutableDictionary *design_desc;
@property (nonatomic, strong) NSMutableDictionary *design_page_indicator;

@property (nonatomic, strong) UISwipeGestureRecognizer *toright;
@property (nonatomic, strong) UISwipeGestureRecognizer *toleft;

@property (nonatomic, strong) NSMutableArray *subvs;

@property (nonatomic, strong) id parent;

//module works when a user touches a billboard, the billboard assemble the detail page and present it to the delegate
@property (nonatomic, strong) id<BillboardModuleDelegate> delegate;


@property (nonatomic, strong) UIView *animationParent; //parent view to figure out animation. specific to calculate the touch point;


-(void)get_bilboard:(Config *)config department:(NSString *)department_id;
-(void)get_bilboard:(Config *)config;

@end




@protocol BillboardModuleDelegate <NSObject>

-(void)billboard_html_touched:(BillboardDetailPage *)detail_page;
-(void)billboard_product_touched:(Billboard *)b;
-(void)billboard_closed:(BillboardDetailPage *)detail_page;
-(void)billboard_finish_display:(BillboardModule *)module;
@end

@interface BillboardDetailPage : UIView

@property (nonatomic, strong) ImageWithData *backgroud_img;
@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, strong) UIButton *close;
@property (nonatomic, strong) NSString *billboard_id;
@property  CGPoint touchLocation; //find the initial touch point for animatino

@end
