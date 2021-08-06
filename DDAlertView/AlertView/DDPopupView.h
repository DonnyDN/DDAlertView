//
//  DDPopupView.h
//  aiinquiry
//
//  Created by duning03 on 2021/6/18.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDKeyboardObserveView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDPopupViewProtocol <NSObject>
@required
- (UIView *)popup_prepareCustomView;   /// 弹窗上部分（展示内容）
- (UIView *)popup_prepareActionView;   /// 弹窗下部分（交互按钮）
@optional
- (void)popup_dismissCompletion;       /// dismiss后调用
@end


@interface DDPopupView : DDKeyboardObserveView <DDPopupViewProtocol>

@property (nonatomic, weak) id <DDPopupViewProtocol> delegate;

/// 中间弹窗容器 view
@property (nonatomic, strong, readonly) UIView *contentView;

/// 中间弹窗容器 width（默认 SCREENWIDTH - 54 * 2）
@property (nonatomic, assign) CGFloat contentViewWidth;

/// 点击灰色背景消失（默认 NO）
@property (nonatomic, assign) BOOL touchEdgeDismiss;

/// 消失后销毁（默认 YES）
@property (nonatomic, assign) BOOL releaseAfterDismiss;

/// 允许同时显示多个（默认 YES）
@property (nonatomic, assign) BOOL multiShowEnable;

/// dismiss完成
@property (nonatomic,   copy) dispatch_block_t dismissCompletion;


- (void)show;
- (void)showInView:(UIView *_Nullable)view;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
