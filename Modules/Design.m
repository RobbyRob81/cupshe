
//
//  Design.m
//  Vanessa Gade
//
//  Created by Hanqing Hu on 10/29/14.
//  Copyright (c) 2014 Twixxies. All rights reserved.
//

#import "Design.h"
#import "ionicons-codes.h"
#import "IonIcons.h"
#import "NSString+FontAwesome.h"
#import "PromotionViewController.h"
#import "Promotion.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewWithData.h"
#import "DDPageControl.h"
#import "SocialShareModule.h"

@implementation Design

+(void)style:(DOM *)dom design:(NSDictionary *)design config:(Config *)config{
    UIView *view= (UIView *)dom.view;
    UIView *parent = (UIView *)dom.parent;
    if (design == nil) return;
    if ([design objectForKey:@"background-color"] != nil){
        NSArray *colors = [design objectForKey:@"background-color"];
        view.backgroundColor = [UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]];
        
    }
    if ([design objectForKey:@"tint-color"] != nil){
        NSArray *colors = [design objectForKey:@"tint-color"];
        view.tintColor = [UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]];
    }
    if ([design objectForKey:@"border-top"] != nil){
        NSArray *border = [design objectForKey:@"border-top"];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor =[[UIColor colorWithRed:[[border objectAtIndex:0] floatValue]/255.0 green:[[border objectAtIndex:1] floatValue]/255.0 blue:[[border objectAtIndex:2] floatValue]/255.0 alpha:[[border objectAtIndex:3] floatValue]] CGColor];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, [[border objectAtIndex:4] floatValue]);
        NSLog(@"%f", layer.frame.size.height);
        [view.layer addSublayer:layer];
    }
    if ([design objectForKey:@"border-left"] != nil){
        NSArray *border = [design objectForKey:@"border-left"];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor =[[UIColor colorWithRed:[[border objectAtIndex:0] floatValue]/255.0 green:[[border objectAtIndex:1] floatValue]/255.0 blue:[[border objectAtIndex:2] floatValue]/255.0 alpha:[[border objectAtIndex:3] floatValue]] CGColor];
        layer.frame = CGRectMake(0, 0, [[border objectAtIndex:4] floatValue], view.frame.size.height);
        [view.layer addSublayer:layer];
    }
    if ([design objectForKey:@"border-right"] != nil){
        NSArray *border = [design objectForKey:@"border-right"];
        float width = [[border objectAtIndex:4] floatValue];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor =[[UIColor colorWithRed:[[border objectAtIndex:0] floatValue]/255.0 green:[[border objectAtIndex:1] floatValue]/255.0 blue:[[border objectAtIndex:2] floatValue]/255.0 alpha:[[border objectAtIndex:3] floatValue]] CGColor];
        layer.frame = CGRectMake(view.frame.size.width-width, 0, width, view.frame.size.height);
        [view.layer addSublayer:layer];
    }
    if ([design objectForKey:@"border-bottom"] != nil){
        NSArray *border = [design objectForKey:@"border-bottom"];
        float width = [[border objectAtIndex:4] floatValue];
        CALayer *layer = [CALayer layer];
        layer.backgroundColor =[[UIColor colorWithRed:[[border objectAtIndex:0] floatValue]/255.0 green:[[border objectAtIndex:1] floatValue]/255.0 blue:[[border objectAtIndex:2] floatValue]/255.0 alpha:[[border objectAtIndex:3] floatValue]] CGColor];
        layer.frame = CGRectMake(0, view.frame.size.height-width, view.frame.size.width, width);
        [view.layer addSublayer:layer];
    }
    if ([design objectForKey:@"border-color"] != nil){
        NSArray *colors = [design objectForKey:@"border-color"];
        view.layer.borderColor = [[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]] CGColor];
    }
    if ([design objectForKey:@"border-width"] != nil){
        float width = [[design objectForKey:@"border-width"] floatValue];
        view.layer.borderWidth = width;
    }
    if ([design objectForKey:@"status-bar"] != nil){
        NSString *status = [design objectForKey:@"status-bar"];
        if ([status isEqualToString:@"light"]) [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        else [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    if ([design objectForKey:@"font-family"] != nil && [design objectForKey:@"font-size"] != nil){
        NSString *family = [design objectForKey:@"font-family"];
        int size =[[design objectForKey:@"font-size"] intValue];
        [Design resolve_font:family size:size view:dom.view];
    }
    if ([design objectForKey:@"clip-to-bound"] != nil){
        int clip = [[design objectForKey:@"clip-to-bound"] intValue];
        if (clip != 0) view.clipsToBounds = YES;
    }
    if ([design objectForKey:@"x"] != nil){
        NSArray *xarr = [design objectForKey:@"x"];
        float perx = [[xarr objectAtIndex:0] floatValue];
        float x = [[xarr objectAtIndex:1] floatValue];
        
        CGRect frame = view.frame;
        if (dom.parent == nil){
            frame.origin.x = config.screenWidth * (perx/100.0);
            
        }else {
            frame.origin.x = parent.frame.size.width * (perx/100.0);
            
        }
        
        
        frame.origin.x += x;
        view.frame = frame;
        
        
    }
    if ([design objectForKey:@"y"] != nil){
        NSArray *yarr = [design objectForKey:@"y"];
        float pery = [[yarr objectAtIndex:0] floatValue];
        float y = [[yarr objectAtIndex:1] floatValue];
        
        CGRect frame = view.frame;
        if (dom.parent == nil){
            frame.origin.y = config.screenHeight * (pery/100.0);
            
        } else {
            frame.origin.y = parent.frame.size.height * (pery/100.0);
            
        }
        frame.origin.y += y;
        view.frame = frame;
        
    }
    if ([design objectForKey:@"width"] != nil){
        NSArray *warr = [design objectForKey:@"width"];
        float percent = [[warr objectAtIndex:0] floatValue];
        float px = [[warr objectAtIndex:1] floatValue];
        float hx = [[warr objectAtIndex:2] floatValue];
        CGRect frame = view.frame;
        frame.size.width = 0;
        if (dom.parent == nil){
            frame.size.width += config.screenWidth * (percent/100.0);
            
        } else {
            frame.size.width += parent.frame.size.width * (percent/100.0);
            
        }
        frame.size.width += px;
        
        
        if (hx > 0){
            if ([design objectForKey:@"height"] != nil){
                NSArray *harr = [design objectForKey:@"height"];
                float percent = [[harr objectAtIndex:0] floatValue];
                float hpx = [[harr objectAtIndex:1] floatValue];
                
                float height = 0;
                
                if (dom.parent == nil){
                    height += config.screenHeight * (percent/100.0);
                    
                } else {
                    height += parent.frame.size.height * (percent/100.0);
                    
                }
                height += hpx;
                frame.size.width = height * hx+px;
            } else {
                frame.size.width = view.frame.size.height * hx+px;
            }
        }
        
        if (view != nil){
            view.frame = frame;
        }
        
    }
    if ([design objectForKey:@"height"] != nil){
        NSArray *harr = [design objectForKey:@"height"];
        float percent = [[harr objectAtIndex:0] floatValue];
        float px = [[harr objectAtIndex:1] floatValue];
        float wx = [[harr objectAtIndex:2] floatValue];
        CGRect frame = view.frame;
        frame.size.height = 0;
        if (dom.parent == nil){
            frame.size.height += config.screenHeight * (percent/100.0);
            
        } else {
            frame.size.height += parent.frame.size.height * (percent/100.0);
            
        }
        
        
        frame.size.height += px;
        
        
        if (wx > 0){
            if ([design objectForKey:@"width"] != nil){
                NSArray *warr = [design objectForKey:@"width"];
                float percent = [[warr objectAtIndex:0] floatValue];
                float wpx = [[warr objectAtIndex:1] floatValue];
                float width = 0;
                if (dom.parent == nil){
                    width += config.screenWidth * (percent/100.0);
                    
                } else {
                    width += parent.frame.size.width * (percent/100.0);
                    
                }
                
                width += wpx;
                frame.size.height = width * wx + px;
            }
            else {
                frame.size.height = view.frame.size.width * wx + px;
            }
        }
        
        if (view != nil){
            view.frame = frame;
        }
        
    }
    if ([design objectForKey:@"max-width"] != nil){
        NSArray *warr = [design objectForKey:@"width"];
        float percent = [[warr objectAtIndex:0] floatValue];
        float px = [[warr objectAtIndex:1] floatValue];
        //float hx = [[warr objectAtIndex:2] floatValue];
        CGRect frame = view.frame;
        frame.size.width = 0;
        if (dom.parent == nil){
            frame.size.width += config.screenWidth * (percent/100.0);
            
        } else {
            frame.size.width += parent.frame.size.width * (percent/100.0);
            
        }
        frame.size.width += px;
        
        if (view.frame.size.width > frame.size.width) view.frame = frame;
    }
    if ([design objectForKey:@"max-height"] != nil){
        NSArray *harr = [design objectForKey:@"height"];
        float percent = [[harr objectAtIndex:0] floatValue];
        float px = [[harr objectAtIndex:1] floatValue];
        //float wx = [[harr objectAtIndex:2] floatValue];
        CGRect frame = view.frame;
        frame.size.height = 0;
        if (dom.parent == nil){
            frame.size.height += config.screenHeight * (percent/100.0);
            
        } else {
            frame.size.height += parent.frame.size.height * (percent/100.0);
            
        }
        
        
        frame.size.height += px;
        if (view.frame.size.height > frame.size.height) view.frame = frame;
    }
    if ([design objectForKey:@"margin"] != nil){
        NSArray *margin = [design objectForKey:@"margin"];
        CGRect frame = view.frame;
        float top = [[margin objectAtIndex:0] floatValue];
        float right = [[margin objectAtIndex:1] floatValue];
        float bottom = [[margin objectAtIndex:2] floatValue];
        float left = [[margin objectAtIndex:3] floatValue];
        frame.origin.x += left;
        frame.origin.y += top;
        //frame.size.width += right;
        //frame.size.height -=bottom;
        view.layoutMargins= UIEdgeInsetsMake(0, 0, bottom, 0);
        view.frame=frame;
        dom.margin = margin;
    }
    if ([design objectForKey:@"gradient"] != nil){
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSArray *cols = [design objectForKey:@"gradient"];
        for (NSArray *col in cols){
            [colors addObject:(id)[UIColor colorWithRed:[[col objectAtIndex:0] floatValue]/255.0 green:[[col objectAtIndex:1] floatValue]/255.0 blue:[[col objectAtIndex:2] floatValue]/255.0 alpha:[[col objectAtIndex:3] floatValue]].CGColor];
        }
        
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        [gradientMask setShouldRasterize:YES];
        [gradientMask setRasterizationScale:[UIScreen mainScreen].scale];
        gradientMask.frame = view.bounds;
        
        
        
        //UIColor *startColour = [UIColor colorWithHue:1 saturation:0 brightness:1 alpha:0.01];
        //UIColor *endColour = [UIColor colorWithHue:.000000 saturation:0.00 brightness:0.00 alpha:0.4];
        gradientMask.colors = colors;
        [view.layer insertSublayer:gradientMask atIndex:0];
    }
    
    //navigation bar related css
    if ([dom.view isKindOfClass:[UINavigationBar class]]){
        UINavigationBar *bar = (UINavigationBar *)dom.view;
        if ([design objectForKey:@"navigation-bar-background-color"]!= nil){
            NSArray *colors = [design objectForKey:@"navigation-bar-background-color"];
            bar.backgroundColor = [UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]];
            [bar setBarTintColor:[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]]];
        }
        if ([design objectForKey:@"navigation-bar-border"]!= nil){
            NSArray *colors = [design objectForKey:@"navigation-bar-border"];
            float borderWidth = [[colors objectAtIndex:4] floatValue];
            [bar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            [bar setShadowImage:[UIImage new]];
            [bar setTranslucent:NO];
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]] CGColor];
            layer.frame = CGRectMake(0, bar.frame.size.height-borderWidth, bar.frame.size.width, borderWidth);
            [bar.layer addSublayer:layer];
            
        }
    }
    //UILabel related css
    if ([dom.view isKindOfClass:[UILabel class]]){
        UILabel *label = (UILabel *)dom.view;
        if ([design objectForKey:@"color"]!= nil){
            NSArray *colors = [design objectForKey:@"color"];
            label.textColor = [UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]];
        }
        if ([design objectForKey:@"text-alignment"] != nil){
            NSString *align = [design objectForKey:@"text-alignment"];
            if ([align isEqualToString:@"left"]){
                label.textAlignment = NSTextAlignmentLeft;
            }
            if ([align isEqualToString:@"center"]){
                label.textAlignment = NSTextAlignmentCenter;
            }
            if ([align isEqualToString:@"right"]){
                label.textAlignment = NSTextAlignmentRight;
            }
        }
        if ([design objectForKey:@"wrap-text"] != nil)
        {
            NSArray *margins = [design objectForKey:@"wrap-text"];
            if ([design objectForKey:@"font-family"] != nil && [design objectForKey:@"font-size"] != nil){
                NSString *family = [design objectForKey:@"font-family"];
                int size =[[design objectForKey:@"font-size"] intValue];
                [Design resolve_font:family size:size view:label];
            }
            CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName: label.font}];
            CGRect frame = label.frame;
            frame.size.width = size.width + [[margins objectAtIndex:1] intValue] + [[margins objectAtIndex:0] intValue];
            label.textAlignment = NSTextAlignmentCenter;
            
        }
        if ([design objectForKey:@"lines"] != nil)
        {
            int lines = [[design objectForKey:@"lines"] intValue];
            label.numberOfLines = lines;
            label.lineBreakMode =NSLineBreakByWordWrapping;
        }
    }
    //UITextField related css
    if ([dom.view isKindOfClass:[UITextField class]]){
        UITextField *text = (UITextField *)dom.view;
        if ([design objectForKey:@"color"]!= nil){
            NSArray *colors = [design objectForKey:@"color"];
            text.textColor = [UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]];
        }
        if ([design objectForKey:@"text-alignment"] != nil){
            NSString *align = [design objectForKey:@"text-alignment"];
            if ([align isEqualToString:@"left"]){
                text.textAlignment = NSTextAlignmentLeft;
            }
            if ([align isEqualToString:@"center"]){
                text.textAlignment = NSTextAlignmentCenter;
            }
            if ([align isEqualToString:@"right"]){
                text.textAlignment = NSTextAlignmentRight;
            }
        }
    }
    //UITextView related css
    if ([dom.view isKindOfClass:[UITextView class]]){
        UITextView *text = (UITextView *)dom.view;
        if ([design objectForKey:@"color"]!= nil){
            NSArray *colors = [design objectForKey:@"color"];
            text.textColor = [UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]];
        }
        if ([design objectForKey:@"text-alignment"] != nil){
            NSString *align = [design objectForKey:@"text-alignment"];
            if ([align isEqualToString:@"left"]){
                text.textAlignment = NSTextAlignmentLeft;
            }
            if ([align isEqualToString:@"center"]){
                text.textAlignment = NSTextAlignmentCenter;
            }
            if ([align isEqualToString:@"right"]){
                text.textAlignment = NSTextAlignmentRight;
            }
        }
        if ([design objectForKey:@"size-to-fit"] != nil){
            int stf = [[design objectForKey:@"size-to-fit"] intValue];
            if (stf == 1){
                
                
                [text sizeToFit];
                if ([design objectForKey:@"max-width"] != nil){
                    NSArray *warr = [design objectForKey:@"width"];
                    float percent = [[warr objectAtIndex:0] floatValue];
                    float px = [[warr objectAtIndex:1] floatValue];
                    //float hx = [[warr objectAtIndex:2] floatValue];
                    CGRect frame = view.frame;
                    frame.size.width = 0;
                    if (dom.parent == nil){
                        frame.size.width += config.screenWidth * (percent/100.0);
                        
                    } else {
                        frame.size.width += parent.frame.size.width * (percent/100.0);
                        
                    }
                    frame.size.width += px;
                    
                    if (view.frame.size.width > frame.size.width) view.frame = frame;
                }
                if ([design objectForKey:@"max-height"] != nil){
                    NSArray *harr = [design objectForKey:@"height"];
                    float percent = [[harr objectAtIndex:0] floatValue];
                    float px = [[harr objectAtIndex:1] floatValue];
                    //float wx = [[harr objectAtIndex:2] floatValue];
                    CGRect frame = view.frame;
                    frame.size.height = 0;
                    if (dom.parent == nil){
                        frame.size.height += config.screenHeight * (percent/100.0);
                        
                    } else {
                        frame.size.height += parent.frame.size.height * (percent/100.0);
                        
                    }
                    
                    
                    frame.size.height += px;
                    if (view.frame.size.height > frame.size.height) view.frame = frame;
                }
            }
            
        }
        
        if ([design objectForKey:@"text-insets"] != nil){
            NSArray *insect = [design objectForKey:@"text-insets"];
            text.contentInset = UIEdgeInsetsMake([[insect objectAtIndex:0] floatValue],[[insect objectAtIndex:1] floatValue],[[insect objectAtIndex:2] floatValue],[[insect objectAtIndex:3] floatValue]);
        }
        if ([design objectForKey:@"wrap-text"] != nil)
        {
            NSArray *margins = [design objectForKey:@"wrap-text"];
            if ([design objectForKey:@"font-family"] != nil && [design objectForKey:@"font-size"] != nil){
                NSString *family = [design objectForKey:@"font-family"];
                int size =[[design objectForKey:@"font-size"] intValue];
                [Design resolve_font:family size:size view:text];
            }
            CGSize size = [text.text sizeWithAttributes:@{NSFontAttributeName: text.font}];
            CGRect frame = text.frame;
            frame.size.width = size.width + [[margins objectAtIndex:1] intValue] + [[margins objectAtIndex:0] intValue];
            if (size.height > frame.size.height){
                frame.size.height = size.height;
            }
            text.frame = frame;
            text.textAlignment = NSTextAlignmentCenter;
            
        }
    }
    //UIButton related css
    if ([dom.view isKindOfClass:[UIButton class]]){
        UIButton *text = (UIButton *)dom.view;
        if ([design objectForKey:@"color"]!= nil){
            NSArray *colors = [design objectForKey:@"color"];
            [text setTitleColor:[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]] forState:UIControlStateNormal];
        }
        
    }
    //UISegmentedControl related css
    if ([dom.view isKindOfClass:[UISegmentedControl class]]){
        UISegmentedControl *seg = (UISegmentedControl *)dom.view;
        if ([design objectForKey:@"color"]!= nil){
            NSArray *colors = [design objectForKey:@"color"];
            [seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]]} forState:UIControlStateNormal];
        }
    }
    //DDPageControl related css
    if ([dom.view isKindOfClass:[DDPageControl class]]){
        DDPageControl *page = (DDPageControl *)dom.view;
        if ([design objectForKey:@"current-page-color"]!= nil){
            NSArray *colors = [design objectForKey:@"current-page-color"];
            [page setOnColor:[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]]];
        }
        if ([design objectForKey:@"page-color"]!= nil){
            NSArray *colors = [design objectForKey:@"page-color"];
            [page setOffColor:[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]]];
        }
        if ([design objectForKey:@"indicator_diameter"]!= nil){
            float diameter = [[design objectForKey:@"indicator_diameter"] floatValue];
            [page setIndicatorDiameter:diameter];
        }
        if ([design objectForKey:@"indicator_fill_space"]!= nil){
            float diameter = [[design objectForKey:@"indicator_fill_space"] floatValue];
            [page setIndicatorSpace:diameter];
        }
        if ([design objectForKey:@"page_indicator_type"]){
            NSString *type = [design objectForKey:@"page_indicator_type"];
            if ([type isEqualToString:@"on-full-off-full"]) [page setType:DDPageControlTypeOnFullOffFull];
            else if ([type isEqualToString:@"on-full-off-empty"]) [page setType:DDPageControlTypeOnFullOffEmpty];
            else if ([type isEqualToString:@"on-empty-off-full"]) [page setType:DDPageControlTypeOnEmptyOffFull];
            else if ([type isEqualToString:@"on-empty-off-empty"]) [page setType:DDPageControlTypeOnEmptyOffEmpty];
        }
    }
    //UITable related css
    if ([dom.view isKindOfClass:[UITableView class]]){
        UITableView *table = (UITableView *)dom.view;
        if ([design objectForKey:@"separator-color"]!= nil){
            NSArray *colors = [design objectForKey:@"separator-color"];
            table.separatorColor =[UIColor colorWithRed:[[colors objectAtIndex:0] floatValue]/255.0 green:[[colors objectAtIndex:1] floatValue]/255.0 blue:[[colors objectAtIndex:2] floatValue]/255.0 alpha:[[colors objectAtIndex:3] floatValue]];
        }
        
    }
    //MultiPageView related css
    if ([dom.view isKindOfClass:[MultiPageView class]]){
        MultiPageView *view = (MultiPageView *)dom.view;
        if ([design objectForKey:@"multipage-header-border-color"] != nil){
            NSArray *hborder = [design objectForKey:@"multipage-header-border-color"];
            view.headerBorderColor = [UIColor colorWithRed:[[hborder objectAtIndex:0] floatValue]/255.0 green:[[hborder objectAtIndex:1] floatValue]/255.0 blue:[[hborder objectAtIndex:2] floatValue]/255.0 alpha:[[hborder objectAtIndex:3] floatValue]];
        }
        if ([design objectForKey:@"multipage-header-background-color"]!=nil){
            NSArray *hback = [design objectForKey:@"multipage-header-background-color"];
            [view setTitleScrollBackground:[UIColor colorWithRed:[[hback objectAtIndex:0] floatValue]/255.0 green:[[hback objectAtIndex:1] floatValue]/255.0 blue:[[hback objectAtIndex:2] floatValue]/255.0 alpha:[[hback objectAtIndex:3] floatValue]]];
            
            //[view setTitleScrollGradient:[UIColor colorWithRed:[[hback objectAtIndex:0] floatValue]/255.0 green:[[hback objectAtIndex:1] floatValue]/255.0 blue:[[hback objectAtIndex:2] floatValue]/255.0 alpha:[[hback objectAtIndex:3] floatValue]] innercolor:[UIColor colorWithRed:[[hback objectAtIndex:0] floatValue]/255.0 green:[[hback objectAtIndex:1] floatValue]/255.0 blue:[[hback objectAtIndex:2] floatValue]/255.0 alpha:0]];
        }
        if ([design objectForKey:@"multipage-header-border-width"] != nil){
            float hborder_width = [[design objectForKey:@"multipage-header-border-width"] floatValue];
            view.headerBorderWidth = hborder_width;
        }
        
        if ([design objectForKey:@"multipage-active-text"] != nil){
            NSArray *textcolor = [design objectForKey:@"multipage-active-text"];
            [view setTitleTextColor:[UIColor colorWithRed:[[textcolor objectAtIndex:0] floatValue]/255.0 green:[[textcolor objectAtIndex:1] floatValue]/255.0 blue:[[textcolor objectAtIndex:2] floatValue]/255.0 alpha:[[textcolor objectAtIndex:3] floatValue]]];
        }
        if ( [design objectForKey:@"multipage-body-border-color"]!= nil){
            NSArray *pageborder = [design objectForKey:@"multipage-body-border-color"];
            view.page_body_BorderColor = [UIColor colorWithRed:[[pageborder objectAtIndex:0] floatValue]/255.0 green:[[pageborder objectAtIndex:1] floatValue]/255.0 blue:[[pageborder objectAtIndex:2] floatValue]/255.0 alpha:[[pageborder objectAtIndex:3] floatValue]];
        }
        if ( [design objectForKey:@"multipage-body-border-width"]!= nil){
            float width = [[design objectForKey:@"multipage-body-border-width"] floatValue];
            view.page_body_borderWidth = width;
        }
        if ( [design objectForKey:@"multipage-searchbar-border-color"]!= nil){
            NSArray *pageborder = [design objectForKey:@"multipage-searchbar-border-color"];
            view.page_search_BorderColor = [UIColor colorWithRed:[[pageborder objectAtIndex:0] floatValue]/255.0 green:[[pageborder objectAtIndex:1] floatValue]/255.0 blue:[[pageborder objectAtIndex:2] floatValue]/255.0 alpha:[[pageborder objectAtIndex:3] floatValue]];
        }
        if ( [design objectForKey:@"multipage-searchbar-border-width"]!= nil){
            float width = [[design objectForKey:@"multipage-searchbar-border-width"] floatValue];
            view.page_search_borderWidth = width;
        }
    }
    //MultiPageInfinateView related css
    if ([dom.view isKindOfClass:[MultiPageInfinateView class]]){
        MultiPageInfinateView *view = (MultiPageInfinateView *)dom.view;
        if ([design objectForKey:@"multipage-header-border-color"] != nil){
            NSArray *hborder = [design objectForKey:@"multipage-header-border-color"];
            view.headerBorderColor = [UIColor colorWithRed:[[hborder objectAtIndex:0] floatValue]/255.0 green:[[hborder objectAtIndex:1] floatValue]/255.0 blue:[[hborder objectAtIndex:2] floatValue]/255.0 alpha:[[hborder objectAtIndex:3] floatValue]];
        }
        if ([design objectForKey:@"multipage-header-background-color"]!=nil){
            NSArray *hback = [design objectForKey:@"multipage-header-background-color"];
            [view setTitleScrollBackground:[UIColor colorWithRed:[[hback objectAtIndex:0] floatValue]/255.0 green:[[hback objectAtIndex:1] floatValue]/255.0 blue:[[hback objectAtIndex:2] floatValue]/255.0 alpha:[[hback objectAtIndex:3] floatValue]]];
            [view setTitleScrollGradient:[UIColor colorWithRed:[[hback objectAtIndex:0] floatValue]/255.0 green:[[hback objectAtIndex:1] floatValue]/255.0 blue:[[hback objectAtIndex:2] floatValue]/255.0 alpha:[[hback objectAtIndex:3] floatValue]] innercolor:[UIColor colorWithRed:[[hback objectAtIndex:0] floatValue]/255.0 green:[[hback objectAtIndex:1] floatValue]/255.0 blue:[[hback objectAtIndex:2] floatValue]/255.0 alpha:0]];
        }
        if ([design objectForKey:@"multipage-header-border-width"] != nil){
            float hborder_width = [[design objectForKey:@"multipage-header-border-width"] floatValue];
            view.headerBorderWidth = hborder_width;
        }
        
        if ([design objectForKey:@"multipage-active-text"] != nil && [design objectForKey:@"multipage-inactive-text"] != nil){
            NSArray *acttextcolor = [design objectForKey:@"multipage-active-text"];
            NSArray *inacttextcolor = [design objectForKey:@"multipage-inactive-text"];
            [view setTitleTextColor:[UIColor colorWithRed:[[acttextcolor objectAtIndex:0] floatValue]/255.0 green:[[acttextcolor objectAtIndex:1] floatValue]/255.0 blue:[[acttextcolor objectAtIndex:2] floatValue]/255.0 alpha:[[acttextcolor objectAtIndex:3] floatValue]] inActiveColor:[UIColor colorWithRed:[[inacttextcolor objectAtIndex:0] floatValue]/255.0 green:[[inacttextcolor objectAtIndex:1] floatValue]/255.0 blue:[[inacttextcolor objectAtIndex:2] floatValue]/255.0 alpha:[[inacttextcolor objectAtIndex:3] floatValue]]];
        }
        if ( [design objectForKey:@"multipage-body-border-color"]!= nil){
            NSArray *pageborder = [design objectForKey:@"multipage-body-border-color"];
            view.page_body_BorderColor = [UIColor colorWithRed:[[pageborder objectAtIndex:0] floatValue]/255.0 green:[[pageborder objectAtIndex:1] floatValue]/255.0 blue:[[pageborder objectAtIndex:2] floatValue]/255.0 alpha:[[pageborder objectAtIndex:3] floatValue]];
        }
        if ( [design objectForKey:@"multipage-body-border-width"]!= nil){
            float width = [[design objectForKey:@"multipage-body-border-width"] floatValue];
            view.page_body_borderWidth = width;
        }
        if ( [design objectForKey:@"multipage-searchbar-border-color"]!= nil){
            NSArray *pageborder = [design objectForKey:@"multipage-searchbar-border-color"];
            view.page_search_BorderColor = [UIColor colorWithRed:[[pageborder objectAtIndex:0] floatValue]/255.0 green:[[pageborder objectAtIndex:1] floatValue]/255.0 blue:[[pageborder objectAtIndex:2] floatValue]/255.0 alpha:[[pageborder objectAtIndex:3] floatValue]];
        }
        if ( [design objectForKey:@"multipage-searchbar-border-width"]!= nil){
            float width = [[design objectForKey:@"multipage-searchbar-border-width"] floatValue];
            view.page_search_borderWidth = width;
        }
    }
    //MPPage related css
    
    
}

+(void)resolve_font:(NSString *)family size:(int)size view:(UIView *)v{
    UILabel *v1 = nil;
    UITextField *v2 = nil;
    UITextView *v3 = nil;
    UIButton *v4 = nil;
    if ([v isKindOfClass:[UILabel class]]){
        v1 = (UILabel *)v;
    }
    if ([v isKindOfClass:[UITextField class]]){
        v2 = (UITextField *)v;
    }
    if ([v isKindOfClass:[UITextView class]]){
        v3 = (UITextView *)v;
    }
    if ([v isKindOfClass:[UIButton class]]){
        v4 = (UIButton *)v;
    }
    if ([family isEqualToString:@"IonIcons"]){
        if (v1 != nil)v1.font = [IonIcons fontWithSize:size];
        if (v2 != nil)v2.font = [IonIcons fontWithSize:size];
        if (v3 != nil)v3.font = [IonIcons fontWithSize:size];
        if (v4 != nil)v4.titleLabel.font = [IonIcons fontWithSize:size];
    }
    else if ([family isEqualToString:@"FontAwesome"]){
        if (v1 != nil)v1.font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
        if (v2 != nil)v2.font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
        if (v3 != nil)v3.font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
        if (v4 != nil)v4.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:size];
    } else if ([family isEqualToString:@"Bold"]){
        if (v1 != nil)v1.font = [UIFont boldSystemFontOfSize:size];
        if (v2 != nil)v2.font = [UIFont boldSystemFontOfSize:size];
        if (v3 != nil)v3.font = [UIFont boldSystemFontOfSize:size];
        if (v4 != nil)v4.titleLabel.font = [UIFont systemFontOfSize:size];
    }
    else {
        if (v1 != nil)v1.font = [UIFont systemFontOfSize:size];
        if (v2 != nil)v2.font = [UIFont systemFontOfSize:size];
        if (v3 != nil)v3.font = [UIFont systemFontOfSize:size];
        if (v4 != nil)v4.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}

+(void)flow_layout:(NSMutableArray *)doms parent:(UIView *)parent config:(Config *)config{
    float width = parent.frame.size.width;
    if (parent == nil) width = config.screenWidth;
    for (int i = 0 ; i < doms.count; i++){
        DOM *dom = [doms objectAtIndex:i];
        UIView *v = (UIView *)dom.view;
        
        CGRect frame = v.frame;
        
        if (i == 0){
            frame.origin.y = 0;
            frame.origin.x = 0;
            v.frame = frame;
        } else {
            DOM *predom = [doms objectAtIndex:i-1];
            UIView *prev = (UIView *)predom.view;
            if (v.frame.size.width+prev.frame.origin.x+prev.frame.size.width <= parent.frame.size.width){
                frame.origin.y = prev.frame.origin.y;
                frame.origin.x = prev.frame.origin.x + prev.frame.size.width;
            } else {
                frame.origin.y = prev.frame.origin.y+prev.frame.size.height;
                frame.origin.x = 0;
            }
            v.frame = frame;
        }
    }
}



+(void)navigationbar:(UINavigationBar *)bar config:(Config *)config{
    @try {
        NSDictionary *designs = [config.design objectForKey:@"design"];
        NSDictionary *design = [designs objectForKey:@"navigation_bar"];
        [self style:[[DOM alloc] initWithView:bar parent:nil] design:design config:config];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}
+(void)navigationbar_title:(UILabel *)title config:(Config *)config{
    
    @try {
        NSDictionary *designs = [config.design objectForKey:@"design"];
        NSDictionary *design = [designs objectForKey:@"navigation_title"];
        [self style:[[DOM alloc] initWithView:title parent:nil] design:design config:config];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
}



+(void)navigationbar_ion_icon:(UILabel *)btn config:(Config *)config{
    @try {
        NSDictionary *designs = [config.design objectForKey:@"design"];
        NSDictionary *design = [designs objectForKey:@"navigation_ion_icon"];
        [self style:[[DOM alloc] initWithView:btn parent:nil] design:design config:config];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
+(void)navigationbar_fa_icon:(UILabel *)btn config:(Config *)config{
    @try {
        NSDictionary *designs = [config.design objectForKey:@"design"];
        NSDictionary *design = [designs objectForKey:@"navigation_fa_icon"];
        [self style:[[DOM alloc] initWithView:btn parent:nil] design:design config:config];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    /*if ([config.app_template isEqualToString:@"Vargus"]){
     btn.textColor = [UIColor whiteColor];
     btn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:28];
     
     //customization
     NSString *bgcolor = [config.customization objectForKey:@"header_background"];
     if ([bgcolor isEqualToString:@"black"]){
     btn.textColor = [UIColor whiteColor];
     }if ([bgcolor isEqualToString:@"white"]){
     
     btn.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
     
     }if ([bgcolor isEqualToString:@"blue"]){
     btn.textColor = [UIColor whiteColor];
     }
     }if ([config.app_template isEqualToString:@"Delvin"]){
     btn.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
     btn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:28];
     }if ([config.app_template isEqualToString:@"Mobi"]){
     btn.textColor = [UIColor whiteColor];
     btn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:28];
     }*/
}

+(void)navigationbar_seg:(UISegmentedControl *)btn config:(Config *)config{
    @try {
        NSDictionary *designs = [config.design objectForKey:@"design"];
        NSDictionary *design = [designs objectForKey:@"navigation_icon"];
        [self style:[[DOM alloc] initWithView:btn parent:nil] design:design config:config ];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    /*
     if ([config.app_template isEqualToString:@"Vargus"]){
     btn.tintColor = [UIColor whiteColor];
     //btn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:28];
     
     //customization
     NSString *bgcolor = [config.customization objectForKey:@"header_background"];
     if ([bgcolor isEqualToString:@"black"]){
     btn.tintColor = [UIColor whiteColor];
     }if ([bgcolor isEqualToString:@"white"]){
     
     btn.tintColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
     
     }if ([bgcolor isEqualToString:@"blue"]){
     btn.tintColor = [UIColor whiteColor];
     }
     }if ([config.app_template isEqualToString:@"Delvin"]){
     btn.tintColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
     //btn.font = [UIFont fontWithName:kFontAwesomeFamilyName size:28];
     }if ([config.app_template isEqualToString:@"Mobi"]){
     btn.tintColor = [UIColor whiteColor];
     
     }*/
}
+(void)promotion_init_multiView:(UIView *)view config:(Config *)config{
    view.frame = CGRectMake(0, 0, config.screenWidth, config.screenHeight-64);;
}
+(void)promotion_multiPageView:(MultiPageView *)view config:(Config *)config{
    @try {
        //view.frame = CGRectMake(0, 0, config.screenWidth, config.screenHeight-64);;
        NSDictionary *designs = [config.design objectForKey:@"design"];
        NSMutableDictionary *design = [designs objectForKey:@"collection_multi_page_view"];
        [self style:[[DOM alloc] initWithView:view parent:nil] design:design config:config];
        
        
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
}

+(void)promotion_multiPageInfinateView:(MultiPageInfinateView *)view config:(Config *)config{
    @try {
        view.frame = CGRectMake(0, 0, config.screenWidth, config.screenHeight-64);
        NSDictionary *designs = [config.design objectForKey:@"design"];
        NSMutableDictionary *design = [designs objectForKey:@"collection_multi_page_view"];
        
        [self style:[[DOM alloc] initWithView:view parent:nil] design:design config:config];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    
}


+(void)department_social_page:(MPPage *)page config:(Config *)config{
    /*if ([config.app_template isEqualToString:@"Vargus"] || [config.app_template isEqualToString:@"Mobi"]){
     [page setScrollBackground:[UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1]];
     } else if ([config.app_template isEqualToString:@"Delvin"]){
     [page setScrollBackground:[UIColor whiteColor]];
     }*/
    // NSDictionary *designs = [config.design objectForKey:@"design"];
    // NSMutableDictionary *design = [designs objectForKey:@"mppage_social_scroll"];
    // [self style:[[DOM alloc] initWithView:page.scroll parent:nil] design:design config:config];
    
}
+(void)department_facebook:(NSMutableDictionary *)facebookViews config:(Config *)config prevFrame:(CGRect)prev{
    
    CGSize main = CGSizeMake(config.screenWidth, 0);
    
    
    UILabel *name = [facebookViews objectForKey:@"author"];
    name.frame = CGRectMake(60, 10, 180, 15);
    
    
    
    
    UITextView *text = [facebookViews objectForKey:@"text"];
    text.frame = CGRectMake(55, 28, main.width-65, 0);
    text.contentInset = UIEdgeInsetsMake(-4,0, 0, 0);
    CGSize size = [text sizeThatFits:CGSizeMake(text.frame.size.width, FLT_MAX)];
    CGRect frame = text.frame;
    frame.size.height = size.height+8;
    text.frame = frame;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text.text];
    [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1] range:NSMakeRange(0, str.length)];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
    NSArray *matches = [regex matchesInString:text.text options:0 range:NSMakeRange(0, text.text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:0];
        [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:103/255.0 green:138/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(wordRange.location, wordRange.length)];
    }
    
    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    matches = [detect matchesInString:text.text options:0 range:NSMakeRange(0, [text.text length])];
    for (NSTextCheckingResult *m in matches) {
        NSRange wordRange = [m rangeAtIndex:0];
        [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:103/255.0 green:138/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(wordRange.location, wordRange.length)];
    }
    
    text.text = @"";
    text.attributedText = str;
    text.font = [UIFont systemFontOfSize:12];
    
    
    UIImageView *img = [facebookViews objectForKey:@"image"];
    if (img.hidden == NO){
        img.frame = CGRectMake(60,0, main.width-70, (main.width-70)/719*480);
        //img.layer.borderWidth = 0.5;
        //img.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        frame = img.frame;
        frame.origin.y = text.frame.origin.y+ text.frame.size.height;
        img.frame = frame;
        
    } else {
        img.frame =CGRectMake(0, text.frame.origin.y+ text.frame.size.height, 0, 0);
    }
    
    UIView *shareview = [facebookViews objectForKey:@"share_pane"];
    shareview.frame = CGRectMake(-1,0, main.width+2, 30);
    //shareview.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
    
    
    //CALayer *border = [CALayer layer];
    //border.frame =CGRectMake(0, 0, main.width, 0.5);
    //border.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //[shareview.layer addSublayer:border];
    frame = shareview.frame;
    frame.origin.y = img.frame.origin.y + img.frame.size.height+8;
    shareview.frame = frame;
    
    
    
    
    
    UIView *face = [facebookViews objectForKey:@"main"];
    CGFloat height = shareview.frame.origin.y+shareview.frame.size.height;
    
    face.frame = CGRectMake(-1, prev.origin.y+prev.size.height-0.5, config.screenWidth+2, height);
    //face.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //face.layer.borderWidth = 0.5;
    face.backgroundColor = [UIColor whiteColor];
    
    CALayer *top = [CALayer layer];
    top.frame = CGRectMake(0, 0, face.frame.size.width, 0.3);
    top.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [face.layer addSublayer:top];
    
    /*CALayer *left = [CALayer layer];
     left.frame = CGRectMake(0, 0, 0.3, face.frame.size.height);
     left.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
     [face.layer addSublayer:left];
     
     CALayer *right = [CALayer layer];
     right.frame = CGRectMake(face.frame.size.width-0.5, 0, 0.5, face.frame.size.height);
     right.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
     [face.layer addSublayer:right];
     
     CALayer *bottom = [CALayer layer];
     bottom.frame = CGRectMake(0, face.frame.size.height, face.frame.size.width, 1);
     bottom.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
     [face.layer addSublayer:bottom];*/
    //face.frame = CGRectMake(5, prev.origin.y+prev.size.height, config.screenWidth -10, height);
    
    
    
}
/*
 +(void)department_facebook:(NSMutableDictionary *)facebookViews config:(Config *)config prevFrame:(CGRect)prev{
 
 CGSize main = CGSizeMake(config.screenWidth-20, 0);
 
 
 UIImageView *icon = [facebookViews objectForKey:@"appicon"];
 icon.frame = CGRectMake(10, 13, 40, 40);
 icon.layer.borderWidth = 0.5;
 icon.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 icon.layer.cornerRadius = 5;
 
 UILabel *name = [facebookViews objectForKey:@"author"];
 name.frame = CGRectMake(55, 8, 180, 25);
 name.textColor = [UIColor colorWithRed:59/255.0 green:89/255.0 blue:152/255.0 alpha:1];
 name.font = [UIFont boldSystemFontOfSize:14];
 
 UILabel *time = [facebookViews objectForKey:@"time"];
 time.frame = CGRectMake(55, 22, 180, 25);
 time.font = [UIFont systemFontOfSize:14];
 time.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
 time.font = [UIFont systemFontOfSize:11];
 
 
 
 UITextView *text = [facebookViews objectForKey:@"text"];
 text.frame = CGRectMake(5, 60, main.width-10, 0);
 CGSize size = [text sizeThatFits:CGSizeMake(text.frame.size.width, FLT_MAX)];
 CGRect frame = text.frame;
 frame.size.height = size.height+8;
 text.frame = frame;
 NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text.text];
 [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1] range:NSMakeRange(0, str.length)];
 NSError *error = nil;
 NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
 NSArray *matches = [regex matchesInString:text.text options:0 range:NSMakeRange(0, text.text.length)];
 for (NSTextCheckingResult *match in matches) {
 NSRange wordRange = [match rangeAtIndex:0];
 [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:103/255.0 green:138/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(wordRange.location, wordRange.length)];
 }
 
 NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
 matches = [detect matchesInString:text.text options:0 range:NSMakeRange(0, [text.text length])];
 for (NSTextCheckingResult *m in matches) {
 NSRange wordRange = [m rangeAtIndex:0];
 [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:103/255.0 green:138/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(wordRange.location, wordRange.length)];
 }
 
 text.text = @"";
 text.attributedText = str;
 text.font = [UIFont systemFontOfSize:12];
 
 
 UIImageView *img = [facebookViews objectForKey:@"image"];
 if (img.hidden == NO){
 img.frame = CGRectMake(0 ,text.frame.origin.y+ text.frame.size.height, main.width, (main.width)/719*480);
 //img.layer.borderWidth = 0.5;
 //img.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 frame = img.frame;
 frame.origin.y = text.frame.origin.y+ text.frame.size.height;
 img.frame = frame;
 
 } else {
 img.frame =CGRectMake(0, text.frame.origin.y+ text.frame.size.height, 0, 0);
 }
 
 UIView *shareview = [facebookViews objectForKey:@"share_pane"];
 shareview.frame = CGRectMake(0,0, main.width, 30);
 //CALayer *border = [CALayer layer];
 //border.frame =CGRectMake(0, 0, main.width, 0.5);
 //border.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 //[shareview.layer addSublayer:border];
 frame = shareview.frame;
 frame.origin.y = img.frame.origin.y + img.frame.size.height;
 shareview.frame = frame;
 
 
 UILabel *sharebtn = [facebookViews objectForKey:@"share_btn"];
 sharebtn.frame = CGRectMake(shareview.frame.size.width-60, -3, 60, 30);
 sharebtn.font = [UIFont systemFontOfSize:12];
 sharebtn.textColor = [UIColor lightGrayColor];
 sharebtn.textAlignment = NSTextAlignmentCenter;
 
 
 UIView *face = [facebookViews objectForKey:@"main"];
 CGFloat height = shareview.frame.origin.y+shareview.frame.size.height;
 
 face.frame = CGRectMake(10, prev.origin.y+prev.size.height+15, config.screenWidth-20, height);
 //face.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 //face.layer.borderWidth = 0.5;
 face.backgroundColor = [UIColor whiteColor];
 
 CALayer *top = [CALayer layer];
 top.frame = CGRectMake(0, 0, face.frame.size.width, 0.3);
 top.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 [face.layer addSublayer:top];
 
 CALayer *left = [CALayer layer];
 left.frame = CGRectMake(0, 0, 0.3, face.frame.size.height);
 left.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 [face.layer addSublayer:left];
 
 CALayer *right = [CALayer layer];
 right.frame = CGRectMake(face.frame.size.width-0.5, 0, 0.5, face.frame.size.height);
 right.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 [face.layer addSublayer:right];
 
 CALayer *bottom = [CALayer layer];
 bottom.frame = CGRectMake(0, face.frame.size.height, face.frame.size.width, 1);
 bottom.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
 [face.layer addSublayer:bottom];
 //face.frame = CGRectMake(5, prev.origin.y+prev.size.height, config.screenWidth -10, height);
 
 
 
 }*/

+(void)department_twitter:(NSMutableDictionary *)twitterViews config:(Config *)config prevFrame:(CGRect)prev{
    CGSize main = CGSizeMake(config.screenWidth, 0);
    
   
    
    UILabel *name = [twitterViews objectForKey:@"author"];
    name.frame = CGRectMake(60, 10, 180, 15);
    
    
    
    
    
    
    UITextView *text = [twitterViews objectForKey:@"text"];
    text.frame = CGRectMake(55, 28, main.width-65, 0);
    text.contentInset = UIEdgeInsetsMake(-4,0, 0, 0);
    CGSize size = [text sizeThatFits:CGSizeMake(text.frame.size.width, FLT_MAX)];
    CGRect frame = text.frame;
    frame.size.height = size.height+8;
    text.frame = frame;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text.text];
    [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:0.302 green:0.302 blue:0.318 alpha:1] range:NSMakeRange(0, str.length)];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
    NSArray *matches = [regex matchesInString:text.text options:0 range:NSMakeRange(0, text.text.length)];
    for (NSTextCheckingResult *match in matches) {
        NSRange wordRange = [match rangeAtIndex:0];
        [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:103/255.0 green:138/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(wordRange.location, wordRange.length)];
    }
    
    NSDataDetector *detect = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    matches = [detect matchesInString:text.text options:0 range:NSMakeRange(0, [text.text length])];
    for (NSTextCheckingResult *m in matches) {
        NSRange wordRange = [m rangeAtIndex:0];
        [str addAttribute:NSForegroundColorAttributeName value:(id)[UIColor colorWithRed:103/255.0 green:138/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(wordRange.location, wordRange.length)];
    }
    
    text.text = @"";
    text.attributedText = str;
    text.font = [UIFont systemFontOfSize:12];
    
    UIImageView *img = [twitterViews objectForKey:@"image"];
    if (img.hidden == NO){
        img.frame = CGRectMake(60,0, main.width-70, (main.width-70)/719*480);
        //img.layer.borderWidth = 0.5;
        //img.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
        frame = img.frame;
        frame.origin.y = text.frame.origin.y+ text.frame.size.height+8;
        img.frame = frame;
    } else {
        img.frame =CGRectMake(60, text.frame.origin.y+ text.frame.size.height+8, 0, 0);
    }
    
    UIView *shareview = [twitterViews objectForKey:@"share_pane"];
    shareview.frame = CGRectMake(-1,0, main.width+2, 30);
    //shareview.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
    //CALayer *border = [CALayer layer];
    //border.frame =CGRectMake(0, 0, main.width, 0.5);
    //border.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    //[shareview.layer addSublayer:border];
    frame = shareview.frame;
    frame.origin.y = img.frame.origin.y + img.frame.size.height+8;
    shareview.frame = frame;
    
    
    
    UIView *face = [twitterViews objectForKey:@"main"];
    CGFloat height = shareview.frame.origin.y+shareview.frame.size.height;
    
    face.frame = CGRectMake(-1, prev.origin.y+prev.size.height-0.5, main.width+2, height);
    face.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    face.layer.borderWidth = 0.5;
    face.backgroundColor = [UIColor whiteColor];
    
    
    
}
+(void)product_filter:(NSMutableDictionary *)filter config:(Config *)config{
    if ([config.app_template isEqualToString:@"Vargus"] || [config.app_template isEqualToString:@"Delvin"] || [config.app_template isEqualToString:@"Mobi"]){
        UIButton *cancel = [filter objectForKey:@"cancel_btn"];
        [cancel setTitleColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1] forState:UIControlStateNormal];
        UIButton *clear = [filter objectForKey:@"clear_btn"];
        [clear setTitleColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1] forState:UIControlStateNormal];
        
        UILabel *titleLabel = [filter objectForKey:@"title_label"];
        titleLabel.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    }
}
+(void)product_page:(UIViewController *)page config:(Config *)config{
    if ([config.app_template isEqualToString:@"Vargus"] ){
        page.view.backgroundColor =  [UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1];
        
    }
    if ([config.app_template isEqualToString:@"Delvin"]){
        page.view.backgroundColor = [UIColor whiteColor];
    }
    if ([config.app_template isEqualToString:@"Mobi"]){
        page.view.backgroundColor =  [UIColor colorWithHue:240/360.0f saturation:0.02 brightness:0.96 alpha:1];
    }
    
}
+(void)product_search_bar:(UISearchBar *)searchbar config:(Config *)config{
    searchbar.clipsToBounds = YES;
    searchbar.searchBarStyle = UISearchBarStyleMinimal;
    // searchbar.barTintColor = [UIColor whiteColor];
    searchbar.backgroundColor = [UIColor whiteColor];
    //searchbar.tintColor = [UIColor whiteColor];
    
    searchbar.frame = CGRectMake(0, -0.5, config.screenWidth, searchbar.frame.size.height);
    
    CALayer *bott = [CALayer layer];
    bott.frame = CGRectMake(0.0f, searchbar.frame.size.height-0.5, searchbar.frame.size.width, 0.5);
    bott.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [searchbar.layer addSublayer:bott];
    CALayer *top = [CALayer layer];
    top.frame = CGRectMake(0.0f, 0, searchbar.frame.size.width, 0.5);
    top.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [searchbar.layer addSublayer:top];
    NSLog(@"%f",config.screenWidth);
    
    
}
+(CGRect)product_initial_frame:(int)prevProduct config:(Config *)config{
    if ([config.app_template isEqualToString:@"Vargus"] || [config.app_template isEqualToString:@"Delvin"] || [config.app_template isEqualToString:@"Mobi"]){
        int i = prevProduct;
        int line = i/2;
        return CGRectMake(160*(i%2)+1,(160.0 * 1.533+60)*line+44+1, 160.0f-2, 160*1.533+60-2);
    } else return CGRectMake(0, 0, 0, 0);
}

+(void)product:(NSMutableDictionary *)productView config:(Config *)config prevFrame:(CGRect)prev currentCount:(int)i{
    
    UIView *item = [productView objectForKey:@"main"];
    int line = i/2;
    item.frame =  CGRectMake(config.screenWidth/2*(i%2)+((i+1)%2+1)*2,((config.screenWidth/2-6) * 1.533+15+4)*line+44+4, config.screenWidth/2.0f-6, (config.screenWidth/2-6)*1.533+15);
    item.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [productView objectForKey:@"image"];
    image.frame = CGRectMake(2,2, item.frame.size.width-4, (item.frame.size.width-4)*1.255);
    image.backgroundColor = [UIColor whiteColor];
    
    if ([productView objectForKey:@"sold_out"] != nil){
        UILabel *sold = [productView objectForKey:@"sold_out"];
        sold.frame =  CGRectMake(0, 0, item.frame.size.width, 30);
        sold.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        sold.textColor = [UIColor redColor];
    }
    
    UILabel *brand= [productView objectForKey:@"brand"];
    brand.frame = CGRectMake(5, image.frame.origin.y+image.frame.size.height+3, item.frame.size.width-10, 12);
    brand.textAlignment=NSTextAlignmentLeft;
    brand.font=[UIFont systemFontOfSize:11];
    brand.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    
    UILabel *name = [productView objectForKey:@"name"];
    name.frame = CGRectMake(5, brand.frame.origin.y+brand.frame.size.height-1, item.frame.size.width-10, 30);
    name.textAlignment=NSTextAlignmentLeft;
    name.numberOfLines = 2;
    name.preferredMaxLayoutWidth =item.frame.size.width-10;
    name.lineBreakMode=NSLineBreakByWordWrapping;
    name.font=[UIFont boldSystemFontOfSize:11];
    name.textColor =[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    
    
    UILabel *price = [productView objectForKey:@"price"];
    price.frame = CGRectMake(5, name.frame.origin.y+name.frame.size.height+1, item.frame.size.width-10, 10);
    price.textAlignment = NSTextAlignmentLeft;
    NSString *sale = [productView objectForKey:@"sale"];
    if (sale != nil){
        /* price.frame = CGRectMake(0, item.frame.size.width*1.533+45, item.frame.size.width/2, 10);
         
         
         sale.frame = CGRectMake(item.frame.size.width/2, item.frame.size.width*1.533+45, item.frame.size.width/2, 10);
         sale.textAlignment=NSTextAlignmentLeft;
         sale.font=[UIFont systemFontOfSize:13];
         sale.textColor = [UIColor colorWithRed:204/255.0 green:76/255.0 blue:70/255.0 alpha:1];*/
    } else {
        price.font=[UIFont boldSystemFontOfSize:11];
        price.textColor =[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1];
    }
    
    UILabel *check = [productView objectForKey:@"check"];
    check.frame = CGRectMake(item.frame.size.width/2-15, item.frame.size.height/2-15, 30, 30);
    
    
    
}

+(void)product_detail:(NSMutableDictionary *)productDetail config:(Config *)config{
    UIButton *cart = [productDetail objectForKey:@"add_cart"];
    
    cart.backgroundColor = [UIColor whiteColor];
    cart.layer.borderColor =[[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    cart.layer.borderWidth = 0.5;
    cart.frame = CGRectMake(0, config.screenHeight-config.screenWidth * (60.0/320.0)-64, config.screenWidth+100, 51.3);
    
    
    UIView *cartview =[productDetail objectForKey:@"add_cart_view"];
    cartview.backgroundColor = [UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1];
    cartview.frame = CGRectMake(4, 4, config.screenWidth-8, cart.frame.size.height-8);
    
    UILabel *top = [productDetail objectForKey:@"add_cart_top"];
    top.frame = CGRectMake(0, cartview.frame.size.height/2-18, cartview.frame.size.width, 15);
    top.textAlignment = NSTextAlignmentCenter;
    top.textColor = [UIColor whiteColor];
    top.font = [UIFont systemFontOfSize:10];
    
    UILabel *bottom = [productDetail objectForKey:@"add_cart_bottom"];
    bottom.frame = CGRectMake(0, cartview.frame.size.height/2-3, cartview.frame.size.width, 20);
    bottom.textAlignment = NSTextAlignmentCenter;
    bottom.textColor = [UIColor whiteColor];
    bottom.font = [UIFont boldSystemFontOfSize:18];
    
    UILabel *middle = [productDetail objectForKey:@"add_cart_middle"];
    middle.frame = CGRectMake(0, 0, cartview.frame.size.width, cartview.frame.size.height);
    middle.textAlignment = NSTextAlignmentCenter;
    middle.textColor = [UIColor whiteColor];
    middle.font = [UIFont boldSystemFontOfSize:18];
    
    
    UIButton *var_sel_cancel = [productDetail objectForKey:@"var_sel_cancel"];
    [var_sel_cancel setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIButton *var_sel_done = [productDetail objectForKey:@"var_sel_done"];
    [var_sel_done setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    UIButton *var_sel_clear = [productDetail objectForKey:@"var_sel_clear"];
    [var_sel_clear setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIView *var_acc = [productDetail objectForKey:@"var_sel_view"];
    var_acc.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    
    
    
    CGFloat height = 0;
    UIScrollView *imgscroll = [productDetail objectForKey:@"image_scroll"];
    
    height+=(config.screenWidth-34)*1.403;
    imgscroll.frame = CGRectMake(0, 0, config.screenWidth, (config.screenWidth-34)*1.2+40);
    imgscroll.backgroundColor = [UIColor whiteColor];
    
    NSArray *images = [productDetail objectForKey:@"images"];
    NSArray *spinners = [productDetail objectForKey:@"spinners"];
    for (int i = 0 ; i < images.count; i++){
        ImageWithData *im = (ImageWithData *)[images objectAtIndex:i];
        im.frame = CGRectMake(17+config.screenWidth*i, 17, config.screenWidth-34, (config.screenWidth-34)*1.2);
        im.initial_frame = im.frame;
        
        
        UIActivityIndicatorView *indi = [spinners objectAtIndex:i];
        indi.frame = CGRectMake(im.frame.origin.x+im.frame.size.width/2-indi.frame.size.width/2, im.frame.origin.y+im.frame.size.height/2-indi.frame.size.height/2, indi.frame.size.width, indi.frame.size.height);
        
        
        
    }
    [imgscroll setContentSize:CGSizeMake(25+config.screenWidth*images.count, (config.screenWidth-34)*1.2)];
    
    
    
    UIButton *enlarge= [productDetail objectForKey:@"enlarge_btn"];
    enlarge.frame = CGRectMake(config.screenWidth-40, imgscroll.frame.origin.y+imgscroll.frame.size.height-20, 40, 20);
    enlarge.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:18];
    [enlarge setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [enlarge setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-expand"] forState:UIControlStateNormal];
    
    
    UIView *infopane = [productDetail objectForKey:@"info_pane"];
    infopane.frame = CGRectMake(-1, imgscroll.frame.origin.y+imgscroll.frame.size.height, config.screenWidth+1, 82);
    infopane.layer.borderWidth = 0.5;
    infopane.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    
    
    UILabel *brand = [productDetail objectForKey:@"brand"];
    brand.frame = CGRectMake(7, 8, config.screenWidth*0.7-14, 26);
    brand.font = [UIFont systemFontOfSize:14];
    brand.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    UITextView *name = [productDetail objectForKey:@"name"];
    name.contentInset = UIEdgeInsetsMake(-6, -6, 0, 0);
    name.frame = CGRectMake(7, 30, config.screenWidth*0.7-14, 60);
    name.font = [UIFont boldSystemFontOfSize:15];
    CGSize s =[name sizeThatFits:CGSizeMake(name.frame.size.width, FLT_MAX)];
    CGRect infof = infopane.frame;
    if (s.height <= 37) infof.size.height -= 20;
    infopane.frame = infof;
    //name.numberOfLines = 2;
    //name.lineBreakMode = NSLineBreakByWordWrapping;
    name.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    UILabel *price = [productDetail objectForKey:@"price"];
    price.frame =CGRectMake(config.screenWidth*0.7+10, 8, config.screenWidth*0.3-17, 26);
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont boldSystemFontOfSize:16];
    price.adjustsFontSizeToFitWidth = YES;
    
    
    
    UILabel *sale = [productDetail objectForKey:@"sale"];
    sale.frame =CGRectMake(config.screenWidth*0.7+10, 28, config.screenWidth*0.3-17, 26);
    sale.textAlignment = NSTextAlignmentRight;
    sale.font = [UIFont systemFontOfSize:16];
    sale.adjustsFontSizeToFitWidth = YES;
    sale.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    UIView *varview = [productDetail objectForKey:@"var_sel"];
    NSArray *varbtns = [productDetail objectForKey:@"var_btns"];
    if (varbtns.count > 0){
        for (int i = 0 ; i < varbtns.count; i++){
            UIButton *btn = [varbtns objectAtIndex:i];
            btn.frame = CGRectMake(3+(i%2)*config.screenWidth/2, 10+30*(i/2), config.screenWidth/2-6, 40);
            btn.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
            [btn setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
            
            UILabel *carrot = (UILabel *)[btn viewWithTag:1];
            carrot.frame = CGRectMake(btn.frame.size.width-25, btn.frame.size.height/2-10, 20, 20);
        }
        UIButton *last =[varbtns objectAtIndex:varbtns.count-1];
        varview.frame = CGRectMake(0, infopane.frame.origin.y+infopane.frame.size.height, config.screenWidth, last.frame.origin.y+last.frame.size.height+10);
    } else {
        varview.frame = CGRectMake(0, infopane.frame.origin.y+infopane.frame.size.height, config.screenWidth, 0);
    }
    
    SocialShareModule *ss = [productDetail objectForKey:@"share"];
    ss.frame = CGRectMake(7, varview.frame.origin.y+varview.frame.size.height, config.screenWidth-14, 100);
    CALayer *sslayer = [CALayer layer];
    sslayer.frame = CGRectMake(0, 0, ss.frame.size.width, 0.5);
    sslayer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [ss.layer addSublayer:sslayer];
    [ss layout_view];
    
    
    UILabel *destitle = [productDetail objectForKey:@"des_title"];
    destitle.frame = CGRectMake(7, 12, config.screenWidth-14, 25);
    destitle.font = [UIFont boldSystemFontOfSize:14];
    destitle.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    UITextView *tv = [productDetail objectForKey:@"web_size"];
    tv.font = [UIFont boldSystemFontOfSize:9];
    CGSize size = [tv sizeThatFits:CGSizeMake(config.screenWidth, FLT_MAX)];
    
    UIWebView *web = [productDetail objectForKey:@"web"];
    web.frame = CGRectMake(0, 25,config.screenWidth, 1);
    
    web.backgroundColor=[UIColor clearColor];
    web.opaque = NO;
    
    
    
    UIView *webback = [productDetail objectForKey:@"web_background"];
    webback.frame = CGRectMake(0, ss.frame.origin.y+ss.frame.size.height, config.screenWidth, web.frame.origin.y+web.frame.size.height+10);
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    layer.frame = CGRectMake(0, 0, webback.frame.size.width, 0.5);
    [webback.layer addSublayer:layer];
    webback.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroll = [productDetail objectForKey:@"main"];
    
    scroll.frame = CGRectMake(0, 0, config.screenWidth, config.screenHeight-50);;
    [scroll setContentSize:CGSizeMake(config.screenWidth, webback.frame.origin.y+webback.frame.size.height)];
    
    UIPageControl *img_page = [productDetail objectForKey:@"image_page"];
    
    img_page.frame = CGRectMake(40, imgscroll.frame.origin.y+imgscroll.frame.size.height-20, config.screenWidth-80, 20);
    img_page.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    img_page.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    img_page.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
}



+(void)finx_product_detail:(NSMutableDictionary *)productDetail config:(Config *)config{
    UIButton *cart = [productDetail objectForKey:@"add_cart"];
    
    cart.backgroundColor = [UIColor whiteColor];
    cart.layer.borderColor =[[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    cart.layer.borderWidth = 0.5;
    cart.frame = CGRectMake(0, config.screenHeight-51.3/*config.screenWidth * (60.0/320.0)*/-64, config.screenWidth+100, 51.3);
    
    
    UIView *cartview =[productDetail objectForKey:@"add_cart_view"];
    //cartview.backgroundColor = [UIColor colorWithRed:209.0/225.0 green:67.0/255.0 blue:67.0/255.0 alpha:1];
    cartview.frame = CGRectMake(4, 4, config.screenWidth-8, cart.frame.size.height-8);
    
    UILabel *top = [productDetail objectForKey:@"add_cart_top"];
    top.frame = CGRectMake(0, cartview.frame.size.height/2-18, cartview.frame.size.width, 15);
    top.textAlignment = NSTextAlignmentCenter;
    top.textColor = [UIColor whiteColor];
    top.font = [UIFont systemFontOfSize:10];
    
    UILabel *bottom = [productDetail objectForKey:@"add_cart_bottom"];
    bottom.frame = CGRectMake(0, cartview.frame.size.height/2-3, cartview.frame.size.width, 20);
    bottom.textAlignment = NSTextAlignmentCenter;
    bottom.textColor = [UIColor whiteColor];
    bottom.font = [UIFont boldSystemFontOfSize:18];
    
    UILabel *middle = [productDetail objectForKey:@"add_cart_middle"];
    middle.frame = CGRectMake(0, 0, cartview.frame.size.width, cartview.frame.size.height);
    middle.textAlignment = NSTextAlignmentCenter;
    middle.textColor = [UIColor whiteColor];
    middle.font = [UIFont boldSystemFontOfSize:18];
    
    
    UIButton *var_sel_cancel = [productDetail objectForKey:@"var_sel_cancel"];
    [var_sel_cancel setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIButton *var_sel_done = [productDetail objectForKey:@"var_sel_done"];
    [var_sel_done setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIButton *var_sel_clear = [productDetail objectForKey:@"var_sel_clear"];
    [var_sel_clear setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIView *var_acc = [productDetail objectForKey:@"var_sel_view"];
    var_acc.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    var_acc.opaque = YES;
    
    
    
    
    CGFloat height = 0;
    UIScrollView *imgscroll = [productDetail objectForKey:@"image_scroll"];
    
    height+=(config.screenWidth-64)*1.403;
    imgscroll.frame = CGRectMake(0, 0, config.screenWidth, (config.screenWidth-60)*1.333+40);
    imgscroll.backgroundColor = [UIColor whiteColor];
    
    NSArray *images = [productDetail objectForKey:@"images"];
    NSArray *spinners = [productDetail objectForKey:@"spinners"];
    for (int i = 0 ; i < images.count; i++){
        ImageWithData *im = (ImageWithData *)[images objectAtIndex:i];
        im.frame = CGRectMake(30+((config.screenWidth-45)*i), 17, config.screenWidth-60, (config.screenWidth-60)*1.333);
        //im.backgroundColor = [UIColor blackColor];
        im.initial_frame = im.frame;
        
        UIActivityIndicatorView *indi = [spinners objectAtIndex:i];
        indi.frame = CGRectMake(im.frame.origin.x+im.frame.size.width/2-indi.frame.size.width/2, im.frame.origin.y+im.frame.size.height/2-indi.frame.size.height/2, indi.frame.size.width, indi.frame.size.height);
        
    }
    [imgscroll setContentSize:CGSizeMake(25+config.screenWidth*images.count, (config.screenWidth-120)*1.333)];
    
    
    
    UITextView *name = [productDetail objectForKey:@"name"];
    
    
    UILabel *price = [productDetail objectForKey:@"price"];
    
    UIView *infopane = [productDetail objectForKey:@"info_pane"];
    infopane.frame = CGRectMake(-1, imgscroll.frame.origin.y+imgscroll.frame.size.height, config.screenWidth+1, price.frame.origin.y+price.frame.size.height+10);
    CALayer *layer = [CALayer layer];
    layer.backgroundColor =[[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    layer.frame = CGRectMake(0, 0, infopane.frame.size.width, 0.5);
    [infopane.layer addSublayer:layer];
    
    
    UILabel *brand = [productDetail objectForKey:@"brand"];
    brand.frame = CGRectMake(7, 8, config.screenWidth*0.7-14, 26);
    brand.font = [UIFont systemFontOfSize:14];
    brand.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    
    
    
    
    
    
    
    
    UIView *varview = [productDetail objectForKey:@"var_sel"];
    NSArray *varbtns = [productDetail objectForKey:@"var_btns"];
    if (varbtns.count > 0){
        for (int i = 0 ; i < varbtns.count; i++){
            UIButton *btn = [varbtns objectAtIndex:i];
            btn.frame = CGRectMake(10+(i%2)*config.screenWidth/2, (20+40)*(i/2), config.screenWidth/2-20, 51.3);
            btn.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
            btn.layer.borderWidth = 0.5;
            //btn.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
            [btn setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
            
            
            
            UILabel *carrot = (UILabel *)[btn viewWithTag:1];
            carrot.frame = CGRectMake(btn.frame.size.width-25, btn.frame.size.height/2-10, 20, 20);
            
        }
        UIButton *last =[varbtns objectAtIndex:varbtns.count-1];
        varview.frame = CGRectMake(0, infopane.frame.origin.y+infopane.frame.size.height+10, config.screenWidth, last.frame.origin.y+last.frame.size.height+30);
    } else {
        varview.frame = CGRectMake(0, infopane.frame.origin.y+infopane.frame.size.height, config.screenWidth, 20);
    }
    
    
    UIView *ssb = [productDetail objectForKey:@"share_background"];
    ssb.frame = CGRectMake(0, varview.frame.origin.y+varview.frame.size.height, config.screenWidth, 120);
    CALayer *sslayer = [CALayer layer];
    sslayer.frame = CGRectMake(0, 0, ssb.frame.size.width, 0.5);
    sslayer.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    [ssb.layer addSublayer:sslayer];
    
    
    SocialShareModule *ss = [productDetail objectForKey:@"share"];
    ss.frame = CGRectMake(20, 18, config.screenWidth-40, 100);
    
    [ss layout_view];
    
    
    UILabel *destitle = [productDetail objectForKey:@"des_title"];
    destitle.frame = CGRectMake(18, 18, config.screenWidth-14, 25);
    destitle.font = [UIFont boldSystemFontOfSize:18];
    destitle.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    UITextView *tv = [productDetail objectForKey:@"web_size"];
    tv.font = [UIFont boldSystemFontOfSize:9];
    CGSize size = [tv sizeThatFits:CGSizeMake(config.screenWidth, FLT_MAX)];
    
    UIWebView *web = [productDetail objectForKey:@"web"];
    UIView *webback = [productDetail objectForKey:@"web_background"];
    webback.frame = CGRectMake(0, ssb.frame.origin.y+ssb.frame.size.height, config.screenWidth, web.frame.origin.y+web.frame.size.height+20);
    CALayer *weblayer1 = [CALayer layer];
    weblayer1.backgroundColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    weblayer1.frame = CGRectMake(0, 0, webback.frame.size.width, 0.5);
    [webback.layer addSublayer:weblayer1];
    webback.clipsToBounds = NO;
    web.frame = CGRectMake(0, 25,webback.frame.size.width, 1);
    web.backgroundColor=[UIColor clearColor];
    web.opaque = NO;
    
    
    webback.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroll = [productDetail objectForKey:@"main"];
    
    scroll.frame = CGRectMake(0, 0, config.screenWidth, config.screenHeight-50);;
    [scroll setContentSize:CGSizeMake(config.screenWidth, webback.frame.origin.y+webback.frame.size.height)];
    
    UIPageControl *img_page = [productDetail objectForKey:@"image_page"];
    
    img_page.frame = CGRectMake(40, imgscroll.frame.origin.y+imgscroll.frame.size.height-20, config.screenWidth-80, 20);
    img_page.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    img_page.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    img_page.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
}



+(void)menu_table:(UITableView *)table config:(Config *)config{
    NSDictionary *designs = [config.design objectForKey:@"design"];
    NSMutableDictionary *design = [designs objectForKey:@"menu_table"];
    [self style:[[DOM alloc] initWithView:table parent:nil] design:design config:config];
}
+(void)menu_tableCell:(MenuTableCell *)cell config:(Config *)config;{
    
    NSDictionary *designs = [config.design objectForKey:@"design"];
    NSMutableDictionary *dcell = [designs objectForKey:@"menu_tablecell"];
    [self style:[[DOM alloc] initWithView:cell parent:nil] design:dcell config:config];
    NSMutableDictionary *dp = [designs objectForKey:@"menu_tablecell_primaryLabel"];
    [self style:[[DOM alloc] initWithView:cell.primaryLabel parent:nil] design:dp config:config];
    NSMutableDictionary *ds = [designs objectForKey:@"menu_tablecell_secondaryLabel"];
    [self style:[[DOM alloc] initWithView:cell.secondaryLabel parent:nil] design:ds config:config];
    NSMutableDictionary *dl = [designs objectForKey:@"menu_tablecell_leftImage"];
    [self style:[[DOM alloc] initWithView:cell.leftImage parent:nil] design:dl config:config];
    NSMutableDictionary *dr = [designs objectForKey:@"menu_tablecell_rightBut"];
    [self style:[[DOM alloc] initWithView:cell.rightBut parent:nil] design:dr config:config];
    
    
    
    
}



+(void)picker_accessory:(NSMutableDictionary *)pickerViews config:(Config *)config{
    
    UIButton *var_sel_cancel = [pickerViews objectForKey:@"picker_cancel"];
    [var_sel_cancel setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIButton *var_sel_done = [pickerViews objectForKey:@"picker_done"];
    [var_sel_done setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIButton *var_sel_clear = [pickerViews objectForKey:@"var_sel_clear"];
    [var_sel_clear setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    
    UIView *var_acc = [pickerViews objectForKey:@"picker_view"];
    
    
}

+(void)checkout_btn:(NSMutableDictionary *)checkBtnViews config:(Config *)config{
    UIButton *cart = [checkBtnViews objectForKey:@"main"];
    cart.frame = CGRectMake(1, cart.frame.origin.y, config.screenWidth-2, cart.frame.size.height);
    cart.backgroundColor = [UIColor whiteColor];
    cart.layer.borderColor =[[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    cart.layer.borderWidth = 0.5;
    
    
    UIView *cartview =[checkBtnViews objectForKey:@"checkout_view"];
    cartview.backgroundColor = [UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1];
    cartview.frame = CGRectMake(4, 4, cart.frame.size.width-8, 50-8);
    
    
    UILabel *middle = [checkBtnViews objectForKey:@"checkout_middle"];
    middle.frame = CGRectMake(0, 0, cartview.frame.size.width, cartview.frame.size.height);
    middle.textAlignment = NSTextAlignmentCenter;
    middle.textColor = [UIColor whiteColor];
    middle.font = [UIFont systemFontOfSize:18];
    
}

+(void)checkout_view_with_btn:(NSMutableDictionary *)checkBtnViews config:(Config *)config{
    
    UIView *main = [checkBtnViews objectForKey:@"main"];
    main.backgroundColor = [UIColor whiteColor];
    main.layer.borderColor =[[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    main.layer.borderWidth = 0.5;
    //main.frame = CGRectMake(-1, config.screenHeight-100, config.screenWidth+1, 100);
    
    UILabel *price = [checkBtnViews objectForKey:@"total_price"];
    price.frame = CGRectMake(0, 5, main.frame.size.width, 30);
    price.textAlignment = NSTextAlignmentCenter;
    price.font = [UIFont boldSystemFontOfSize:15];
    price.textColor =[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    UILabel *sale = [checkBtnViews objectForKey:@"total_save"];
    sale.frame = CGRectMake(0, 25, main.frame.size.width, 20);
    sale.textAlignment = NSTextAlignmentCenter;
    sale.font = [UIFont systemFontOfSize:12];
    sale.textColor =[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    
    
    
    UIButton *cart = [checkBtnViews objectForKey:@"checkout_btn"];
    cart.frame = CGRectMake(0, 50, main.frame.size.width, 50);
    cart.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView *cartview =[checkBtnViews objectForKey:@"checkout_view"];
    cartview.backgroundColor = [UIColor colorWithRed:0.231 green:0.349 blue:0.596 alpha:1];
    cartview.frame = CGRectMake(4, 4, main.frame.size.width-8, 50-8);
    
    
    UILabel *middle = [checkBtnViews objectForKey:@"checkout_middle"];
    middle.frame = CGRectMake(0, 0, cartview.frame.size.width, cartview.frame.size.height);
    middle.textAlignment = NSTextAlignmentCenter;
    middle.textColor = [UIColor whiteColor];
    middle.font = [UIFont systemFontOfSize:18];
    
}

@end
