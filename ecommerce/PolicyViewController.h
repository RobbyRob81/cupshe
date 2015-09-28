//
//  PolicyViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/31/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface PolicyViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *indicator;
    UIWebView *web;
    NSMutableData *received;
}

@property (nonatomic, strong) Config *config;
@property int policytype;
@end
