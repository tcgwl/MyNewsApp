//
//  GTNewsViewController.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/5.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTNewsViewController.h"
#import "GTNormalTableViewCell.h"
#import "GTDeleteCellView.h"
#import "GTListLoader.h"
#import "GTListItem.h"
#import "GTMediator.h"

@interface GTNewsViewController () <UITableViewDataSource, UITableViewDelegate, GTNormalTableViewCellDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) NSArray<GTListItem *> *dataArray;

@end

@implementation GTNewsViewController

- (instancetype) init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"新闻";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/page@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/page_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    GTListLoader *listLoader = [[GTListLoader alloc] init];
    [listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<GTListItem *> * _Nonnull dataArray) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.dataArray = dataArray;
        [strongSelf.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[GTNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    [cell layoutTableViewCellWithItem:[self.dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTListItem *listItem = [self.dataArray objectAtIndex:indexPath.row];
    
    // 组件化三种方案
    // 1. target action
//    __kindof UIViewController *detailController = [GTMediator detailViewControllerWithUrl:listItem.articleUrl];
//    detailController.title = listItem.title;
//    [self.navigationController pushViewController:detailController animated:YES];
    
    // 2. url scheme
//    [GTMediator openUrl:@"detail://" params:@{@"detailUrl":listItem.articleUrl, @"title":listItem.title, @"navController":self.navigationController}];
    
    // 3. protocol class
    Class cls = [GTMediator classForProtocol:@protocol(GTDetailViewControllerProtocol)];
    UIViewController *detailController = [[cls alloc] detailViewControllerWithUrl:listItem.articleUrl];
    detailController.title = listItem.title;
    [self.navigationController pushViewController:detailController animated:YES];
    
    // 标记已读
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:listItem.uniqueKey];
}

- (void)tableViewCell:(UITableViewCell *)tableViewCell clickDeleteButton:(UIButton *)deleteButton {
    GTDeleteCellView *deleteView = [[GTDeleteCellView alloc] initWithFrame:self.view.bounds];
    // deleteButton坐标系转换: cell转window
    CGRect rect = [tableViewCell convertRect:deleteButton.frame toView:nil];

    __weak typeof(self) weakSelf = self;
    [deleteView showDeleteViewFromPoint:rect.origin clickBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSIndexPath *deleteIndexPath = [strongSelf.tableView indexPathForCell:tableViewCell];
        if (strongSelf.dataArray.count > deleteIndexPath.row) {
            // 删除数据
            NSMutableArray *tmpDataArray = [strongSelf.dataArray mutableCopy];
            [tmpDataArray removeObjectAtIndex:deleteIndexPath.row];
            strongSelf.dataArray = [tmpDataArray copy];
            // 删除cell
            [strongSelf.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

@end
