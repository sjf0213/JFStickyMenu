//
//  JFStickyMenu.m
//  JFStickyMenuDemo
//
//  Created by 宋炬峰 on 2016/11/21.
//  Copyright © 2016年 songjufeng. All rights reserved.
//

#import "JFStickyMenu.h"

static const  CGFloat MenuLineH = 1.0f;

@interface JFStickyMenu()
@property(assign, nonatomic)NSInteger currIndex;
@property(nonatomic, assign)NSInteger itemCount;
@property(nonatomic, strong)UIScrollView* mainScroll;
@property(nonatomic, strong)NSMutableArray* itemArr;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UIView *seperator;
@end
@implementation JFStickyMenu

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.itemArr = [[NSMutableArray alloc] initWithCapacity:10];
        
        self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.mainScroll.backgroundColor = [UIColor clearColor];
        self.mainScroll.showsHorizontalScrollIndicator = NO;
        [self.mainScroll addSubview:self.lineView];
        [self addSubview:self.mainScroll];
        
        self.seperator = [[UIView alloc] initWithFrame:CGRectMake(0, JFMenuH - 0.5, 0, 0.5)];
        self.seperator.backgroundColor = [UIColor colorWithWhite:0xF1/255.0 alpha:1.0];
        [self addSubview:self.seperator];
        
        
        // 创建菜单项
        NSArray* modelArray = [self getMenuItemList];
        self.itemCount = [modelArray count];
        for (JFItemModel* model in modelArray) {
            
            JFMenuItem* item = [[JFMenuItem alloc] initWithItemModel:model];
            [self.mainScroll addSubview:item];
            [item addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.itemArr addObject:item];
        }
        // 初始选中
        if (self.itemArr.count > 0) {
            JFMenuItem* obj1 = self.itemArr[0];
            obj1.currSelected = YES;
            self.currIndex = 0;
            // 强制刷新
            [self setNeedsLayout];
        }
    }
    return self;
}

-(CGFloat)widthForItemAtIndex:(NSInteger)index{
    
    JFMenuItem* item = self.itemArr[index];
    NSString* title = item.model.itemName;
    
    // 根据字体动态计算宽度
    NSDictionary *attribute = @{NSFontAttributeName : item.titleFont};
    CGSize sz = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, JFMenuH) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    CGFloat w = sz.width + 24;
    return w;
}

-(void)layoutSubviews{
    self.mainScroll.frame = CGRectMake(0, 0, self.bounds.size.width, JFMenuH - 0.5);
    self.seperator.frame = CGRectMake(0, JFMenuH - 0.5, self.bounds.size.width, 0.5);
    CGFloat offset = 0;
    JFMenuItem* target = nil;
    for (int  i = 0; i < self.itemArr.count; i++) {
        JFMenuItem* item = self.itemArr[i];
        CGFloat w = [self widthForItemAtIndex:i];
        item.frame = CGRectMake(offset, item.frame.origin.y, w, item.frame.size.height);
        offset = offset  + w;
        if (item.currSelected) {
            target = item;
        }
    }
    self.mainScroll.contentSize = CGSizeMake(offset, JFMenuH-0.5);
    self.lineView.frame = CGRectMake(target.frame.origin.x+10, self.mainScroll.frame.size.height - MenuLineH-0.5, target.frame.size.width - 20, MenuLineH);
    [self moveOffsetToTargetItem:target];
    
}

-(void)onTapItem:(id)sender{
    JFMenuItem* item = (JFMenuItem*)sender;
    if (item.currSelected) {
        return;
    }
    // 去掉其他选中，选中当前选中
    for (JFMenuItem* one in self.itemArr) {
        if (one.currSelected) {
            one.currSelected = NO;
        }
    }
    item.currSelected = YES;
    self.currIndex = item.model.index;
    if ([item isKindOfClass:[JFMenuItem class]]) {
        if (self.tapItemHandler){
            self.tapItemHandler(item.model.index);
        }
    }
    // 强制刷新
    [self setNeedsLayout];
}

-(void)setCurrFloatPos:(CGFloat)pos{
    //    DLog(@"---pos:%.5f", pos);
    
    // 关于红线的跟手动画
    if (pos < 0) {
        JFMenuItem* item = self.itemArr[0];
        self.lineView.frame = CGRectMake(item.frame.origin.x+10, self.mainScroll.frame.size.height - MenuLineH-0.5, item.frame.size.width-20, MenuLineH);
    }else if (pos > self.itemArr.count-1) {
        JFMenuItem* item = self.itemArr[self.itemArr.count - 1];
        self.lineView.frame = CGRectMake(item.frame.origin.x+10, self.mainScroll.frame.size.height - MenuLineH-0.5, item.frame.size.width-20, MenuLineH);
    }else{
        NSInteger i = self.currIndex;
        if(self.currIndex < pos && pos < self.currIndex + 1){// 向右滑动
            CGFloat percent = pos - i;
            JFMenuItem* item1 = self.itemArr[i];
            JFMenuItem* item2 = self.itemArr[i+1];
            CGFloat a = [self curveFuncA:percent] * item1.frame.size.width;// 左侧随着变短的部分
            CGFloat b = [self curveFuncB:percent] * item2.frame.size.width;// 右侧随着变长的部分
            CGFloat x = item1.frame.origin.x + 10 + a;
            CGFloat w = (item1.frame.size.width - 20) - a + b;
            self.lineView.frame = CGRectMake(x, self.mainScroll.frame.size.height - MenuLineH-0.5, w, MenuLineH);
            
        }else if(self.currIndex > pos &&  pos > self.currIndex - 1 ){// 向左滑动
            CGFloat percent = i - pos;
            JFMenuItem* item1 = self.itemArr[i-1];
            JFMenuItem* item2 = self.itemArr[i];
            CGFloat a = [self curveFuncB:percent] * item1.frame.size.width;// 左侧随着变长的部分
            CGFloat b = [self curveFuncA:percent] * item2.frame.size.width;// 右侧随着变短的部分
            CGFloat x = item2.frame.origin.x + 10 - a;
            CGFloat w = (item2.frame.size.width - 20) + a - b;
            self.lineView.frame = CGRectMake(x, self.mainScroll.frame.size.height - MenuLineH-0.5, w, MenuLineH);
            
        }else{
            
        }
    }
}

-(UIColor*)mixColorBy:(CGFloat)per withC1:(UIColor*)c1 withC2:(UIColor*)c2{
    const CGFloat* c1Arr = CGColorGetComponents( c1.CGColor );
    CGFloat r1 = *c1Arr;
    CGFloat g1 = *(c1Arr + 1);
    CGFloat b1 = *(c1Arr + 2);
    
    const CGFloat* c2Arr = CGColorGetComponents( c2.CGColor );
    CGFloat r2 = *c2Arr;
    CGFloat g2 = *(c2Arr + 1);
    CGFloat b2 = *(c2Arr + 2);
    
    CGFloat r = (r1 * per + r2 * (1.0 - per));
    CGFloat g = (g1 * per + g2 * (1.0 - per));
    CGFloat b = (b1 * per + b2 * (1.0 - per));
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

-(CGFloat)curveFuncA:(CGFloat)x{
    return 1.0 - cos(asin(x));
}

-(CGFloat)curveFuncB:(CGFloat)x{
    return sin(acos(1-x));
}

-(void)setCurrSelected:(NSInteger)index{
    // 找到当前选中
    NSInteger curr = -1;
    for (int i = 0; i < self.itemArr.count; i++) {
        JFMenuItem* one = self.itemArr[i];
        if (one.currSelected) {
            curr = i;
        }
    }
    NSInteger target = index;
    if (curr == target) {
        return;
    }
    // 变化动画
    JFMenuItem* obj1 = self.itemArr[curr];
    obj1.currSelected = NO;
    obj1 = self.itemArr[target];
    obj1.currSelected = YES;
    
    self.currIndex = target;
    
    // 强制刷新
    [self setNeedsLayout];
}

-(void)moveOffsetToTargetItem:(JFMenuItem*)item{
    //计算应该滚动多少
    CGFloat needScrollOffsetX = item.center.x - self.mainScroll.bounds.size.width * 0.5;
    //最大允许滚动的距离
    CGFloat maxScrollOffsetX = self.mainScroll.contentSize.width - self.mainScroll.bounds.size.width;
    needScrollOffsetX = MAX(needScrollOffsetX, 0);
    needScrollOffsetX = MIN(needScrollOffsetX, maxScrollOffsetX);
    
    [self.mainScroll setContentOffset:CGPointMake(needScrollOffsetX, 0) animated:YES];
    
}

-(JFItemModel*)categoryModelInPosition:(NSInteger)index{
    if (self.itemArr.count > index) {
        JFMenuItem* item = self.itemArr[index];
        return item.model;
    }
    return nil;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
}


-(NSArray*)getMenuItemList{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"JFMenuItems" ofType:@"plist"];
    NSArray* basicArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray* rt = [NSMutableArray arrayWithArray:basicArr];
    NSMutableArray* modelArr = [NSMutableArray array];
    for (int i = 0; i < rt.count; i++) {
        NSDictionary* dic = rt[i];
        JFItemModel* model = [[JFItemModel alloc] initWithDic:dic];
        model.index = i;
        [modelArr addObject:model];
    }
    return modelArr;
}

@end
