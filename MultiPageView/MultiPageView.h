//
//  MultiPageView.h
//  Ecommerce
//
//  Created by apple on 14-8-11.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPage.h"
#import "MPSearchBar.h"

@protocol MultiPageViewDelegate;
@interface MultiPageView : UIView <UIScrollViewDelegate, MPPageDelegate, MPSearchBarDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIScrollView *scroll;
    UIView *titleScrollGradient;
    CAGradientLayer *titleScrollGradientLayer;
    UIView *titleScroll;
    NSMutableArray *titleScrollTitle;
    UIColor *titleColor;
    UIColor *titleScrollInnerColor;
    UIColor *titleScrollOuterColor; 
    UIView *underline;
    NSMutableArray *pages;
    
    //match main scroll with title scroll
    CGPoint panPoint;
    
    UITableView *search_display;
    float underline_height;
    
    //subview need gesture that blocks super view
    NSMutableArray *blocking_gestures;

}

@property (readonly) BOOL updating;
@property CGFloat titleLabelWidth;
@property (nonatomic, strong) id <MultiPageViewDelegate> delegate;
@property (nonatomic, strong) MPPage *activePage;
@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, strong) UIColor *headerBorderColor;
@property float headerBorderWidth;
@property (nonatomic, strong) UIColor *page_search_BorderColor;
@property float page_search_borderWidth;
@property (nonatomic, strong) UIColor *page_body_BorderColor;
@property float page_body_borderWidth;

@property BOOL showTitle;

-(MPPage *)getPageByID:(NSString *)pageid;

-(void)createPagesWithTitles:(NSMutableArray *)title ids:(NSMutableArray *)ids types:(NSMutableArray *)types;
-(void)updatePage:(MPPage *)page withData:(NSMutableArray *)data withView:(NSMutableArray *)views;
-(void)setTitleScrollBackground:(UIColor *)color;
-(void)setTitleTextColor:(UIColor *)color;
-(void)setTitleScrollGradient:(UIColor *)outer innercolor:(UIColor *)inner;
-(void)pageResign;
-(void)startUpdatePage:(MPPage *)page;
-(void)endUpdatePage:(MPPage *)page;
-(void)blocking_gesture:(UIView *)ges;
@end


@protocol MultiPageViewDelegate <NSObject>

-(void)pageNeedsUpdate:(MPPage *)page;
-(void)pageNeedsRefresh:(MPPage *)page;
-(void)mpSearchDidSearch:(NSString *)terms inPage:(MPPage *)page;
-(NSArray *)mpSearchChanged:(NSString *)terms inPage:(MPPage *)page;
-(void)mpSearchBegin:(MPPage *)page;
-(void)mpsearchCancel;
@end
