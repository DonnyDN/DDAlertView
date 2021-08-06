//
//  DDPopupView.m
//  aiinquiry
//
//  Created by duning03 on 2021/6/18.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "DDPopupView.h"

@interface DDPopupView ()
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) BOOL showing;
@end

@implementation DDPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        self.delegate = self;
        
        self.multiShowEnable = YES;
        self.touchEdgeDismiss = NO;
        self.releaseAfterDismiss = YES;
        self.contentViewWidth = frame.size.width - 54 * 2;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentViewWidth);
        make.center.mas_equalTo(0);
    }];
    
    [self setupContentSubviews];
}

- (void)setupContentSubviews {
    UIView *customView = [self.delegate popup_prepareCustomView];
    [self.contentView addSubview:customView];
    
    UIView *actionView = [self.delegate popup_prepareActionView];
    [self.contentView addSubview:actionView];
    
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        if (!actionView) {
            make.bottom.mas_equalTo(0);
        }
    }];
    [actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (customView) {
            make.top.mas_equalTo(customView.mas_bottom);
        } else {
            make.top.mas_equalTo(0);
        }
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark - DDPopupViewProtocol

- (UIView *)popup_prepareCustomView {
    return nil;
}

- (UIView *)popup_prepareActionView {
    return nil;
}

- (void)popup_dismissCompletion {
    if (self.dismissCompletion) {
        self.dismissCompletion();
    }
}

#pragma mark - Getter & Setter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

- (void)setContentViewWidth:(CGFloat)contentViewWidth {
    _contentViewWidth = contentViewWidth;
    if (_contentView) {
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(contentViewWidth);
            make.center.mas_equalTo(0);
        }];
    }
}

#pragma mark - 展示 | 消失

- (void)show {
    [self showInView:nil];
}

- (void)showInView:(UIView *)view {
    UIView *superView = view;
    if (!superView) {
        superView = [UIApplication sharedApplication].delegate.window;
    }
    if (!self.multiShowEnable) {
        UIView *lastSubV = [superView.subviews lastObject];
        if ([lastSubV isKindOfClass:[DDPopupView class]] &&
            [(DDPopupView *)lastSubV showing]) {
            return; // 已有弹窗不再弹出
        }
    }
    [superView endEditing:YES];
    [superView addSubview:self];
    self.alpha = 1;
    self.hidden = NO;
    
    [self addAnimationWithLayer:_contentView.layer];
}

- (void)addAnimationWithLayer:(CALayer *)layer {
    CABasicAnimation *opacity = [CABasicAnimation new];
    opacity.keyPath = @"opacity";
    opacity.fromValue = @(0.f);
    opacity.toValue = @(1.f);
    opacity.duration = 0.2f;
    
    CABasicAnimation *scale = [CABasicAnimation new];
    scale.keyPath = @"transform.scale";
    scale.fromValue = @(0.8f);
    scale.toValue = @(1.f);
    scale.duration = 0.2f;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[opacity,scale];
    group.duration = 0.2;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    [layer removeAnimationForKey:@"AlertAnimationKey"];
    [layer addAnimation:group forKey:@"AlertAnimationKey"];
}

- (void)dismiss {
    self.showing = NO;
    [self endEditing:YES];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.dismissCompletion) {
            self.dismissCompletion();
        }
        self.hidden = YES;
        if (self.releaseAfterDismiss) {
            [self removeFromSuperview];
        }
        // destroy block to avoid memory leak
        [self popup_dismissCompletion];
    }];
}

#pragma mark - Override

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [touches.anyObject locationInView:self];
    if (point.x == 0 || point.y == 0 || point.x == [UIScreen mainScreen].bounds.size.width ||
        point.y == [UIScreen mainScreen].bounds.size.height) {
        return;
    }
    if (!CGRectContainsPoint(_contentView.frame, point)) {
        if (self.touchEdgeDismiss) {
            [self dismiss];
        }
    }
}

- (void)dealloc {
    NSLog(@" --- %@ dealloc ---", NSStringFromClass([self class]));
}

@end
