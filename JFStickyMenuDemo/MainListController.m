//
//  MainListController.m
//  JFStickyMenuDemo
//
//  Created by 宋炬峰 on 2017/1/13.
//  Copyright © 2017年 songjufeng. All rights reserved.
//

#import "MainListController.h"

@interface MainListController ()
@property(nonatomic, strong)UIImageView* bg;
@end

@implementation MainListController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bg = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage* bgImg = [UIImage imageNamed:@"blanklist375"];
    NSInteger w = [UIScreen mainScreen].bounds.size.width;
    switch (w) {
        case 320:
            bgImg = [UIImage imageNamed:@"blanklist320"];
            break;
        case 375:
            bgImg = [UIImage imageNamed:@"blanklist375"];
            break;
        case 414:
            bgImg = [UIImage imageNamed:@"blanklist414"];
            break;
        default:
            break;
    }
    self.bg.backgroundColor = [[UIColor alloc] initWithPatternImage:bgImg];
    [self.view addSubview:self.bg];
}
@end
