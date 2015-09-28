//
//  MPSearchBar.m
//  Ecommerce
//
//  Created by apple on 14-8-11.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import "MPSearchBar.h"

@implementation MPSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        search = [[UISearchBar alloc] initWithFrame:frame];
        search.delegate = self;
       
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)createSearchBar{
    
    //CGRect frame = CGRectMake(10.0, self.frame.size.height/2-text.frame.size.height/2, self.frame.size.width-20, 30.0);
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    search.frame = frame;
    //text.textColor = [UIColor darkGrayColor];
    search.placeholder = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Search", @"Search"), self.pagename];
    //text.borderStyle=UITextBorderStyleRoundedRect;
    search.barTintColor = [UIColor whiteColor];
    search.tintColor = [UIColor grayColor];
    search.searchBarStyle = UISearchBarStyleMinimal;
    //[text setLeftViewMode:UITextFieldViewModeAlways];
    //text.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow.png"]];
    [self addSubview:search];
   
   
    self.backgroundColor = [UIColor whiteColor];
    //CALayer *bott = [CALayer layer];
    //bott.frame = CGRectMake(0.0f, self.frame.size.height-1, self.frame.size.width, 1);
    //bott.backgroundColor = [[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1] CGColor];
    //[self.layer addSublayer:bott];
    self.clipsToBounds = YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [search setShowsCancelButton:YES animated:YES];
    [self.delegate mpSearchBegin];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.delegate mpSearchChanged:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
   // if (search.text.length > 0){
        [search setShowsCancelButton:NO animated:YES];
        [search resignFirstResponder];
        NSString *searchstr = search.text;
        
        [self.delegate mpSearchDidSearch:searchstr];
        
   // }
        
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self reset];
    [self.delegate mpSearchCancel];
}

/*
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = CGRectMake(10, self.frame.size.height/2-text.frame.size.height/2, self.frame.size.width-30-cancelBtn.frame.size.width, 30);
                         text.frame = frame;
                         frame = CGRectMake(self.frame.size.width-10-cancelBtn.frame.size.width, self.frame.size.height/2-text.frame.size.height/2, 60, 30);
                         cancelBtn.frame = frame;
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [text resignFirstResponder];
   // if (text.text.length > 0){
        
        NSString *searchstr = text.text;
        
        [self.delegate mpSearchDidSearch:searchstr];
        
  //  }
    [self cancel];

    return YES;
}
 */



-(void)reset{
    [search resignFirstResponder];
    search.text = @"";
     [search setShowsCancelButton:NO animated:YES];
}


@end
