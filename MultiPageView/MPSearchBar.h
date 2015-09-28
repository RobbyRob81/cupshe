//
//  MPSearchBar.h
//  Ecommerce
//
//  Created by apple on 14-8-11.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MPSearchBarDelegate;
@interface MPSearchBar : UIView <UITextFieldDelegate, UISearchBarDelegate>{
    UISearchBar *search;
    UISearchDisplayController *display;
    UITableViewController *search_content;
    //UIButton *cancelBtn;
}
@property (nonatomic, strong) NSString *pagename;
@property (nonatomic, strong) id <MPSearchBarDelegate> delegate;


-(void)createSearchBar;
-(void)cancel;
-(void)reset;
@end


@protocol MPSearchBarDelegate <NSObject>

-(void)mpSearchDidSearch:(NSString *)searchTerm;
-(void)mpSearchChanged:(NSString *)searchTerm;
-(void)mpSearchBegin;
-(void)mpSearchCancel;
@end