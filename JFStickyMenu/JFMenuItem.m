//
//  JFMenuItem.m
//  JFStickyMenuDemo
//
//  Created by 宋炬峰 on 2016/11/21.
//  Copyright © 2016年 songjufeng. All rights reserved.
//

#import "JFMenuItem.h"

const CGFloat defualtW = 50;

@implementation JFItemModel
-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self){
        self.itemName = dic[@"name"];
        NSNumber* num = dic[@"id"];
        if ([num isKindOfClass:[NSNumber class]]) {
            self.itemID = [num integerValue];
        }
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    JFItemModel* obj = [super init];
    obj.index = self.index;
    obj.itemName = [self.itemName copy];
    obj.itemID = self.itemID;
    return obj;
}
@end




#pragma mark - 




@interface JFMenuItem()
@property(nonatomic, strong)UILabel* titleLabel;
@end

@implementation JFMenuItem

- (instancetype)initWithItemModel:(JFItemModel*)model
{
    self = [super initWithFrame:CGRectMake(0, 0, defualtW, JFMenuH-0.5)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _model = [model copy];
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = [UIColor colorWithWhite:0x78/255.0 alpha:1.0];
        self.titleLabel.text = model.itemName;
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(UIFont*)titleFont{
    return self.titleLabel.font;
}


-(void)setCurrSelected:(BOOL)currSelected{
    _currSelected = currSelected;
    
    if (currSelected) {
        self.titleLabel.textColor = [UIColor redColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }else{
        self.titleLabel.textColor = [UIColor colorWithWhite:0x78/255.0 alpha:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
}

-(void)layoutSubviews{
    self.titleLabel.frame = self.bounds;
}

@end
