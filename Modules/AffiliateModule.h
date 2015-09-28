//
//  AffiliateModule.h
//  Moooh
//
//  Created by Hanqing Hu on 3/21/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//


#import <Foundation/Foundation.h>

@class AffiliateViewController;
@interface AffiliateModule : NSObject

@property (nonatomic, strong) NSString *aid;
@property (nonatomic, strong) NSString *mid;
@property int hasAffiliate;
@property int hasReferral;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *referal_filter;


+(void)getMerchant:(NSString *)appkey completion:(void(^)(AffiliateModule *am, NSError *error))completion;
+(void)getAffiliateID:(NSString *)appkey email:(NSString*)email completion:(void(^)(NSString *aid, NSError *error))completion;
+(void)getLink:(NSString *)appkey affiliate:(NSString *)aid item:(NSString *)iid itemType:(NSString *)type filter:(NSString *)filters completion:(void(^)(NSString *url, NSError *error))completion;
+(void)saveEvent:(NSString *)appkey affiliate:(NSString *)aid event:(NSString *)event json_data:(NSString *)json;
+(UIView *)getLoadingScreen:(CGRect)frame withMessage:(NSString *)mes;
@end




@interface AffiliateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>{
    UITableView *table;
    UITableView *apply_table;
    UIActivityIndicatorView *indicator;
    
    UITextField *apply_url;
    UITextField *apply_phone;
    UILabel *apply_email;
}

@property int status;
@property float rate;
@property (nonatomic, strong) NSString *commission;
@property (nonatomic, strong) NSString *commission_desc;
@property (nonatomic, strong) NSString *earning;
@property (nonatomic, strong) NSString *total_earning;
@property (nonatomic, strong) NSString *url;
@property int promo_count;
@property int banner_count;
@property id config;

-(void)load_view;

@end





@interface AffiliatePromotionController : UIViewController {
    UIScrollView *scroll;
    NSMutableArray *order_views;
    NSMutableArray *itemViews;
    NSMutableArray *itemImages;
    id shareview;
    id ss;
}

@property (nonatomic, strong) NSMutableArray *promo;
@property id config;

-(void)load_view;

@end

@interface AffiliateBannerController : UIViewController {
    UIScrollView *scroll;
    NSMutableArray *order_views;
    NSMutableDictionary *images;
    id shareview;
    id ss;
}

@property (nonatomic, strong) NSMutableArray *banners;
@property id config;

-(void)load_view;

@end
