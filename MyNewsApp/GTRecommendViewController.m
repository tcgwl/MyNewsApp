//
//  GTRecommendViewController.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/5.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTRecommendViewController.h"

@interface GTRecommendViewController () <UIScrollViewDelegate>

@end

@implementation GTRecommendViewController

- (instancetype) init{
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"推荐";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/like@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/like_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 5, self.view.bounds.size.height);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    NSArray *colorArray = @[[UIColor lightGrayColor], [UIColor yellowColor], [UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
    for (int i = 0; i < 5; i++) {
        [scrollView addSubview:({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width * i, 0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
            [view addSubview:({
                UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
                tapView.backgroundColor = [UIColor brownColor];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
                [tapView addGestureRecognizer:tapGesture];
                tapView;
            })];
            view.backgroundColor = [colorArray objectAtIndex:i];
            view;
        })];
    }
    [self.view addSubview:scrollView];
}

- (void)viewClick {
    NSLog(@"---viewClick---");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"---scrollViewDidScroll---");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"---scrollViewWillBeginDragging---");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"---scrollViewDidEndDragging---");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"---scrollViewWillBeginDecelerating---");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"---scrollViewDidEndDecelerating---");
}

@end
