//
//  GTSearchBar.m
//  MyNewsApp
//
//  Created by rainHou on 2019/9/20.
//  Copyright © 2019 rainHou. All rights reserved.
//

#import "GTSearchBar.h"
#import "GTScreen.h"

@interface GTSearchBar () <UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UITextField *textField;

@end

@implementation GTSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(UI(10), UI(5), frame.size.width - UI(10) * 2, frame.size.height - UI(5) * 2)];
            _textField.backgroundColor = [UIColor whiteColor];
            _textField.delegate = self;
            _textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
            _textField.leftViewMode = UITextFieldViewModeUnlessEditing;
            _textField.clearButtonMode = UITextFieldViewModeAlways;
            _textField.placeholder = @"今日热点推荐";
//            [_textField becomeFirstResponder];
            _textField;
        })];
    }
    return self;
}

#pragma mark - delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"开始编辑");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"结束编辑");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 常用业务逻辑 - 字数判断 可以在此函数中实现
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"点击Return");
    // 收起键盘
    [_textField resignFirstResponder];
    return YES;
}

@end
