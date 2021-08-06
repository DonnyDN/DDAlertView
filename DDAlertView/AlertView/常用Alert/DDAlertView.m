//
//  DDAlertView.m
//  aiinquiry
//
//  Created by duning03 on 2021/6/18.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "DDAlertView.h"
#import "DDAlertBottomActionView.h"

static DDAlertDefaultModel *alertDefaultModel;

@interface DDAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) DDAlertBottomActionView *actionView;
@property (nonatomic,   copy) dispatch_block_t cancelAction;
@property (nonatomic,   copy) dispatch_block_t confirmAction;
@end

@implementation DDAlertView

+ (void)initialize {
    alertDefaultModel = [DDAlertDefaultModel new];
    alertDefaultModel.titleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    alertDefaultModel.titleColor = [UIColor blackColor];
    alertDefaultModel.messageFont = [UIFont systemFontOfSize:14];
    alertDefaultModel.messageColor = [UIColor grayColor];
    alertDefaultModel.messageLineSpace = 5;
    alertDefaultModel.messageAlignment = NSTextAlignmentCenter;
}

+ (void)configDefaultAlertStyle:(void(^)(DDAlertDefaultModel *_Nonnull model))style {
    if (style) {
        style(alertDefaultModel);
    }
}

#pragma mark - 初始化

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                       message:(NSString *_Nullable)message
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction {
    
    return [self alertWithTitle:title message:message cancelTitle:nil cancelAction:nil confirmTitle:confirmTitle confirmAction:confirmAction];
}

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                       message:(NSString *_Nullable)message
                   cancelTitle:(NSString *_Nullable)cancelTitle
                  cancelAction:(dispatch_block_t _Nullable)cancelAction
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction {
    
    NSString *newTitle = title ?: @"";
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:newTitle attributes:@{
        NSFontAttributeName : alertDefaultModel.titleFont,
        NSForegroundColorAttributeName : alertDefaultModel.titleColor
    }];
    
    NSString *newMessage = message ?: @"";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = alertDefaultModel.messageLineSpace;
    paraStyle.alignment = alertDefaultModel.messageAlignment;
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:newMessage attributes:@{
        NSFontAttributeName : alertDefaultModel.messageFont,
        NSParagraphStyleAttributeName : paraStyle,
        NSForegroundColorAttributeName : alertDefaultModel.messageColor
    }];
    
    return [self alertWithAttrTitle:attrTitle attrMessage:attrMsg cancelTitle:cancelTitle cancelAction:cancelAction confirmTitle:confirmTitle confirmAction:confirmAction];
}

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                   attrMessage:(NSAttributedString *_Nullable)attrMessage
                   cancelTitle:(NSString *_Nullable)cancelTitle
                  cancelAction:(dispatch_block_t _Nullable)cancelAction
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction {
    
    NSString *newTitle = title ?: @"";
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:newTitle attributes:@{
        NSFontAttributeName : alertDefaultModel.titleFont,
        NSForegroundColorAttributeName : alertDefaultModel.titleColor
    }];
    
    return [self alertWithAttrTitle:attrTitle attrMessage:attrMessage cancelTitle:cancelTitle cancelAction:cancelAction confirmTitle:confirmTitle confirmAction:confirmAction];
}

+ (instancetype)alertWithAttrTitle:(NSAttributedString *_Nullable)attrTitle
                       attrMessage:(NSAttributedString *_Nullable)attrMessage
                       cancelTitle:(NSString *_Nullable)cancelTitle
                      cancelAction:(dispatch_block_t _Nullable)cancelAction
                      confirmTitle:(NSString *_Nullable)confirmTitle
                     confirmAction:(dispatch_block_t _Nullable)confirmAction {
    
    DDAlertView *alert = [[DDAlertView alloc] init];
    alert.titleLabel.attributedText = attrTitle;
    if (attrMessage.length) {
        alert.messageLabel.attributedText = attrMessage;
    } else {
        [alert.messageLabel removeFromSuperview];
    }
    
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
    alert.touchEdgeDismiss = YES;
    alert.actionAutoDismiss = YES;
    
    return alert;
}

#pragma mark - DDPopupViewProtocol

- (UIView *)popup_prepareCustomView {
    UIView *view = [[UIView alloc] init];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = alertDefaultModel.titleColor;
    _titleLabel.font = alertDefaultModel.titleFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = alertDefaultModel.messageColor;
    _messageLabel.font = alertDefaultModel.messageFont;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.numberOfLines = 0;
    [view addSubview:_messageLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(18);
        make.bottom.mas_equalTo(_messageLabel.mas_top).offset(-12).priorityHigh();
        make.bottom.mas_equalTo(-25).priorityLow();
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
    }];
    return view;
}

- (UIView *)popup_prepareActionView {
    _actionView = [[DDAlertBottomActionView alloc] init];
    
    // 取消按钮
    UIButton *cancelBtn = [_actionView installButton];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 确定按钮
    UIButton *confirmBtn = [_actionView installButton];
    [confirmBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutActionButtons];

    // 竖向分割线
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
    UIView *verSepLine = [[UIView alloc] init];
    verSepLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    [cancelBtn addSubview:verSepLine];
    [verSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-lineHeight);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(lineHeight);
    }];
    
    return _actionView;
}

- (void)popup_dismissCompletion {
    [super popup_dismissCompletion];
    self.cancelAction = nil;
    self.confirmAction = nil;
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

#pragma mark - Getter & Setter

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    self.messageLabel.textAlignment = messageAlignment;
}

- (void)setActionAutoDismiss:(BOOL)actionAutoDismiss {
    _actionAutoDismiss = actionAutoDismiss;
}

@end


@implementation DDAlertDefaultModel
@end
