//
//  DDTextView.h
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTextView : UITextView

/// 占位文字
@property (nonatomic,   copy) NSString *placeholder;
/// 占位颜色
@property (nonatomic, strong) UIColor *placeholderColor;
/// 占位字体
@property (nonatomic, strong) UIFont *placeholderFont;

/// 高度随内容自动变化（默认NO）
@property (nonatomic, assign) BOOL isAutoHeight;
/// 自动变化的最大高度
@property (nonatomic, assign) CGFloat maxAutoHeight;

@end

NS_ASSUME_NONNULL_END
