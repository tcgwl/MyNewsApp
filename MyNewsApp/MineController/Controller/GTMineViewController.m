//
//  GTMineViewController.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/5.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTMineViewController.h"
#import "GTLogin.h"
#import <SDWebImage.h>

@interface GTMineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIView *tableViewHeaderView;
@property (nonatomic, strong, readwrite) UIImageView *headerImageView;

@end

@implementation GTMineViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"我的";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/home@2x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/home_selected@2x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:({
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView;
    })];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mineTableViewCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        
        [_tableViewHeaderView addSubview:({
            _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 140)];
            _headerImageView.backgroundColor = [UIColor whiteColor];
            _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
            _headerImageView.clipsToBounds = YES;
            _headerImageView.userInteractionEnabled = YES;
            _headerImageView;
        })];
        
        [_tableViewHeaderView addGestureRecognizer:({
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapImage)];
            tapGesture;
        })];
    }
    return _tableViewHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([[GTLogin sharedLogin] isLogin]) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[GTLogin sharedLogin].avatarUrl]];
    } else {
        [_headerImageView setImage:[UIImage imageNamed:@"icon.bundle/icon.png"]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.textLabel.text = [[GTLogin sharedLogin] isLogin] ? [GTLogin sharedLogin].nickName : @"昵称";
    } else {
        cell.textLabel.text = [[GTLogin sharedLogin] isLogin] ? [GTLogin sharedLogin].address : @"地区";
    }
}

#pragma mark - private

- (void)_tapImage {
    __weak typeof(self)weakSelf = self;
    if ([[GTLogin sharedLogin] isLogin]) {
        [[GTLogin sharedLogin] logout];
        [self.tableView reloadData];
    } else {
        // 开始登录
        [[GTLogin sharedLogin] loginWithFinishBlock:^(BOOL isLogin) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (isLogin) {
                [strongSelf.tableView reloadData];
            }
        }];
    }
}

@end
