//
//  HomeViewController.m
//  JFStickyMenuDemo
//
//  Created by 宋炬峰 on 2016/11/21.
//  Copyright © 2016年 songjufeng. All rights reserved.
//

#import "HomeViewController.h"
#import "JFStickyMenu.h"
#import "MainListController.h"
@interface HomeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet JFStickyMenu *homeMenu;
@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) NSMutableArray* listControllerArr;
@property (assign, nonatomic) BOOL appearedOnce;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 104)];
    [self.view addSubview:self.mainScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (NO == self.appearedOnce) {
        
        NSInteger n = self.homeMenu.itemCount;
        self.mainScroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * n, [UIScreen mainScreen].bounds.size.height - 64 - 40);
        self.mainScroll.backgroundColor = [UIColor lightGrayColor];
        self.mainScroll.pagingEnabled = YES;
        self.mainScroll.showsHorizontalScrollIndicator = YES;
        self.mainScroll.showsVerticalScrollIndicator = YES;
        self.mainScroll.delegate = self;
        __weak typeof(self) wself = self;
        self.homeMenu.tapItemHandler = ^(NSInteger index){
            [wself.mainScroll setContentOffset:CGPointMake(index * [UIScreen mainScreen].bounds.size.width, 0)  animated:NO];
            
        };
        self.appearedOnce = YES;
        
        [self addListToPosIndex:0];
    }
}

-(MainListController*)ListForIndex:(NSInteger)k{
    if (k < self.listControllerArr.count) {
        return self.listControllerArr[k];
    }
    return nil;
}

-(void)moveFocusToListViewByIndex:(NSInteger)index{
    
    // 生成列表视图
    [self addListToPosIndex:index];
}

//添加列表
-(void)addListToPosIndex:(NSInteger)index{
    id list = [self ListForIndex:index];
    if ([list isKindOfClass:[MainListController class]]) {
        return;
    }
    
    // 创建TableView
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = self.mainScroll.bounds.size.height;
    CGRect rc = CGRectMake(index * w, 0, w, h);
    
    MainListController* listController = [[MainListController alloc] initWithFrame:rc];
    JFItemModel* category = [self.homeMenu categoryModelInPosition:index];
    listController.categoryId = category.itemID;
    
    [self.mainScroll addSubview:listController.view];
    [self setListController:listController ForIndex:index];
    [self addChildViewController:listController];
}

-(void)setListController:(UIViewController*)controller ForIndex:(NSInteger)k{
    self.listControllerArr[k] = controller;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.mainScroll) {
        CGFloat x = scrollView.contentOffset.x;
        CGFloat f = x / scrollView.bounds.size.width;
        [self.homeMenu setCurrFloatPos:f];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.mainScroll) {
        CGFloat x = self.mainScroll.contentOffset.x;
        NSInteger n = x / self.mainScroll.bounds.size.width;
        // 改变上面的一级菜单
        [self.homeMenu setCurrSelected:n];
        // 创建TableView
        [self moveFocusToListViewByIndex:n];
    }
}

@end
