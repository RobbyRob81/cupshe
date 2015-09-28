//
//  DeepLinkModule.h
//  Moooh
//
//  Created by Hanqing Hu on 3/24/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
@interface DeepLinkModule : NSObject

+(void)getPresentingControllerWithType:(NSString *)type item_id:(NSString *)iid config:(Config *)config completion:(void(^)(UIViewController *view, NSError *error))completion;

@end
