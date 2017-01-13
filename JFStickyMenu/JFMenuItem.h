//
//  JFMenuItem.h
//  JFStickyMenuDemo
//
//  Created by 宋炬峰 on 2016/11/21.
//  Copyright © 2016年 songjufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat JFMenuH = 40.0f;

@interface JFItemModel:NSObject
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, strong)NSString* itemName;
@property(nonatomic, assign)NSInteger itemID;
-(instancetype)initWithDic:(NSDictionary*)dic;
@end

@interface JFMenuItem : UIControl
@property(nonatomic, readonly)JFItemModel* model;
@property(nonatomic, assign)BOOL currSelected;
@property(nonatomic, readonly)UIFont* titleFont;
- (instancetype)initWithItemModel:(JFItemModel*)model;
@end
