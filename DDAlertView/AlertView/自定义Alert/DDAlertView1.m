//
//  DDAlertView1.m
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import "DDAlertView1.h"
#import "DDAlertBottomActionView.h"

@interface DDAlertView1 ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) DDAlertBottomActionView *actionView;
@property (nonatomic,   copy) dispatch_block_t cancelAction;
@property (nonatomic,   copy) dispatch_block_t confirmAction;
@end

@implementation DDAlertView1

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
        NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName : [UIColor blackColor]
    }];
    
    NSString *newMessage = message ?: @"";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5;
    paraStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attrMsg = [[NSMutableAttributedString alloc] initWithString:newMessage attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:14],
        NSParagraphStyleAttributeName : paraStyle,
        NSForegroundColorAttributeName : [UIColor grayColor]
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
        NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName : [UIColor blackColor]
    }];
    
    return [self alertWithAttrTitle:attrTitle attrMessage:attrMessage cancelTitle:cancelTitle cancelAction:cancelAction confirmTitle:confirmTitle confirmAction:confirmAction];
}

+ (instancetype)alertWithAttrTitle:(NSAttributedString *_Nullable)attrTitle
                       attrMessage:(NSAttributedString *_Nullable)attrMessage
                       cancelTitle:(NSString *_Nullable)cancelTitle
                      cancelAction:(dispatch_block_t _Nullable)cancelAction
                      confirmTitle:(NSString *_Nullable)confirmTitle
                     confirmAction:(dispatch_block_t _Nullable)confirmAction {
    
    DDAlertView1 *alert = [[DDAlertView1 alloc] init];
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
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor grayColor];
    _messageLabel.font = [UIFont systemFontOfSize:14];;
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
    _actionView.showHorSeprateLine = NO;
    
    // 取消按钮
    UIButton *cancelBtn = [_actionView installButton];
    cancelBtn.backgroundColor = [UIColor orangeColor];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    cancelBtn.layer.cornerRadius = 17;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 确定按钮
    UIButton *confirmBtn = [_actionView installButton];
    confirmBtn.backgroundColor = [UIColor blueColor];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    confirmBtn.layer.cornerRadius = 17;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutActionButtons];

    return _actionView;
}

- (void)popup_dismissCompletion {
    [super popup_dismissCompletion];
    self.cancelAction = nil;
    self.confirmAction = nil;
}

- (void)layoutActionButtons {
    NSArray *buttons = self.actionView.buttons;
    if (buttons.count > 1) {
        [self.actionView.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
        [_actionView.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(35);
            make.bottom.mas_equalTo(-15);
        }];
    } else {
        UIButton *btn = buttons.firstObject;
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.actionView).insets(UIEdgeInsetsMake(5, 40, 15, 40));
            make.height.mas_equalTo(35);
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
