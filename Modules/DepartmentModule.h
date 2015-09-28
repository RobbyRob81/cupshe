//
//  DepartmentModule.h
//  Setup The Upset
//
//  Created by Hanqing Hu on 2/6/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "MultiPageView.h"
#import "MultiPageInfinateView.h"
#import "CollectionModule.h"
#import "SocialFeedModule.h"
#import "BillboardModule.h"
#import "Department.h"
@protocol DepartmentModuleDelegate;
@class DepartmentModuleView;
@interface DepartmentModule : UIView <UIScrollViewDelegate, NSURLConnectionDelegate, UITextFieldDelegate,MultiPageViewDelegate, MultiPageInfinateViewDelegate, CollectionModuleDelegate, SocialFeedModuleDelegate, BillboardModuleDelegate>{
    MultiPageView *finite;
    MultiPageInfinateView *infinite;
   
    CollectionModule *collection;
    NSMutableDictionary *searchwords;
    NSMutableArray *receivedData;
    
    
    NSMutableArray *module_threads;
    NSMutableArray *flow_layout;
    
    int typekey;
}

@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) UIView *return_view;
@property (nonatomic, strong) NSDictionary *design;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *stype_id;
@property (nonatomic, strong) Config *config;
@property (nonatomic, strong) id<DepartmentModuleDelegate> delegate;
-(void)build_department;
@end

@interface DepartmentModuleView :UIView
@property (nonatomic, strong) NSMutableArray *flow_layout;
@property int module_count;
@end


@protocol DepartmentModuleDelegate <NSObject>


-(void)department_finish_display:(DepartmentModule *)module;
@end

