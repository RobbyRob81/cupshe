//
//  SocialFeedModule.h
//  Twixxies
//
//  Created by Hanqing Hu on 12/15/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "ViewWithData.h"
@protocol SocialFeedModuleDelegate;
@interface SocialFeedModule : UIView <UIGestureRecognizerDelegate> {
    NSMutableArray *image_queue;
    
    UIImage *appicon;
}

@property (nonatomic, strong) NSMutableArray *social_feeds;
@property (nonatomic, strong) NSDictionary *design_main;
@property (nonatomic, strong) NSDictionary *design_logo;
@property (nonatomic, strong) NSDictionary *design_text;
@property (nonatomic, strong) NSDictionary *design_image;
@property (nonatomic, strong) NSDictionary *design_buttonpane;
@property (nonatomic, strong) NSDictionary *design_sharebut;


@property (nonatomic, strong) NSString *feed_type;
@property (nonatomic, strong) NSString *base_url;
@property (nonatomic, strong) NSString *social_username;

@property (nonatomic, strong) NSMutableArray *subvs;

@property (nonatomic, strong) id parent;

//this part is a bit complicated because of facebook.
//first module loads on different thread
//then module calls delegate method that the module is ready
//then delegate will append this module to super_view (MPPage in this case).
@property (nonatomic, strong) id <SocialFeedModuleDelegate> delegate; //the delegate method tells the parent when the view is ready to be appended
@property (nonatomic, strong) UIView *super_view; //keep trak of the parent view so that when it's ready, the module can be append to the super view in the delegate method


-(void)get_social_feed:(NSURL *)url config:(Config *)config;
-(void)display_facebook:(Config *)config;
-(void)display_twitter:(Config *)config;
-(void)socialsel:(UITapGestureRecognizer *)ges;
@end


@protocol SocialFeedModuleDelegate <NSObject>

-(void)social_finish_loading:(SocialFeedModule *)module;
-(void)socialsel:(LabelWithData *)v;
@end