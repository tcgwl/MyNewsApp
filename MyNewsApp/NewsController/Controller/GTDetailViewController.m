//
//  GTDetailViewController.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/6.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTDetailViewController.h"
#import <WebKit/WebKit.h>
#import "GTScreen.h"
#import "GTLogin.h"

@interface GTDetailViewController () <WKNavigationDelegate>

@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong, readwrite) UIProgressView *progressView;
@property (nonatomic, strong) NSString *articleUrl;

@end

@implementation GTDetailViewController

+ (void)load {
//    [GTMediator registerScheme:@"detail://" processBlock:^(NSDictionary * _Nonnull params) {
//        NSString *detailUrl = (NSString *)[params objectForKey:@"detailUrl"];
//        NSString *title = (NSString *)[params objectForKey:@"title"];
//        UINavigationController *navController = (UINavigationController *)[params objectForKey:@"navController"];
//        GTDetailViewController *detailController = [[GTDetailViewController alloc] initWithUrl:detailUrl];
//        detailController.title = title;
//        [navController pushViewController:detailController animated:YES];
//    }];
    
    [GTMediator registerProtocol:@protocol(GTDetailViewControllerProtocol) class:[self class]];
}

- (instancetype)initWithUrl:(NSString *)urlString {
    self = [super init];
    if (self) {
        self.articleUrl = urlString;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"---dealloc---");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(_shareArticle)];
    
    [self.view addSubview:({
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_HEIGHT - 44)];
        self.webView.navigationDelegate = self;
        self.webView;
    })];
    
    [self.view addSubview:({
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + 44, SCREEN_WIDTH, 20)];
        self.progressView;
    })];
    
    [self.webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString:self.articleUrl]]];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"---didFinishNavigation---");
    self.progressView.hidden = YES;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    self.progressView.progress = self.webView.estimatedProgress;
}

#pragma mark - 组件化 protocol class

- (__kindof UIViewController *)detailViewControllerWithUrl:(NSString *)detailUrl {
    return [[[self class] alloc] initWithUrl:detailUrl];
}

#pragma mark - 分享
- (void)_shareArticle {
    [[GTLogin sharedLogin] shareToQQWithArticleUrl:[NSURL URLWithString:self.articleUrl]];
}

@end
