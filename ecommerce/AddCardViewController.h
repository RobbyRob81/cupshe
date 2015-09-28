//
//  AddCardViewController.h
//  Ecommerce
//
//  Created by Hanqing Hu on 5/27/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPView.h"
#import "Config.h"
@interface AddCardViewController : UIViewController <STPViewDelegate>{
    IBOutlet UIButton *saveBtn;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UISwitch *savecard;
    IBOutlet UILabel *savecardlabel;
}
@property STPView* stripeView;
@property (nonatomic, strong) Config *config;
@property BOOL enable_savecard;

-(void)threadStartanimating;
-(IBAction)savecard:(id)sender;
@end
