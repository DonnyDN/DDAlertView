//
//  DDAlertBottomActionView.m
//  aiinquiry
//
//  Created by duning03 on 2021/6/18.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "DDAlertBottomActionView.h"

@interface DDAlertBottomActionView ()
@property (nonatomic, strong) UIView *sepLineView;
@property (nonatomic,   copy) NSArray <UIButton *> *buttons;
@end

@implementation DDAlertBottomActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.buttons = [NSArray array];
        
        self.showHorSeprateLine = YES;
    }
    return self;
}

#pragma mark - Override

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (_showHorSeprateLine) {
        [self bringSubviewToFront:_sepLineView];
    }
}

#pragma mark - Public

- (UIButton *)installButton {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:btn];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.buttons];
    [arr addObject:btn];
    self.buttons = arr.copy;
    return btn;
}

- (void)unInstallButton:(UIButton *)button {
    [button removeFromSuperview];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.buttons];
    [arr removeObject:button];
    self.buttons = arr.copy;
}

#pragma mark - Getter & Setter

- (void)setShowHorSeprateLine:(BOOL)showHorSeprateLine {
    _showHorSeprateLine = showHorSeprateLine;
    if (showHorSeprateLine && !_sepLineView) {
        _sepLineView = [[UIView alloc] init];
        _sepLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
        [self addSubview:_sepLineView];
        [_sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(1 / [UIScreen mainScreen].scale);
        }];
    }
    
    [_sepLineView setHidden:!showHorSeprateLine];
}

@end
