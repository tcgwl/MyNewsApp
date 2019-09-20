//
//  GTRecommendViewController.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/5.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTRecommendViewController.h"
#import "GTRecommendSectionController.h"
#import "GTListLoader.h"

@interface GTRecommendViewController () <UIScrollViewDelegate,UIGestureRecognizerDelegate,IGListAdapterDataSource>

@property(nonatomic, strong, readwrite) UICollectionView *collectionView;
@property(nonatomic, strong, readwrite) IGListAdapter *listAdapter;
@property(nonatomic, strong, readwrite) GTListLoader *listLoader;
@property(nonatomic, strong, readwrite) NSArray *dataArray;

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.listLoader = [[GTListLoader alloc] init];
    [self.view addSubview:({
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView;
    })];
    
    _listAdapter = [[IGListAdapter alloc] initWithUpdater:[IGListAdapterUpdater new] viewController:self workingRangeSize:0];
    _listAdapter.dataSource = self;
    _listAdapter.scrollViewDelegate = self;
    _listAdapter.collectionView = _collectionView;
    
    __weak typeof(self)weakSelf = self;
    [self.listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<GTListItem *> * _Nonnull dataArray) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataArray = dataArray;
        [strongSelf.listAdapter reloadDataWithCompletion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataArray;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [GTRecommendSectionController new];
}

- (nullable UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - UISCROLLVIEW TEST

- (void)_testScrollView {
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

#pragma mark - UISCROLLVIEW DELEGATE

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
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

#pragma mark - SCHEME TEST

- (void)viewClick {
    NSLog(@"---viewClick---");
    NSURL *urlScheme = [NSURL URLWithString:@"docinbookipad://"];
    __unused BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:urlScheme];
    [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:^(BOOL success) {
        NSLog(@"SCHEME TEST");
    }];
}

@end
