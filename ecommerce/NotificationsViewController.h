//
//  NotificationsViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/21/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@class TwixxiesNotification;
@interface NotificationsViewController : UIViewController <UIScrollViewDelegate>{
    UIScrollView *scroll;
    UIView *loadingView;
    UIActivityIndicatorView *indicator;
    
    int loading;
    int hasmore;
    NSMutableArray *notifications;
    NSMutableArray *views;

}
@property (nonatomic, strong) Config *config;


@end



@interface TwixxiesNotification : NSObject
@property (nonatomic, strong) NSString *not_id;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *to_user_id;
@property (nonatomic, strong) NSString *timestamp;

@end