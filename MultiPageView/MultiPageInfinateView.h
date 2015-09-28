//
//  MultiPageInfinate.h
//  Ecommerce
//
//  Created by apple on 14-8-15.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPage.h"
#import "MPSearchBar.h"

@protocol MultiPageInfinateViewDelegate;
@interface MultiPageInfinateView : UIView <UIScrollViewDelegate, MPPageDelegate, MPSearchBarDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource> {
    UIScrollView *scroll;
    UIView *titleScrollGradient;
     CAGradientLayer *titleScrollGradientLayer;
    UIScrollView *titleScroll;
    UIColor *activeTitleColor;
    UIColor *inactiveTitleColor;
    UIColor *titleScrollInnerColor;
    UIColor *titleScrollOuterColor;
    
    NSMutableArray *pages;
    //NSMutableArray *titles;
   
    //for title scrolling
    CGFloat titleMiddle;
    NSMutableArray *titleLabels;
    CGFloat currentTitleOffset;
    CGFloat initialTitleScrollOffset;
    CGFloat currentScrollOffset;
    int currenttitledirection;
    int initialtitledirection;
    BOOL titleScrolling;
    
     UITableView *search_display;
    
    //match main scroll with title scroll
    CGPoint panPoint;
    BOOL animating;
    
    NSMutableArray *blocking_gestures;
    
}

@property (readonly) BOOL updating;
@property CGFloat titleLabelWidth;
@property (nonatomic, strong) id <MultiPageInfinateViewDelegate> delegate;
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
-(void)setTitleTextColor:(UIColor *)actColor inActiveColor:(UIColor *)inactColor;
-(void)setTitleScrollGradient:(UIColor *)outer innercolor:(UIColor *)inner;
-(void)pageResign;
-(void)startUpdatePage:(MPPage *)page;
-(void)endUpdatePage:(MPPage *)page;
-(void)blocking_gesture:(UIView *)ges;
@end


@protocol MultiPageInfinateViewDelegate <NSObject>

-(void)pageNeedsUpdate:(MPPage *)page;
-(void)pageNeedsRefresh:(MPPage *)page;
-(void)mpSearchDidSearch:(NSString *)terms inPage:(MPPage *)page;
-(NSArray *)mpSearchChanged:(NSString *)terms inPage:(MPPage *)page;
-(void)mpSearchBegin:(MPPage *)page;
-(void)mpsearchCancel;
@end



