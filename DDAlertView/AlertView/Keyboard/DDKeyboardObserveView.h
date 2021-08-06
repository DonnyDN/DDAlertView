//
//  DDKeyboardObserveView.h
//  aiinquiry
//
//  Created by duning03 on 2021/6/24.
//  Copyright © 2021 Baidu. All rights reserved.
//
// 继承此View，设置 keyboardObserve = YES, 可自动监听键盘，输入框防遮挡

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDKeyboardObserveView : UIView

/**
 是否开启监听（默认NO）
 */
@property (nonatomic, assign) BOOL keyboardObserve;
/**
 需要移动的view（默认keyWindow）
 */
@property (nonatomic,   weak) UIView *autoMovedView;
/**
 输入框底部与键盘的距离（默认20）
 */
@property (nonatomic, assign) CGFloat keyboardMargin;
/**
 键盘Frame
 */
@property (nonatomic, assign, readonly) CGRect keyboardFrame;

/**
 键盘出现/消失（子类重写，可实现其他逻辑）
 */
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

/**
 隐藏键盘
 */
- (void)hideKeyboard;


@end

NS_ASSUME_NONNULL_END
