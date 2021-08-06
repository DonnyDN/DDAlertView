//
//  DDTextViewAlertView.m
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import "DDTextViewAlertView.h"
#import "DDAlertBottomActionView.h"
#import "DDTextView.h"

@interface DDTextViewAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DDTextView *textView;
@property (nonatomic, strong) DDAlertBottomActionView *actionView;
@property (nonatomic,   copy) dispatch_block_t cancelAction;
@property (nonatomic,   copy) dispatch_block_t confirmAction;
@end

@implementation DDTextViewAlertView

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                       content:(NSString *_Nullable)content
                   cancelTitle:(NSString *_Nullable)cancelTitle
                  cancelAction:(dispatch_block_t _Nullable)cancelAction
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction {
    
    NSString *newTitle = title ?: @"";
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:newTitle attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName : [UIColor blackColor]
    }];
    
    return [self alertWithAttrTitle:attrTitle content:content cancelTitle:cancelTitle cancelAction:cancelAction confirmTitle:confirmTitle confirmAction:confirmAction];
}

+ (instancetype)alertWithAttrTitle:(NSAttributedString *_Nullable)attrTitle
                           content:(NSString *_Nullable)content
                       cancelTitle:(NSString *_Nullable)cancelTitle
                      cancelAction:(dispatch_block_t _Nullable)cancelAction
                      confirmTitle:(NSString *_Nullable)confirmTitle
                     confirmAction:(dispatch_block_t _Nullable)confirmAction {
    
    DDTextViewAlertView *alert = [[DDTextViewAlertView alloc] init];
    alert.titleLabel.attributedText = attrTitle;
    alert.textView.text = content;
    
    // buttons
    NSArray *buttons = alert.actionView.buttons;
    UIButton *cancelBtn = buttons.firstObject;
    UIButton *confirmBtn = buttons.lastObject;
    if (cancelTitle.length > 0) {
        [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    } else {
        [alert.actionView unInstallButton:cancelBtn];
    }
    if (confirmTitle.length > 0) {
        [confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
    } else {
        [alert.actionView unInstallButton:confirmBtn];
    }
    [alert layoutActionButtons];
    
    alert.cancelAction = cancelAction;
    alert.confirmAction = confirmAction;
    
    // 其他特性
    alert.touchEdgeDismiss = NO;
    alert.actionAutoDismiss = YES;
    alert.keyboardObserve = YES;
    alert.autoMovedView = alert;
    alert.keyboardMargin = 80;
    
    return alert;
}

#pragma mark - DDPopupViewProtocol

/// 弹窗上部分（展示内容）
- (UIView *)popup_prepareCustomView {
    UIView *view = [[UIView alloc] init];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_titleLabel];
    
    // 这里自定义输入框样式
    _textView = [[DDTextView alloc] init];
    _textView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    _textView.textColor = [UIColor darkTextColor];
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.layer.cornerRadius = 5;
    _textView.clipsToBounds = YES;
    _textView.placeholder = @"请输入内容";
    _textView.placeholderColor = [UIColor lightGrayColor];
    _textView.placeholderFont = [UIFont systemFontOfSize:14];
    _textView.isAutoHeight = YES;
    _textView.maxAutoHeight = 100;
    [view addSubview:_textView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(18);
        make.bottom.mas_equalTo(_textView.mas_top).offset(-12);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-20);
    }];

    return view;
}

/// 弹窗下部分（交互按钮）
- (UIView *)popup_prepareActionView {
    _actionView = [[DDAlertBottomActionView alloc] init];
    
    // 取消按钮
    UIButton *cancelBtn = [_actionView installButton];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 确定按钮
    UIButton *confirmBtn = [_actionView installButton];
    [confirmBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutActionButtons];

    // 竖向分割线
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
    UIView *verSepLine = [[UIView alloc] init];
    verSepLine.backgroundColor = [UIColor lightGrayColor];
    [cancelBtn addSubview:verSepLine];
    [verSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-lineHeight);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(lineHeight);
    }];
    
    return _actionView;
}

- (void)layoutActionButtons {
    NSArray *buttons = self.actionView.buttons;
    CGFloat buttonWidth = self.contentViewWidth / buttons.count;
    if (buttons.count > 1) {
        [self.actionView.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:buttonWidth leadSpacing:0 tailSpacing:0];
        [_actionView.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(0);
        }];
    } else {
        UIButton *btn = buttons.firstObject;
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.actionView).insets(UIEdgeInsetsZero);
            make.height.mas_equalTo(50);
        }];
    }
}

#pragma mark - Event

- (void)cancelBtnClick:(UIButton *)sender {
    if (self.cancelAction) {
        self.cancelAction();
    }
    if (_actionAutoDismiss) {
        [self dismiss];
    }
}

- (void)confirmBtnClick:(UIButton *)sender {
    if (self.confirmAction) {
        self.confirmAction();
    }
    if (_actionAutoDismiss) {
        [self dismiss];
    }
}
@end
