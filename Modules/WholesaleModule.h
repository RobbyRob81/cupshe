//
//  WholesaleModule.h
//  Ecommerce
//
//  Created by Han Hu on 8/8/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WholesaleModule : NSObject

@property (nonatomic, strong) NSString *wholesale_user_id;
@property (nonatomic, strong) NSString *wholesale_app_id;
@property (nonatomic, strong) NSString *tier_id;
@property (nonatomic, strong) NSString *tier_name;
@property int status;

+(void)getWholesaleApp:(id)config completion:(void(^)(WholesaleModule *wm, NSError *error))completion;
+(void)getWholesaleUserDetail:(id)config completion:(void(^)(WholesaleModule *wm, NSError *error))completion;


@end

@interface WholesaleViewController : UIViewController
@property (nonatomic, strong) id conf;
@end

