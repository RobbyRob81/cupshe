//
//  CollectionModule.h
//  Ecommerce
//
//  Created by Hanqing Hu on 12/4/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "NSURLConnectionWithTag.h"
#import "Promotion.h"
@protocol CollectionModuleDelegate;
@class CollectionView;
@class CollectionViewDesign;
@interface CollectionModule : UIView <NSURLConnectionDelegate>{
    NSMutableArray *image_queue;
}

@property (nonatomic, strong) NSMutableArray *collections;

@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *groupby;
@property (nonatomic, strong) id parent;



@property (nonatomic, strong) id <CollectionModuleDelegate> delegate;
-(void)get_collection:(Config *)config department:(NSString *)department_id;
-(void)display_view;
-(void)update_image;
@end



@protocol CollectionModuleDelegate <NSObject>

-(void)collection_touched:(Promotion *)promo;
-(void)collection_finish_display:(CollectionModule *)module;
@end



@interface CollectionView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *gradient;
@property (nonatomic, strong) UITextView *desc;
@property (nonatomic, strong) UILabel *ends_on;
@property (nonatomic, strong) Promotion *promotion;
@end


@interface CollectionViewDesign : NSObject
@property (nonatomic, strong) NSMutableDictionary *design_view;
@property (nonatomic, strong) NSMutableDictionary *design_image;
@property (nonatomic, strong) NSMutableDictionary *design_desc_back;
@property (nonatomic, strong) NSMutableDictionary *design_desc;
@property (nonatomic, strong) NSMutableDictionary *design_ends_on;
@property (nonatomic, strong) NSMutableDictionary *design_gradient;
@property int column;
@property (nonatomic, strong) NSArray *column_spacing;
@end
