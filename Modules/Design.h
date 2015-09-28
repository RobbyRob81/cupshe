//
//  Design.h
//  Vanessa Gade
//
//  Created by Hanqing Hu on 10/29/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "MultiPageInfinateView.h"
#import "MultiPageView.h"
#import "MenuTableCell.h"
#import "CartTableViewCell.h"
#import "DOM.h"
@interface Design : NSObject


+(void)style:(DOM *)dom design:(NSDictionary *)design config:(Config *)config;
+(void)flow_layout:(NSMutableArray *)doms parent:(UIView *)parent config:(Config *)config;

//style individual elements
+(void)navigationbar:(UINavigationBar *)bar config:(Config *)config;
+(void)navigationbar_title:(UILabel *)title config:(Config *)config;
+(void)navigationbar_ion_icon:(UILabel *)btn config:(Config *)config;
+(void)navigationbar_fa_icon:(UILabel *)btn config:(Config *)config;
+(void)navigationbar_seg:(UISegmentedControl *)btn config:(Config *)config;
+(CGRect)promotion_initial_frame:(Config *)config;
+(void)promotion_init_multiView:(UIView *)view config:(Config *)config;
+(void)promotion_multiPageView:(MultiPageView *)view config:(Config *)config;
+(void)promotion_multiPageInfinateView:(MultiPageInfinateView *)view config:(Config *)config;
+(void)promotion:(NSMutableDictionary *)promoViews config:(Config *)config prevFrame:(CGRect)prev currentCount:(int)count;
+(void)department_facebook:(NSMutableDictionary *)facebookViews config:(Config *)config prevFrame:(CGRect)prev;
+(void)department_twitter:(NSMutableDictionary *)twitterViews config:(Config *)config prevFrame:(CGRect)prev;
+(void)department_social_page:(MPPage *)page config:(Config *)config;
+(void)product_page:(UIViewController *)page config:(Config *)config;
+(void)product_search_bar:(UISearchBar *)searchbar config:(Config *)config;
+(CGRect)product_initial_frame:(int)prevProduct config:(Config *)config;
+(void)product:(NSMutableDictionary *)productView config:(Config *)config prevFrame:(CGRect)prev currentCount:(int)i;

+(void)product_detail:(NSMutableDictionary *)productDetail config:(Config *)config;
+(void)finx_product_detail:(NSMutableDictionary *)productDetail config:(Config *)config;


+(void)product_filter:(NSMutableDictionary *)filter config:(Config *)config;
+(void)menu_table:(UITableView *)table config:(Config *)config;
+(void)menu_tableCell:(MenuTableCell *)cell config:(Config *)config;

+(void)picker_accessory:(NSMutableDictionary *)pickerViews config:(Config *)config;
+(void)checkout_btn:(NSMutableDictionary *)checkBtnViews config:(Config *)config;
+(void)checkout_view_with_btn:(NSMutableDictionary *)checkBtnViews config:(Config *)config;
@end
