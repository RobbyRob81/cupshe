//
//  ProductDetailImageViewController.h
//  Moooh
//
//  Created by Hanqing Hu on 2/11/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface ProductDetailImageViewController : UIViewController <UIScrollViewDelegate>{
    UIScrollView *scroll;
    IBOutlet UIButton *close;
    NSMutableArray *display_img;
    NSMutableArray *display_scroll;
}
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIImageView *activeImage;
@property (nonatomic, strong) NSString *product_name;
@property (nonatomic, strong) Config *config;

-(IBAction)close:(id)sender;
@end
