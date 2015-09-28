//
//  MainViewController.h
//  quoteskahuna
//
//  Created by Hanqing Hu on 4/24/14.
//  Copyright (c) 2014 Big Kahuna Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "PromotionViewController.h"
@interface MainViewController : UIViewController <UIAlertViewDelegate> {
    NSMutableArray *receivedData;
    IBOutlet UIActivityIndicatorView *indicator;
    PromotionViewController *promo;
    UIView *loadingView;
    UILabel *loadinglabel;
    BOOL first;
}

@property (nonatomic, strong) Config *config;
@property BOOL reload;

@end
