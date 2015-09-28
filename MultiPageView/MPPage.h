//
//  MPPage.h
//  Ecommerce
//
//  Created by apple on 14-8-11.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPSearchBar.h"
@protocol MPPageDelegate;
@interface MPPage : UIView <UIScrollViewDelegate> {
    //UIScrollView *scroll;
    UIView *content;
    //MPSearchBar *searchBar;
    UIActivityIndicatorView *indicator;
    UIRefreshControl *refresh;
    CGFloat height;
    BOOL resetting;
}

@property (nonatomic, strong) NSString *pageid;
@property (nonatomic, strong) NSString *pagename;
@property BOOL searchbar_hidden;
@property BOOL isActive;
@property int hasMoreData;
@property BOOL updating;
@property BOOL refreshing;
@property (nonatomic, strong) NSMutableArray *pageviews;
@property (nonatomic, strong) MPSearchBar *searchBar;
@property (nonatomic, strong) UIColor *searchbar_borderColor;
@property float searchbar_borderWidth;
@property float page_borderWidth;
@property (nonatomic, strong) UIColor *page_borderColor;
@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) id <MPPageDelegate, MPSearchBarDelegate> delegate;

-(void)createPage;
-(BOOL)checkNeedUpdate;
-(void)indicatorSpin;
-(void)indicatorStop;
-(void)appendView:(UIView *)view withFrame:(CGRect)frame;
-(void)setScrollBackground:(UIColor *)color;
-(CGRect)getScrollSize;
-(void)pageResign;
-(void)pageReset;
-(void)stopRefresh;
@end


@protocol MPPageDelegate <NSObject>

-(void)pageNeedsUpdate:(MPPage *)page;
-(void)pageNeedsRefresh:(MPPage *)page;

@end