//
//  JFStickyMenu.h
//  JFStickyMenuDemo
//
//  Created by 宋炬峰 on 2016/11/21.
//  Copyright © 2016年 songjufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFMenuItem.h"

@interface JFStickyMenu : UIView

@property(readonly, nonatomic)NSInteger itemCount;
@property(readonly, nonatomic)NSInteger currIndex;
@property(copy, nonatomic)void(^tapItemHandler)(NSInteger index);
-(void)setCurrSelected:(NSInteger)index;// 由滑动引起
-(void)setCurrFloatPos:(CGFloat)pos;// 由滑动引起de浮点动态位置
-(JFItemModel*)categoryModelInPosition:(NSInteger)index;

@end
