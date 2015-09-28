//
//  ProductDetailImageViewController.m
//  Moooh
//
//  Created by Hanqing Hu on 2/11/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import "ProductDetailImageViewController.h"
#import "ViewWithData.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "Design.h"
const int ImageDetailBorder = 0;
@interface ProductDetailImageViewController ()

@end

@implementation ProductDetailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.config.screenWidth/2-100, 22, 200, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17.3];
    
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1]; // change this color
    label.text = self.product_name;
    [self.view addSubview:label];
    //[label sizeToFit];
    [Design navigationbar_title:label config:self.config];
    
    
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 64, self.config.screenWidth, 0.5);
    layer.backgroundColor = [[UIColor colorWithRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1] CGColor];
    [self.view.layer addSublayer:layer];
    
    close.titleLabel.font = [IonIcons fontWithSize:28];
    [close setTitle:icon_ios7_close forState:UIControlStateNormal];
    
    display_img = [[NSMutableArray alloc] init];
    display_scroll = [[NSMutableArray alloc] init];
    scroll = [[UIScrollView alloc] init];
    scroll.userInteractionEnabled = YES;
    //UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollpan:)];
    // pan.maximumNumberOfTouches = 1;
    //pan.delegate = self;
    //pan.delaysTouchesBegan = YES;
    //[imgscroll addGestureRecognizer:pan];
    UISwipeGestureRecognizer *toright = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goleft)];
    toright.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *toleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goright)];
    toleft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [scroll addGestureRecognizer:toleft];
    [scroll addGestureRecognizer:toright];
    
    
    scroll.scrollEnabled = NO;
    [scroll delaysContentTouches];
    scroll.frame = CGRectMake(0, 64, self.config.screenWidth, self.config.screenHeight-44);
    [self.view addSubview:scroll];
    
    for (int i= 0 ; i < self.images.count; i++){
        
        UIImageView *image = [self.images objectAtIndex:i];
        
        
        
        UIScrollView *uivscroll = [[UIScrollView alloc] init];
        uivscroll.frame = CGRectMake(ImageDetailBorder*(i+1)+self.config.screenWidth*i, 0, self.config.screenWidth-2*ImageDetailBorder, (self.config.screenHeight-64-ImageDetailBorder));
        uivscroll.scrollEnabled = YES;
        uivscroll.contentSize = CGSizeMake(self.config.screenWidth-2*ImageDetailBorder, (self.config.screenHeight-64-ImageDetailBorder));
        uivscroll.delegate = self;
        uivscroll.maximumZoomScale = 3.0;
        uivscroll.minimumZoomScale = 1.0;
        uivscroll.userInteractionEnabled = YES;
        UITapGestureRecognizer *dtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubletap:)];
        dtap.numberOfTapsRequired = 2;
        [uivscroll addGestureRecognizer:dtap];
        [display_scroll addObject:uivscroll];
        
        
        ImageWithData *uiv = [[ImageWithData alloc] init];
        if (image.image != nil){
            uiv.contentMode = UIViewContentModeScaleAspectFit;
            uiv.image = image.image;
            CGSize size = uiv.image.size;
            uiv.frame = CGRectMake(0, 0, uivscroll.frame.size.width, uivscroll.frame.size.width*(size.height/size.width));
            uiv.initial_frame = uiv.frame;
        }
        [uivscroll addSubview:uiv];
        
        //uiv.backgroundColor = [UIColor redColor];
        
        [display_img addObject:uiv];
        [scroll addSubview:uivscroll];
        
    }
    
    
    
    for (int i = 0 ; i < self.images.count; i++){
        UIImageView *v = [self.images objectAtIndex:i];
        if (v == self.activeImage){
            [scroll setContentOffset:CGPointMake(ImageDetailBorder*(i)+self.config.screenWidth*i, 0)];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)goleft{
    for (int i = 0; i < display_scroll.count; i++){
        UIScrollView *img = [display_scroll objectAtIndex:i];
        if (scroll.contentOffset.x == img.frame.origin.x - ImageDetailBorder){
            if (i > 0) {
                UIScrollView *prev = [display_scroll objectAtIndex:i-1];
                //activeImg = prev;
                [self scroll:scroll animateTo:CGPointMake(prev.frame.origin.x-ImageDetailBorder, 0)];
                //page.currentPage--;
                return;
            }
            
        }
    }
}
-(void)goright{
    for (int i = 0; i < display_scroll.count; i++){
        UIScrollView *img = [display_scroll objectAtIndex:i];
        
        if (scroll.contentOffset.x == img.frame.origin.x - ImageDetailBorder){
            if (i < self.images.count - 1) {
                UIScrollView *prev = [display_scroll objectAtIndex:i+1];
                //activeImg = prev;
                [self scroll:scroll animateTo:CGPointMake(prev.frame.origin.x-ImageDetailBorder, 0)];
                //page.currentPage++;
                return;
            }
            
        }
    }
}

-(void)scroll:(UIScrollView *)scrollView animateTo:(CGPoint)point{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentOffset:point];
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (int i = 0; i < display_scroll.count; i++){
        UIScrollView *img = [display_scroll objectAtIndex:i];
        
        if (scroll.contentOffset.x == img.frame.origin.x - ImageDetailBorder){
            UIImageView *v = [display_img objectAtIndex:i];
            return v;
            
        }
    }
    return nil;
}

-(void)doubletap:(UITapGestureRecognizer *)ges{
    UIScrollView *v = (UIScrollView *)ges.view;
    if (v.tag == 1){
        v.zoomScale = 1;
        v.tag = 0;
    } else {
        CGPoint point = [ges locationInView:ges.view];
        [v zoomToRect:CGRectMake(point.x-50, point.y-50, 50, 50) animated:YES];
        v.tag = 1;
    }
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
