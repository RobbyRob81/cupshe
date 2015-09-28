//
//  ViewWithID.h
//  Ecommerce
//
//  Created by Hanqing Hu on 12/4/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewWithData : UIView

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSMutableDictionary *IDs;
@property (nonatomic, strong) NSMutableDictionary *subpages;
@property int load_status;
@end


@interface LabelWithData : UILabel
@property (nonatomic, strong) NSString *shareurl;
@property (nonatomic, strong) NSString *sharetext;
@property (nonatomic, strong) UIImage *shareimg;
@property (nonatomic, strong) UIImageView *shareimgView;
@end

@interface ImageWithData : UIImageView
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *item_id;
@property CGRect initial_frame;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property BOOL loaded;

@end


@interface ButtonWithData : UIButton
@property (nonatomic, strong) NSString *shareurl;
@property (nonatomic, strong) NSString *sharetext;
@property (nonatomic, strong) UIImage *shareimg;
@property (nonatomic, strong) NSString *item_id;
@end