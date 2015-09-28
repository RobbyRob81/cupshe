//
//  PromotionViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/25/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "MultiPageView.h"
#import "MultiPageInfinateView.h"
#import "CollectionModule.h"
#import "SocialFeedModule.h"
#import "BillboardModule.h"
#import "DepartmentModule.h"
#import "PopUpModule.h"
@class SubScroll;
@class ViewWithID;
@class LabelWithID;
@interface PromotionViewController : UIViewController <UIScrollViewDelegate, NSURLConnectionDelegate, UITextFieldDelegate,MultiPageViewDelegate, MultiPageInfinateViewDelegate, CollectionModuleDelegate, SocialFeedModuleDelegate, BillboardModuleDelegate, DepartmentModuleDelegate> {
    
    UILabel *cartbtn;
    //MultiPageView *pages;
    MultiPageView *finite;
    MultiPageInfinateView *infinite;
    CollectionModule *collection;
    PopUpModule *popup;
    
    NSMutableArray *receivedData;
    
    
    NSMutableDictionary *searchwords;
    
    NSMutableArray *module_threads;
    int module_count;
    NSMutableArray *flow_layout;
    
    UIScrollView *scroll;
    UIRefreshControl *refresh;
   
  
    int hasmore;
   
}
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) NSMutableArray *promotions;

-(void)itemsel:(UITapGestureRecognizer *)ges;
-(IBAction)done:(id)sender;
-(void)refresh_badge;

@end




