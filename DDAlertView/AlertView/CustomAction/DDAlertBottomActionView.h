//
//  DDAlertBottomActionView.h
//  aiinquiry
//
//  Created by duning03 on 2021/6/18.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDAlertBottomActionView : UIView

/// 是否展示横向分割线
@property (nonatomic, assign) BOOL showHorSeprateLine;

@property (nonatomic,   copy, readonly) NSArray <UIButton *> *buttons;

- (UIButton *)installButton;
- (void)unInstallButton:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
