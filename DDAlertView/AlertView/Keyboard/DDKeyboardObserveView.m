//
//  DDKeyboardObserveView.m
//  aiinquiry
//
//  Created by duning03 on 2021/6/24.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "DDKeyboardObserveView.h"

@interface DDKeyboardObserveView ()
// 键盘已出现过一次（启动App后，第三方键盘首次弹出，会多次触发willShow通知，且首次触发获取的键盘高度不准确）
@property (nonatomic, assign) BOOL keyboardDidShowOnce;
@property (nonatomic, assign) BOOL iskeyboardShowing;
@property (nonatomic, assign) CGRect keyboardFrame;

@property (nonatomic,   weak) UIView *tempContentView;
@end

@implementation DDKeyboardObserveView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.autoMovedView = [UIApplication sharedApplication].keyWindow;
        self.keyboardMargin = 20;
    }
    return self;
}

#pragma mark - Observer

- (void)keyboard_observe:(BOOL)observed {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    if (observed) {
        [self keyboard_observe:NO];
        [defaultCenter addObserver:self selector:@selector(keyboardWillShow:)
                              name:UIKeyboardWillShowNotification object:nil];
        [defaultCenter addObserver:self selector:@selector(keyboardWillHide:)
                              name:UIKeyboardWillHideNotification object:nil];
    } else {
        [defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    _iskeyboardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.keyboardFrame = keyboardFrame;
    
    if (!self.keyboardDidShowOnce) {
        // 解决多次触发willShow通知，且首次触发获取的键盘高度不准确问题
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(keyboard_checkNeedScroll) object:nil];
        [self performSelector:@selector(keyboard_checkNeedScroll) withObject:nil afterDelay:0.03f];
    } else {
        [self keyboard_checkNeedScroll];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _iskeyboardShowing = NO;
    
    if (![self autoMovedEnable]) {
        return;
    }
    
    [self resetToOriginBounds];
}

- (void)keyboard_checkNeedScroll {
    if (![self autoMovedEnable]) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([self.tempContentView isKindOfClass:[UIWindow class]]) {
        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.bounds = window.frame;
    }
    
    CGRect newframe = [self.editingView.superview convertRect:self.editingView.frame toView:window];
    CGFloat margin = (CGRectGetMaxY(newframe) - CGRectGetMinY(self.keyboardFrame) + self.keyboardMargin);
    if (margin > 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect bounds = self.tempContentView.bounds;
            bounds.origin.y += margin;
            self.tempContentView.bounds = bounds;
        } completion:nil];
    }
    
    self.keyboardDidShowOnce = YES;
}

- (void)resetToOriginBounds {
    CGRect bounds = self.tempContentView.bounds;
    if (bounds.origin.y != 0) {
        bounds.origin.y = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.tempContentView.bounds = bounds;
        }];
    }
}

#pragma mark - Getter & Setter

- (void)setKeyboardObserve:(BOOL)keyboardObserve {
    _keyboardObserve = keyboardObserve;
    [self keyboard_observe:keyboardObserve];
}

- (void)setAutoMovedView:(UIView *)autoMovedView {
    _autoMovedView = autoMovedView;

    if ([autoMovedView isKindOfClass:[UIScrollView class]]) {
        
        NSAssert(autoMovedView.superview, @"autoMovedView.superview can't be nil");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (CGRectIsEmpty(autoMovedView.frame)) {
                self.tempContentView = autoMovedView;
            } else {
                [self insertSuperViewBelowScrollView:(UIScrollView *)autoMovedView];
            }
        });
    } else {
        self.tempContentView = (UIView *)autoMovedView;
    }
}

- (UIView *)editingView {
    UIView *firstResponder = [self findFirstResponder:self];
    if ([firstResponder conformsToProtocol:@protocol(UITextInput)]) {
        return firstResponder;
    }
    return nil;
}

#pragma mark - Private

- (BOOL)autoMovedEnable {
    return self.editingView && !CGRectIsNull(self.keyboardFrame) && self.autoMovedView;
}

// 这里尽量不去修改scrollView的bounds，会影响其contentOffset，所以给scrollView添加一个superView
- (void)insertSuperViewBelowScrollView:(UIScrollView *)scrollView {
    UIView *tempContentView = [[UIView alloc] initWithFrame:scrollView.frame];
    tempContentView.backgroundColor = [UIColor clearColor];
    [scrollView.superview insertSubview:tempContentView atIndex:0];
    self.tempContentView = tempContentView;
    
    scrollView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [self.tempContentView addSubview:scrollView];
}

// 递归查找正在输入的view
- (UIView *)findFirstResponder:(UIView *)superView {
    if (superView.isFirstResponder) {
        return superView;
    }
    for (UIView *subView in superView.subviews) {
        UIView *firstResponder = [self findFirstResponder:subView];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

- (void)hideKeyboard {
    [self endEditing:YES];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_iskeyboardShowing) {
        [self keyboard_checkNeedScroll];
    }
}

- (void)dealloc {
    [self keyboard_observe:NO];
}

@end
