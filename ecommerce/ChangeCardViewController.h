//
//  ChangeCardViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 7/31/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPView.h"
#import "Config.h"
@interface ChangeCardViewController : UIViewController <STPViewDelegate>{
    IBOutlet UIButton *saveBtn;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UISwitch *savecard;
    NSMutableArray *receivedData;
}
@property STPView* stripeView;
@property (nonatomic, strong) Config *config;

-(void)threadStartanimating;
-(IBAction)savecard:(id)sender;

@end
