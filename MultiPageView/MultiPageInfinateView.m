//
//  MultiPageInfinate.m
//  Ecommerce
//
//  Created by apple on 14-8-15.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import "MultiPageInfinateView.h"

@implementation MultiPageInfinateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pages = [[NSMutableArray alloc] init];
        scroll = [[UIScrollView alloc] init];
        titleScroll = [[UIScrollView alloc] init];
        scroll.bounces = NO;
        scroll.userInteractionEnabled = YES;
        scroll.scrollEnabled = YES;
        scroll.decelerationRate = 0.1;
        titleScroll.bounces = NO;
        titleScroll.userInteractionEnabled = NO;
        titleScroll.backgroundColor = [UIColor whiteColor] ;
        scroll.delegate = self;
        titleScroll.delegate = self;
        search_display = [[UITableView alloc] init];
        search_display.separatorColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
        search_display.hidden = YES;
        search_display.delegate = self;
        search_display.dataSource = self;
        activeTitleColor = [UIColor lightGrayColor];
        inactiveTitleColor = [UIColor whiteColor];
        //lastOffSet = CGPointMake(0, 0);
        self.titleLabelWidth = 106.0;
        blocking_gestures = [[NSMutableArray alloc] init];
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


-(void)createPagesWithTitles:(NSMutableArray *)title ids:(NSMutableArray *)ids types:(NSMutableArray *)types{
    //add main scroll and title scroll
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (self.showTitle) {
        frame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40);
        titleScroll.frame=CGRectMake(0-self.headerBorderWidth, 0-self.headerBorderWidth, self.frame.size.width+2*self.headerBorderWidth, 40+self.headerBorderWidth);
        titleScroll.scrollEnabled = YES;
        titleScroll.decelerationRate = UIScrollViewDecelerationRateFast;
        titleScroll.layer.borderWidth = self.headerBorderWidth;
        titleScroll.layer.borderColor = [self.headerBorderColor CGColor];
        [titleScroll setShowsVerticalScrollIndicator:NO];
        [titleScroll setShowsHorizontalScrollIndicator:NO];
        
        
        /*UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(titlepan:)];
        pan.maximumNumberOfTouches = 1;
        pan.delegate = self;
        pan.delaysTouchesBegan = YES;
        [titleScroll addGestureRecognizer:pan];*/

        [self addSubview:titleScroll];
        
        CGRect gradframe = CGRectMake(titleScroll.frame.origin.x, titleScroll.frame.origin.y, titleScroll.frame.size.width, 40-self.headerBorderWidth);
        titleScrollGradient = [[UIView alloc] initWithFrame:gradframe];
        titleScrollGradient.userInteractionEnabled = NO;
        titleScrollGradient.backgroundColor = [UIColor clearColor];
        [self addSubview:titleScrollGradient];
        
        
        [titleScrollGradientLayer removeFromSuperlayer];
        
        titleScrollGradientLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = titleScrollOuterColor.CGColor;
        CGColorRef innerColor = titleScrollInnerColor.CGColor;
        
        titleScrollGradientLayer.colors = [NSArray arrayWithObjects:
                                           (__bridge id)outerColor,
                                           (__bridge id)innerColor,
                                           (__bridge id)innerColor,
                                           (__bridge id)outerColor, nil];
        
        titleScrollGradientLayer.locations = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0.0],
                                              [NSNumber numberWithFloat:0.25],
                                              [NSNumber numberWithFloat:0.75],
                                              [NSNumber numberWithFloat:1.0], nil];
        
        [titleScrollGradientLayer setStartPoint:CGPointMake(0, 0.5)];
        [titleScrollGradientLayer setEndPoint:CGPointMake(1, 0.5)];
        
        titleScrollGradientLayer.bounds = titleScrollGradient.bounds;
        titleScrollGradientLayer.anchorPoint = CGPointZero;
        
        [titleScrollGradient.layer addSublayer:titleScrollGradientLayer];
        
    }
    scroll.frame = frame;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollpan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    pan.delaysTouchesBegan = YES;
    [scroll addGestureRecognizer:pan];
    UISwipeGestureRecognizer *toright = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goleft)];
    toright.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *toleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goright)];
    toleft.direction = UISwipeGestureRecognizerDirectionLeft;
    toleft.delegate = self;
    toright.delegate = self;
    [scroll addGestureRecognizer:toleft];
    [scroll addGestureRecognizer:toright];
    
    
    scroll.scrollEnabled = NO;
    [scroll delaysContentTouches];
    
    [self addSubview:scroll];
   
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    
    int fontsize = 15;
    int longesttext = 0;
    for (NSString *text in title){
        if (longesttext < text.length){
            longesttext = text.length;
        }
    }
    if (longesttext == 10){
        fontsize = 13;
    }
    else if (longesttext == 11){
        fontsize = 12;
    }
    else if (longesttext >= 12){
        fontsize = 11;
    }
    
     CGRect displayframe = CGRectMake(0, 0, 0, 0);
    int count = 0;
    for (NSString *key in ids){
        //create page
        MPPage *p = [[MPPage alloc] init];
        p.pageid = key;
        p.pagename = [title objectAtIndex:count];
        p.searchbar_hidden = [[types objectAtIndex:count] boolValue];
        p.delegate = self;
        p.searchbar_borderColor = self.page_search_BorderColor;
        p.searchbar_borderWidth = self.page_search_borderWidth;
        p.page_borderColor = self.page_body_BorderColor;
        p.page_borderWidth = self.page_body_borderWidth;
       
        if (count == 0) {
            self.activePage = p;
            CGRect frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, scroll.frame.size.height);
            p.frame = frame;
            [p createPage];
            [pages addObject:p];
            [scroll addSubview:p];
            
            
        } else if (count == 1){
            CGRect frame = CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, scroll.frame.size.height);
            p.frame = frame;
            [p createPage];
            [pages addObject:p];
            [scroll addSubview:p];
            
          
        } else if (count == [ids count]-1){
            CGRect frame = CGRectMake(0, 0, self.frame.size.width, scroll.frame.size.height);
            p.frame = frame;
            [p createPage];
            [pages addObject:p];
            [scroll addSubview:p];
            
           
        } else {
            CGRect frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, scroll.frame.size.height);
            p.frame = frame;
            [p createPage];
            [pages addObject:p];
            [scroll addSubview:p];
        }
         if ([[types objectAtIndex:count] boolValue] == false){
        displayframe = CGRectMake(0, scroll.frame.origin.y+p.searchBar.frame.size.height, scroll.frame.size.width, scroll.frame.size.height-p.searchBar.frame.size.height+200);
         }
        
        /*UILabel *t =[[UILabel alloc] init];
        t.tag = count + 1;
        t.textAlignment = NSTextAlignmentCenter;
        t.textColor = [UIColor whiteColor];
        t.text = p.pagename;
        t.font= [UIFont systemFontOfSize:fontsize];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(title_sel:)];
        tap.numberOfTapsRequired = 1;
        t.userInteractionEnabled = YES;
        [t addGestureRecognizer:tap];
        [temptitle addObject:t];
        UILabel *t2 =[[UILabel alloc] init];
        t2.tag = count + 1;
        t2.textAlignment = NSTextAlignmentCenter;
        t2.textColor = [UIColor whiteColor];
        t2.text = p.pagename;
        t2.font = [UIFont systemFontOfSize:fontsize];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(title_sel:)];
        tap2.numberOfTapsRequired = 1;
        t2.userInteractionEnabled = YES;
        [t2 addGestureRecognizer:tap2];
        [temptitle2 addObject:t2];*/
        
        [titles addObject:p.pagename];
        
        
        count++;
    }
    [scroll setContentSize:CGSizeMake(self.frame.size.width*3, scroll.frame.size.height)];
    [scroll setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    search_display.frame=displayframe;
    search_display.hidden = YES;
    [self addSubview:search_display];
    
    [titleScroll setContentSize:CGSizeMake(self.titleLabelWidth*pages.count*21, titleScroll.contentSize.height)];
    titleMiddle = self.frame.size.width/3*(pages.count* 10-1);
    titleScroll.userInteractionEnabled = YES;
    titleLabels = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < pages.count*21+1; i++){
        int index = i % pages.count;
        NSString *name = [titles objectAtIndex:index];
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/3*i+self.frame.size.width/3/2-(self.titleLabelWidth/2), titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20)];
        t.tag = index;
        t.textAlignment = NSTextAlignmentCenter;
        t.text = name;
        t.font= [UIFont systemFontOfSize:fontsize];
        t.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(title_sel:)];
        tap.numberOfTapsRequired = 1;
        t.userInteractionEnabled = YES;
        [t addGestureRecognizer:tap];
        [titleScroll addSubview:t];
        if (t.tag == 0)
        t.textColor = activeTitleColor;
        else t.textColor = inactiveTitleColor;
        [titleLabels addObject:t];

    }
   
    /*
    UILabel *middle = [titles objectAtIndex:[temptitle count]];
    middle.textColor = activeTitleColor;
    UILabel *right1 = [titles objectAtIndex:[temptitle count] +1];
    UILabel *right2 = [titles objectAtIndex:[temptitle count] +2];
    UILabel *left1 = [titles objectAtIndex:[temptitle count] -1];
    UILabel *left2 = [titles objectAtIndex:[temptitle count] -2];
    
    middle.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*2, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
    right1.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*3, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
    right2.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*4, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
    left1.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*1, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
    left2.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*0, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
    
    */
    
    [titleScroll setContentOffset:CGPointMake(titleMiddle, 0)];
    currentTitleOffset = titleMiddle;
    [self.activePage checkNeedUpdate];
   
}
-(void)title_sel:(UITapGestureRecognizer *)ges{
    UILabel *titlelabel = (UILabel *)ges.view;
    int index = titlelabel.tag;
    int currentpage = (int)[pages indexOfObject:self.activePage];
    
    if (currentpage == 0){
        if (index == 1) [self goright];
        else if (index == [pages count] - 1) [self goleft];
    } else if (currentpage == [pages count] - 1){
        if (index == 0) [self goright];
        else if (index == currentpage - 1) [self goleft];
    } else {
        if (index < currentpage) [self goleft];
        else if (index > currentpage) [self goright];
    }
   
}
-(void)goleft{
    if (animating) return;
    [self scrollViewGoLeft:0];
    
}
-(void)goright{
    if (animating) return;
    [self scrollViewGoRight:0];
    
}

-(void)scrollpan:(UIPanGestureRecognizer *)panGesture{
    if (animating) return;
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint pt = [panGesture locationInView:scroll] ;
        panPoint = pt;
    }
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint pt = [panGesture locationInView:scroll] ;
        CGFloat offset = panPoint.x - pt.x;
        if (scroll.contentOffset.x >= 0 && scroll.contentOffset.x <= scroll.contentSize.width-self.frame.size.width){
            CGFloat movedis = scroll.contentOffset.x+offset;
            if (movedis < 0){
                
                [scroll setContentOffset:CGPointMake(0, 0)];
            }
            else if (movedis > scroll.contentSize.width-self.frame.size.width) {
                [scroll setContentOffset:CGPointMake(scroll.contentSize.width-self.frame.size.width, 0)];
            } else {
                [scroll setContentOffset:CGPointMake(movedis, 0)];
                
            }
            //panPoint = pt;
        }
      
        float scale = 3;
        //NSLog(@"%f %f", currentTitleOffset, currentTitleOffset+offset/scale);
        [titleScroll setContentOffset:CGPointMake(titleScroll.contentOffset.x+offset/scale, 0)];
    }
    if (panGesture.state == UIGestureRecognizerStateEnded){
        [self scrollDragged:scroll];
    }
    
    
}

-(void)scrollDragged:(UIScrollView *)scrollView{
    
    
    int page = 0;
    if (scroll.contentOffset.x > self.frame.size.width) page = 1;
    else page = 0;
    CGFloat extra = scroll.contentOffset.x-self.frame.size.width*page;
    
    
    
    if (page == 1){
        if (extra > self.frame.size.width/2-100){
            page++;
            [self scrollViewGoRight:0];
            
          //  [self scroll:scrollView animateTo:CGPointMake(self.frame.size.width*page,0)];
          //  [self scroll:titleScroll animateTo:CGPointMake((self.titleLabelWidth+10)*page, 0)];
          // self.activePage = [pages objectAtIndex:page];
          //  [self.activePage checkNeedUpdate];
        } else {
            //[scrollView setContentOffset:CGPointMake(self.frame.size.width*currentpage,0) animated:YES];
            [self scroll:scrollView animateTo:CGPointMake(self.frame.size.width,0)];
            [self scroll:titleScroll animateTo:CGPointMake(currentTitleOffset, 0)];
        }
    } else if (page == 0) {
        if (extra < self.frame.size.width/2+100){
            [self scrollViewGoLeft:0];
           
            //[self scroll:scrollView animateTo:CGPointMake(self.frame.size.width*page,0)];
           // [self scroll:titleScroll animateTo:CGPointMake((self.titleLabelWidth+10)*page, 0)];
           // self.activePage = [pages objectAtIndex:page];
           // [self.activePage checkNeedUpdate];
        } else {
            //[scrollView setContentOffset:CGPointMake(self.frame.size.width*currentpage,0) animated:YES];
            [self scroll:scrollView animateTo:CGPointMake(self.frame.size.width,0)];
            [self scroll:titleScroll animateTo:CGPointMake(currentTitleOffset, 0)];
        }
    }
    
}
-(void)scroll:(UIScrollView *)scrollView animateTo:(CGPoint)point{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         animating = YES;
                         [scrollView setContentOffset:point];
                         
                         
                     }
                     completion:^(BOOL finished){
                         animating = NO;
                     }];
}
-(void)scrollViewGoLeft:(int)recurse{
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         animating = YES;
                         //int pageindex = (int)[pages indexOfObject:self.activePage];
                         [scroll setContentOffset:CGPointMake(0, 0)];
                         [titleScroll setContentOffset:CGPointMake(currentTitleOffset-self.frame.size.width/3*1, 0)];
                         currentTitleOffset = titleScroll.contentOffset.x;
                        // pageindex = pageindex - 1;
                        // if (pageindex < 0) pageindex = (int)[pages count]-1;
                        // self.activePage = [pages objectAtIndex:pageindex];
                     }
                     completion:^(BOOL finished){
                         if (recurse > 0){
                             int re = recurse-1;
                             int pageindex = (int)[pages indexOfObject:self.activePage];
                             int activeindex = pageindex - 1;
                             if (activeindex < 0) activeindex = (int)[pages count]-1;
                             [self scrollViewGoLeft:re];
                             return;
                         }
                         for (MPPage *p in pages){
                             p.hidden = YES;
                         }
                         int pageindex = (int)[pages indexOfObject:self.activePage];
                         int activeindex = pageindex - 1;
                         if (activeindex < 0) activeindex = (int)[pages count]-1;
                         self.activePage = [pages objectAtIndex:activeindex];
                         int activeleft = activeindex-1;
                         if (activeleft < 0) activeleft = (int)[pages count]-1;
                         MPPage *left = [pages objectAtIndex:activeleft];
                         int activeright = activeindex+1;
                         if (activeright >= [pages count]) activeright = 0;
                         MPPage *right = [pages objectAtIndex:activeright];
                         
                         self.activePage.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, scroll.frame.size.height);
                         left.frame = CGRectMake(0, 0, self.frame.size.width, scroll.frame.size.height);
                         right.frame = CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, scroll.frame.size.height);
                         self.activePage.hidden = left.hidden=right.hidden = NO;
                         
                         [scroll setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
                         for (UILabel *l in titleLabels){
                             if (l.tag == activeindex){
                                 l.textColor = activeTitleColor;
                             } else {
                                 l.textColor = inactiveTitleColor;
                             }
                         }
                         
                         if ((titleMiddle - currentTitleOffset) == self.frame.size.width/3 * pages.count){
                             [titleScroll setContentOffset:CGPointMake(titleMiddle, 0)];
                             currentTitleOffset = titleMiddle;
                         }
                         
                         
                         
                        /* for (UILabel *l in titles){
                             l.frame = CGRectMake(-self.frame.size.width, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                             l.textColor = inactiveTitleColor;
                             [titleScroll addSubview:l];
                         }
                        
                         
                         int middleindex = (int)[temptitle count] + activeindex;
                         int right1index = (int)[temptitle count] + activeright;
                         int right2index = (int)[temptitle count] + activeright+1;
                         if ((int)[temptitle count] + activeright+1 >=[titles count]) right2index = 0;
                         int left1index = (int)[temptitle count] + activeleft;
                         int left2index = (int)[temptitle count] + activeleft-1;
                         if (left2index < 0)left2index = 0;
                         
                         UILabel *middle = [titles objectAtIndex:middleindex];
                         middle.textColor = activeTitleColor;
                         UILabel *right1 = [titles objectAtIndex:right1index];
                         UILabel *right2 = [titles objectAtIndex:right2index];
                         UILabel *left1 = [titles objectAtIndex:left1index];
                         UILabel *left2 = [titles objectAtIndex:left2index];
                         
                         middle.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*2, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         right1.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*3, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         right2.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*4, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         left1.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*1, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         left2.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*0, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         [titleScroll setContentOffset:CGPointMake(titleMiddle+self.frame.size.width/3*1, 0)];*/
                         
                         animating = NO;
                          [self.activePage checkNeedUpdate];
                     }];
}
-(void)scrollViewGoRight:(int)recurse{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         animating = YES;
                         //int pageindex = (int)[pages indexOfObject:self.activePage];
                         [scroll setContentOffset:CGPointMake(self.frame.size.width*2, 0)];
                         [titleScroll setContentOffset:CGPointMake(currentTitleOffset+self.frame.size.width/3*1, 0)];
                          currentTitleOffset = titleScroll.contentOffset.x;
                         // pageindex = pageindex - 1;
                         // if (pageindex < 0) pageindex = (int)[pages count]-1;
                         // self.activePage = [pages objectAtIndex:pageindex];
                     }
                     completion:^(BOOL finished){
                         if (recurse > 0){
                             int re = recurse-1;
                             int pageindex = (int)[pages indexOfObject:self.activePage];
                             int activeindex = pageindex + 1;
                             if (activeindex >= [pages count]) activeindex = 0;
                             [self scrollViewGoLeft:re];
                             return;
                         }
                         for (MPPage *p in pages){
                             p.hidden = YES;
                         }
                         int pageindex = (int)[pages indexOfObject:self.activePage];
                         int activeindex = pageindex + 1;
                         if (activeindex >= [pages count]) activeindex = 0;
                         self.activePage = [pages objectAtIndex:activeindex];
                         int activeleft = activeindex-1;
                         if (activeleft < 0) activeleft = (int)[pages count]-1;
                         MPPage *left = [pages objectAtIndex:activeleft];
                         int activeright = activeindex+1;
                         if (activeright >= [pages count]) activeright = 0;
                         MPPage *right = [pages objectAtIndex:activeright];
                         
                         self.activePage.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, scroll.frame.size.height);
                         left.frame = CGRectMake(0, 0, self.frame.size.width, scroll.frame.size.height);
                         right.frame = CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, scroll.frame.size.height);
                         self.activePage.hidden = left.hidden=right.hidden = NO;
                         [scroll setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
                         
                         
                         for (UILabel *l in titleLabels){
                             if (l.tag == activeindex){
                                 l.textColor = activeTitleColor;
                             } else {
                                 l.textColor = inactiveTitleColor;
                             }
                         }
                         
                         
                         if ((currentTitleOffset - titleMiddle) == self.frame.size.width/3 * pages.count){
                             [titleScroll setContentOffset:CGPointMake(titleMiddle, 0)];
                             currentTitleOffset = titleMiddle;
                         }
                         
                         
                         /*for (UILabel *l in titles){
                             l.frame = CGRectMake(-self.frame.size.width, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                             l.textColor = inactiveTitleColor;
                             [titleScroll addSubview:l];
                         }
                         int middleindex = (int)[temptitle count] + activeindex;
                         int right1index = (int)[temptitle count] + activeright;
                         int right2index = (int)[temptitle count] + activeright+1;
                         if ((int)[temptitle count] + activeright+1 >= [titles count]) right2index = 0;
                         int left1index = (int)[temptitle count] + activeleft;
                         int left2index = (int)[temptitle count] + activeleft-1;
                         if (left2index < 0)left2index = 0;
                         
                         UILabel *middle = [titles objectAtIndex:middleindex];
                         middle.textColor = activeTitleColor;
                         UILabel *right1 = [titles objectAtIndex:right1index];
                         UILabel *right2 = [titles objectAtIndex:right2index];
                         UILabel *left1 = [titles objectAtIndex:left1index];
                         UILabel *left2 = [titles objectAtIndex:left2index];
                         
                         middle.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*2, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         right1.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*3, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         right2.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*4, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         left1.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*1, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         left2.frame = CGRectMake(titleMiddle+self.frame.size.width/3/2-(self.titleLabelWidth/2)+self.frame.size.width/3*0, titleScroll.frame.size.height/2-10, self.titleLabelWidth, 20);
                         [titleScroll setContentOffset:CGPointMake(titleMiddle+self.frame.size.width/3*1, 0)];*/
                         //[titleScroll setContentOffset:CGPointMake(titleMiddle+self.frame.size.width/3*1, 0)];
                         animating = NO;
                          [self.activePage checkNeedUpdate];
                     }];
}



//title lable dragged
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate){
        if (titleScrolling) [self handleScrollViewStop];
        
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //[self scrollDragged:scrollView];
    if (titleScrolling) [self handleScrollViewStop];
    
}
-(void)handleScrollViewStop{
    titleScrolling = false;
    if (titleScroll.contentOffset.x <= 0){
        [titleScroll setContentOffset:CGPointMake(currentTitleOffset, 0) animated:NO];
        //currentTitleOffset = titleMiddle;
    } else if (titleScroll.contentOffset.x >= titleScroll.contentSize.width - titleScroll.frame.size.width){
        [titleScroll setContentOffset:CGPointMake(currentTitleOffset, 0) animated:NO];
        //currentTitleOffset = titleMiddle;
    } else {
        int count = (int)titleScroll.contentOffset.x/(int)(titleScroll.frame.size.width/3);
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             animating = YES;
                             //int pageindex = (int)[pages indexOfObject:self.activePage];
                             
                             if (currenttitledirection == 1){
                             [titleScroll setContentOffset:CGPointMake((count+1)*self.frame.size.width/3, 0)];
                             } else {
                                 [titleScroll setContentOffset:CGPointMake((count)*self.frame.size.width/3, 0)];
                             }
                             
                             // pageindex = pageindex - 1;
                             // if (pageindex < 0) pageindex = (int)[pages count]-1;
                             // self.activePage = [pages objectAtIndex:pageindex];
                         }
                         completion:^(BOOL finished){
                             int index = 0;
                             if (currenttitledirection == 1){
                                  index = (count+2)%pages.count;
                             } else {
                                  index = (count+1)%pages.count;
                             }
                             [titleScroll setContentOffset:CGPointMake(titleMiddle+index*titleScroll.frame.size.width/3, 0) animated:NO];
                             currentTitleOffset = titleScroll.contentOffset.x;
                             for (UILabel *l in titleLabels){
                                 if (l.tag == index){
                                     l.textColor = activeTitleColor;
                                 } else {
                                     l.textColor = inactiveTitleColor;
                                 }
                             }
                             int pageindex = (int)[pages indexOfObject:self.activePage];
                             int diff = 0;
                             if (initialtitledirection == -1){
                                 if (index < pageindex){
                                     diff = pageindex - index -1;
                                 } else if (index > pageindex) diff = pages.count-(index - pageindex)-1;
                                 else diff = -1;
                                 [self pageMoveLeft:diff];
                             } else {
                                 if (index > pageindex){
                                     diff = index - pageindex-1;
                                 } else if (index < pageindex) diff = pages.count-(pageindex - index)-1;
                                 else diff = -1;
                                 [self pageMoveRight:diff];
                             }
                             
                         }];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == titleScroll){
        if (!titleScrolling){
            initialTitleScrollOffset = titleScroll.contentOffset.x;
            titleScrolling = true;
            currentTitleOffset = titleScroll.contentOffset.x;
        }
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == titleScroll) {
        if (!titleScrolling) return;
        
        if (titleScroll.contentOffset.x >= initialTitleScrollOffset){
            initialtitledirection = +1;
        } else {
            initialtitledirection = -1;
        }
        
        if (titleScroll.contentOffset.x >= currentTitleOffset){
            currenttitledirection = +1;
            currentTitleOffset = titleScroll.contentOffset.x;
        } else {
            currenttitledirection = -1;
            currentTitleOffset = titleScroll.contentOffset.x;
        }
        
        
    }
}
//page move after title scrolls
-(void)pageMoveLeft:(int)recurse{
    if (recurse < 0) return;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         animating = YES;
                         [scroll setContentOffset:CGPointMake(0, 0)];
                         
                     }
                     completion:^(BOOL finished){
                         if (recurse > 0){
                             int re = recurse-1;
                             int pageindex = (int)[pages indexOfObject:self.activePage];
                             int activeindex = pageindex - 1;
                             if (activeindex < 0) activeindex = (int)[pages count]-1;
                             self.activePage = [pages objectAtIndex:activeindex];
                             [self pageMoveLeft:re];
                             
                             return;
                         }
                         for (MPPage *p in pages){
                             p.hidden = YES;
                         }
                         int pageindex = (int)[pages indexOfObject:self.activePage];
                         int activeindex = pageindex - 1;
                         if (activeindex < 0) activeindex = (int)[pages count]-1;
                         self.activePage = [pages objectAtIndex:activeindex];
                         int activeleft = activeindex-1;
                         if (activeleft < 0) activeleft = (int)[pages count]-1;
                         MPPage *left = [pages objectAtIndex:activeleft];
                         int activeright = activeindex+1;
                         if (activeright >= [pages count]) activeright = 0;
                         MPPage *right = [pages objectAtIndex:activeright];
                         
                         self.activePage.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, scroll.frame.size.height);
                         left.frame = CGRectMake(0, 0, self.frame.size.width, scroll.frame.size.height);
                         right.frame = CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, scroll.frame.size.height);
                         self.activePage.hidden = left.hidden=right.hidden = NO;
                         
                         [scroll setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];

                         
                         animating = NO;
                         [self.activePage checkNeedUpdate];
                     }];
}
-(void)pageMoveRight:(int)recurse{
    if (recurse < 0)return;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         animating = YES;
                         [scroll setContentOffset:CGPointMake(self.frame.size.width*2, 0)];
                         
                     }
                     completion:^(BOOL finished){
                         if (recurse > 0){
                             int re = recurse-1;
                             int pageindex = (int)[pages indexOfObject:self.activePage];
                             int activeindex = pageindex + 1;
                             if (activeindex >= [pages count]) activeindex = 0;
                             self.activePage = [pages objectAtIndex:activeindex];
                             [self pageMoveRight:re];
                             
                             return;
                         }
                         for (MPPage *p in pages){
                             p.hidden = YES;
                         }
                         int pageindex = (int)[pages indexOfObject:self.activePage];
                         int activeindex = pageindex + 1;
                         if (activeindex >= [pages count]) activeindex = 0;
                         self.activePage = [pages objectAtIndex:activeindex];
                         int activeleft = activeindex-1;
                         if (activeleft < 0) activeleft = (int)[pages count]-1;
                         MPPage *left = [pages objectAtIndex:activeleft];
                         int activeright = activeindex+1;
                         if (activeright >= [pages count]) activeright = 0;
                         MPPage *right = [pages objectAtIndex:activeright];
                         
                         self.activePage.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, scroll.frame.size.height);
                         left.frame = CGRectMake(0, 0, self.frame.size.width, scroll.frame.size.height);
                         right.frame = CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, scroll.frame.size.height);
                         self.activePage.hidden = left.hidden=right.hidden = NO;
                         [scroll setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
                         
                         
                         animating = NO;
                         [self.activePage checkNeedUpdate];
                     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    return self.searchResult.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *str = [self.searchResult objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [self.searchResult objectAtIndex:indexPath.row];
    [self.delegate mpSearchDidSearch:str inPage:self.activePage];
    
}

-(void)setTitleScrollBackground:(UIColor *)color{
    titleScroll.backgroundColor = color;
}
-(void)setTitleTextColor:(UIColor *)actColor inActiveColor:(UIColor *)inactColor{
    activeTitleColor = actColor;
    inactiveTitleColor = inactColor;
    
}
-(void)setTitleScrollGradient:(UIColor *)outer innercolor:(UIColor *)inner{
    titleScrollInnerColor = inner;
    titleScrollOuterColor = outer;

}

-(MPPage *)getPageByID:(NSString *)pageid{
    for (MPPage *p in pages){
        if ([p.pageid isEqualToString:pageid]){
            return p;
        }
    }
    return nil;
}
-(void)pageNeedsUpdate:(MPPage *)page{
    [self.delegate pageNeedsUpdate:page];
}
-(void)pageNeedsRefresh:(MPPage *)page{
    [self.delegate pageNeedsRefresh:page];
}
-(void)mpSearchDidSearch:(NSString *)terms{
    [self.delegate mpSearchDidSearch:terms inPage:self.activePage];
}
-(void)mpSearchBegin{
    search_display.hidden = NO;
}
-(void)mpSearchCancel{
    search_display.hidden = YES;
}
-(void)mpSearchChanged:(NSString *)searchTerm{
    self.searchResult = [self.delegate mpSearchChanged:searchTerm inPage:self.activePage];
    [search_display reloadData];
}

-(void)pageResign{
    [self.activePage pageResign];
}
-(void)startUpdatePage:(MPPage *)page{
    [NSThread detachNewThreadSelector:@selector(indicatorSpin) toTarget:page withObject:nil];
    page.updating = true;
}
-(void)endUpdatePage:(MPPage *)page{
    page.updating = false;
    [page indicatorStop];
}
-(void)blocking_gesture:(UIView *)ges{
    [blocking_gestures addObject:ges];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
   
    
    for (UIView *v in blocking_gestures){
        CGPoint touchLocation = [touch locationInView:v];
        
        if (CGRectContainsPoint(v.frame, touchLocation)){
            return NO;
        }
        
       // NSLog(@"%f, %f", touchLocation.x, touchLocation.y);
    }
   
    
    
    //Here you decide whether or not the two recognizers whould interact.
    return YES;
}

@end
