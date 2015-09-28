//
//  OrderViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/19/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface OrderViewController : UIViewController <NSURLConnectionDelegate>{
    IBOutlet UIActivityIndicatorView *indicator;
    
    NSMutableArray *orders;
    NSMutableArray *receivedData;
    NSMutableArray *order_views;
    
    UIScrollView *scroll;
}
@property (nonatomic, strong)Config *config;

@end
