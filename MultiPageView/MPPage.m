//
//  MPPage.m
//  Ecommerce
//
//  Created by apple on 14-8-11.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import "MPPage.h"

@implementation MPPage
@synthesize searchBar, scroll;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scroll = [[UIScrollView alloc] init];
        scroll.delegate = self;
        searchBar = [[MPSearchBar alloc] init];
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.hidesWhenStopped = YES;
        refresh = [[UIRefreshControl alloc] init];
        [refresh addTarget:self action:@selector(pageRefresh:) forControlEvents:UIControlEventValueChanged];
        [scroll addSubview:refresh];
        
        self.hasMoreData = 1;
        self.updating = 0;
        height = 0.0;
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

-(void)createPage{
     CGRect frame = CGRectMake(0, 0-self.searchbar_borderWidth, self.frame.size.width, 40);
    if (!self.searchbar_hidden) {
        //CGRect frame = CGRectMake(0, 0, self.frame.size.width, 50);
        searchBar.frame = frame;
        searchBar.pagename = self.pagename;
        searchBar.delegate = self.delegate;
    
        [searchBar createSearchBar];
        [scroll addSubview:searchBar];
    } else {
        searchBar.frame=CGRectMake(0, 0, 0, 0);
    }
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [self.searchbar_borderColor CGColor];
    layer.frame = CGRectMake(0, 0, searchBar.frame.size.width, self.searchbar_borderWidth);
    [searchBar.layer addSublayer:layer];
    CALayer *layer2 = [CALayer layer];
    layer2.backgroundColor = [self.searchbar_borderColor CGColor];
    layer2.frame = CGRectMake(0, searchBar.frame.size.height-self.searchbar_borderWidth, searchBar.frame.size.width, self.searchbar_borderWidth);
    [searchBar.layer addSublayer:layer2];
    
    content = [[UIView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y+searchBar.frame.size.height, self.frame.size.width, 0)];
    [scroll addSubview:content];
    
    
    frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    scroll.frame = frame;
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, scroll.frame.size.height+1);
    [self addSubview:scroll];
    
     frame = indicator.frame;
    frame.origin.x = self.frame.size.width/2-frame.size.width/2;
    frame.origin.y = 160;
    indicator.frame = frame;
    [self addSubview:indicator];
    
    self.layer.borderWidth = self.page_borderWidth;
    self.layer.borderColor = [self.page_borderColor CGColor];
}

-(void)appendView:(UIView *)view withFrame:(CGRect)frame{
    view.frame = frame;
    
    [self.pageviews addObject:view];
    [content addSubview:view];
    height = frame.origin.y+frame.size.height+searchBar.frame.size.height;
    CGSize s = CGSizeMake(self.frame.size.width, height);
    NSLog(@"%f",scroll.frame.size.height);
    if (height < scroll.frame.size.height){
        s.height = scroll.frame.size.height+1;
    }
    [scroll setContentSize:s];
    frame = content.frame;
    frame.size.height = s.height;
    content.frame = frame;
}

-(void)setScrollBackground:(UIColor *)color{
    scroll.backgroundColor = color;
}


-(BOOL)checkNeedUpdate{

   
    if (scroll.contentOffset.y+scroll.frame.size.height+200 > scroll.contentSize.height && self.hasMoreData && !self.updating){
        NSLog(@"%d", self.hasMoreData);
        [self.delegate pageNeedsUpdate:self];
        return true;
    } else return false;
}

-(void)pageRefresh:(UIRefreshControl *)refresh{
    
    self.refreshing = 1;
    [self.delegate pageNeedsRefresh:self];
    
}

-(void)stopRefresh{
    [refresh endRefreshing];
    self.refreshing = 0;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (resetting == YES) return;
    [self checkNeedUpdate];
}
/*-(void)scrollDragged:(UIScrollView *)scrollView{
    [self checkNeedUpdate];
}*/

-(void)pageResign{
    [searchBar reset];
}
-(void)pageReset{
    [searchBar reset];
    
    for (int i = 0 ; i < self.pageviews.count; i++){
        UIView *v = [self.pageviews objectAtIndex:i];
        [v removeFromSuperview];
        v = nil;
        
    }
    [self.pageviews removeAllObjects];
    self.pageviews = nil;
    self.pageviews = [[NSMutableArray alloc] init];
    self.hasMoreData = 1;
    self.updating = 0;
    height = 0;
    resetting = YES;
    [scroll setContentOffset:CGPointMake(0, 0)];
    [scroll setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height+1)];
    resetting = NO;
}


-(CGRect)getScrollSize{
    return scroll.frame;
}
-(void)indicatorSpin{
    [indicator startAnimating];
}
-(void)indicatorStop{
    [indicator stopAnimating];
    
}

@end
