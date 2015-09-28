//
//  MultiPageView.m
//  Ecommerce
//
//  Created by apple on 14-8-11.
//  Copyright (c) 2014年 Twixxies. All rights reserved.
//

#import "MultiPageView.h"

@implementation MultiPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pages = [[NSMutableArray alloc] init];
        scroll = [[UIScrollView alloc] init];
        titleScroll = [[UIView alloc] init];
        scroll.bounces = NO;
        scroll.userInteractionEnabled = YES;
        scroll.scrollEnabled = YES;
        scroll.decelerationRate = 0.1;
       // titleScroll.bounces = NO;
        titleScroll.userInteractionEnabled = YES;
        titleScroll.backgroundColor = [UIColor whiteColor] ;
        scroll.delegate = self;
        titleColor = [UIColor lightGrayColor];
        //titleScroll.delegate = self;
        //lastOffSet = CGPointMake(0, 0);
        search_display = [[UITableView alloc] init];
        search_display.separatorColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1];
        search_display.hidden = YES;
        search_display.delegate = self;
        search_display.dataSource = self;
        self.titleLabelWidth = 100.0;
        underline_height = 1;
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
        titleScroll.layer.borderWidth = self.headerBorderWidth;
        titleScroll.layer.borderColor = [self.headerBorderColor CGColor];
        [self addSubview:titleScroll];
        
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
    [scroll addGestureRecognizer:toleft];
    [scroll addGestureRecognizer:toright];
    
    scroll.scrollEnabled = NO;
    [scroll delaysContentTouches];
    [self addSubview:scroll];
    
    

    CGRect displayframe = CGRectMake(0, 0, 0, 0);
    int count = 0;
    int total = (int)[ids count];
    //figure out ideal font
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
    else if (longesttext == 12){
        fontsize = 11;
    } else if (longesttext > 12){
        fontsize = 9;
    }
    int title_count = 1;
    for (NSString *key in ids){
        //create page
        MPPage *p = [[MPPage alloc] init];
        p.pageid = key;
        p.pagename = [title objectAtIndex:count];
        p.searchbar_hidden = [[types objectAtIndex:count] boolValue];
        p.searchbar_borderColor = self.page_search_BorderColor;
        p.searchbar_borderWidth = self.page_search_borderWidth;
        p.page_borderColor = self.page_body_BorderColor;
        p.page_borderWidth = self.page_body_borderWidth;
        p.delegate = self;
        
        CGRect frame = CGRectMake(self.frame.size.width*count, 0, self.frame.size.width, scroll.frame.size.height);
        p.frame = frame;
        [p createPage];
        [pages addObject:p];
        [scroll addSubview:p];
        if (count == 0) {
            self.activePage = p;
        }
        //figure out search display position
        if ([[types objectAtIndex:count] boolValue] == false){
        displayframe = CGRectMake(0, scroll.frame.origin.y+p.searchBar.frame.size.height, scroll.frame.size.width, scroll.frame.size.height-p.searchBar.frame.size.height+200);
        }
        
        //create title
        UILabel *t =[[UILabel alloc] init];
        t.textAlignment = NSTextAlignmentCenter;
        t.textColor = titleColor;
        t.text = p.pagename;
        t.font = [UIFont systemFontOfSize:fontsize];
        t.adjustsFontSizeToFitWidth = NO;
        t.userInteractionEnabled = YES;
        frame = CGRectMake(self.frame.size.width/total/2-(self.titleLabelWidth/2)+self.frame.size.width/total*count, titleScroll.frame.size.height/2 - 20/2, self.titleLabelWidth, 20);
        t.frame = frame;
        t.tag = title_count;
        title_count++;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(title_sel:)];
        tap.numberOfTapsRequired = 1;
        t.userInteractionEnabled = YES;
        [t addGestureRecognizer:tap];
        [titleScroll addSubview:t];
        if (count == 0){
            underline = [[UIView alloc] init];
            underline.backgroundColor = titleColor;
            //underline.frame = CGRectMake(self.frame.size.width/total/2-(self.titleLabelWidth/2)+self.frame.size.width/total*0, 25, self.titleLabelWidth, 2);
            underline.frame = CGRectMake(0, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
            [titleScroll addSubview:underline];
        }
        count++;
    }
    [scroll setContentSize:CGSizeMake(self.frame.size.width*count, scroll.frame.size.height)];
    NSLog(@"%f", displayframe.origin.y);
    search_display.frame=displayframe;
    search_display.hidden = YES;
    [self addSubview:search_display];
    
    [self.activePage checkNeedUpdate];
}
-(void)title_sel:(UITapGestureRecognizer *)ges{
    UILabel *titlelabel = (UILabel *)ges.view;
    [self scroll:scroll animateTo:CGPointMake(self.frame.size.width*(titlelabel.tag-1),0)];
    int total = (int)pages.count;
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         underline.frame = CGRectMake(titleScroll.frame.size.width/total*(titlelabel.tag-1), titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
                         
                     }
                     completion:^(BOOL finished){
                         self.activePage = [pages objectAtIndex:titlelabel.tag-1];
                         [self.activePage checkNeedUpdate];
                     }];
}
-(void)goleft{
    int page = (int)scroll.contentOffset.x/self.frame.size.width;
    int total = (int)pages.count;
    if (page > 0){
        page--;
        [scroll setContentOffset:CGPointMake(self.frame.size.width*page,0) animated:YES];
        
        underline.frame = CGRectMake(titleScroll.frame.size.width/total*page, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
        //[titleScroll setContentOffset:CGPointMake((self.titleLabelWidth+10)*page, 0) animated:YES];
        self.activePage = [pages objectAtIndex:page];
        [self.activePage checkNeedUpdate];
    }
   // scroll.scrollEnabled = NO;
   // scroll.scrollEnabled = YES;
}
-(void)goright{
    int page = (int)scroll.contentOffset.x/self.frame.size.width;
    int total = (int)pages.count;
    if (page < [pages count]-1){
        page++;
        [scroll setContentOffset:CGPointMake(self.frame.size.width*page,0) animated:YES];
        
        underline.frame = CGRectMake(titleScroll.frame.size.width/total*page, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
       // [titleScroll setContentOffset:CGPointMake((self.titleLabelWidth+10)*page, 0) animated:YES];
        self.activePage = [pages objectAtIndex:page];
        [self.activePage checkNeedUpdate];
    }
   // scroll.scrollEnabled = NO;
   // scroll.scrollEnabled = YES;
}
-(void)scrollpan:(UIPanGestureRecognizer *)panGesture{
   int total = (int)pages.count;
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
        CGFloat mainoffset = scroll.contentOffset.x;
        float scale = [pages count];
       
        underline.frame = CGRectMake(mainoffset/scale, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
        //[titleScroll setContentOffset:CGPointMake(mainoffset/scale, 0)];
    }
    if (panGesture.state == UIGestureRecognizerStateEnded){
        [self scrollDragged:scroll];
    }
    
    
}

/*-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    scroll.scrollEnabled = NO;
    scroll.scrollEnabled = YES;
    //if (!decelerate){
    //[self scrollDragged:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
    if (!decelerate){
        [self scrollDragged:scrollView];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollDragged:scrollView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == scroll) {
        CGFloat offset = scroll.contentOffset.x;
        float scale = self.frame.size.width/100;
    
        [titleScroll setContentOffset:CGPointMake(offset/scale, 0)];
    
        for (MPPage *p in pages){
            [p pageResign];
        }
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == scroll) {
        int page = (int)scroll.contentOffset.x/self.frame.size.width;
        //[titleScroll setContentOffset:CGPointMake((self.titleLabelWidth+10)*page, 0) animated:YES];
        [self scroll:titleScroll animateTo:CGPointMake((self.titleLabelWidth+10)*page, 0)];
    }
}*/


-(void)scrollDragged:(UIScrollView *)scrollView{
    int currentpage = (int)[pages indexOfObject:self.activePage];
    int page = (int)scroll.contentOffset.x/self.frame.size.width;
    CGFloat extra = scroll.contentOffset.x-self.frame.size.width*page;
    
    int total = (int)pages.count;
    
    if (currentpage <= page){
        if (extra > self.frame.size.width/2-100 && currentpage < [pages count]){
            page++;
            [self scroll:scrollView animateTo:CGPointMake(self.frame.size.width*page,0)];
            
            //underline.frame = CGRectMake(self.frame.size.width/[pages count]/2-(self.titleLabelWidth/2)+self.frame.size.width/[pages count]*page, 25, self.titleLabelWidth, 2);
            underline.frame = CGRectMake(titleScroll.frame.size.width/total*page, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
            self.activePage = [pages objectAtIndex:page];
            [self.activePage checkNeedUpdate];
        } else {
           [self scroll:scrollView animateTo:CGPointMake(self.frame.size.width*currentpage,0)];
            //underline.frame = CGRectMake(self.frame.size.width/[pages count]/2-(self.titleLabelWidth/2)+self.frame.size.width/[pages count]*currentpage, 25, self.titleLabelWidth, 2);
            underline.frame = CGRectMake(titleScroll.frame.size.width/total*page, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
            
        }
    } else if (currentpage > 0) {
        if (extra > self.frame.size.width/2-100){
            
            [self scroll:scrollView animateTo:CGPointMake(self.frame.size.width*page,0)];
           
            //underline.frame = CGRectMake(self.frame.size.width/[pages count]/2-(self.titleLabelWidth/2)+self.frame.size.width/[pages count]*page, 25, self.titleLabelWidth, 2);
            underline.frame = CGRectMake(titleScroll.frame.size.width/total*page, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
            self.activePage = [pages objectAtIndex:page];
            [self.activePage checkNeedUpdate];
        } else {
             [self scroll:scrollView animateTo:CGPointMake(self.frame.size.width*currentpage,0)];
            //underline.frame = CGRectMake(self.frame.size.width/[pages count]/2-(self.titleLabelWidth/2)+self.frame.size.width/[pages count]*currentpage, 25, self.titleLabelWidth, 2);
            underline.frame = CGRectMake(titleScroll.frame.size.width/total*page, titleScroll.frame.size.height-underline_height-1, titleScroll.frame.size.width/total, underline_height);
            
        }
    }
    
}
-(void)scroll:(UIScrollView *)scrollView animateTo:(CGPoint)point{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentOffset:point];
                         
                         
                     }
                     completion:^(BOOL finished){
                         
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
-(void)setTitleTextColor:(UIColor *)color{
    for (UILabel *l in titleScrollTitle){
        l.textColor = color;
    }
    underline.backgroundColor = color;
    titleColor = color;
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
    search_display.hidden = YES;
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
