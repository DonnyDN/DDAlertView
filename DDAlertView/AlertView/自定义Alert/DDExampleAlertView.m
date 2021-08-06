//
//  DDExampleAlertView.m
//  DDAlertView
//
//  Created by duning03 on 2021/8/4.
//

#import "DDExampleAlertView.h"

@interface DDExampleAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DDExampleAlertView

+ (instancetype)alert {
    
    DDExampleAlertView *alert = [[DDExampleAlertView alloc] init];
    
    alert.touchEdgeDismiss = YES;
    alert.contentView.clipsToBounds = YES;
    
    return alert;
}

#pragma mark - DDPopupViewProtocol

/// 弹窗上部分（展示内容）
- (UIView *)popup_prepareCustomView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"内容区域";
    [view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(200);
        make.bottom.mas_equalTo(-20);
    }];
    
    return view;
}

/// 弹窗下部分（交互按钮）
- (UIView *)popup_prepareActionView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor yellowColor];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [confirmBtn setTitle:@"交互区域" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    return view;
}

#pragma mark - Event

- (void)confirmBtnClick:(UIButton *)sender {
    [self dismiss];
}

@end
