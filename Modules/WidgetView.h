//
//  BottomPopUpView.h
//  Moooh
//
//  Created by Hanqing Hu on 4/13/15.
//  Copyright (c) 2015 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface BottomPopUpView : UIView {
    UIButton *close;
}
@property CGSize screen;
@property CGRect show_frame;
-(void)toggle_view:(BOOL)show;
-(void)layout_view;
@end
