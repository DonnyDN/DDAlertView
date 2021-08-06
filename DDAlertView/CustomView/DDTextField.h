//
//  DDTextField.h
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTextField : UITextField

/// 占位文本字体
@property (nonatomic, strong) UIFont *placeholderFont;

/// 占位文本颜色
@property (nonatomic, strong) UIColor *placeholderColor;

/// 光标偏移量（默认25）
@property (nonatomic, assign) CGFloat cursorOffset;

@end

NS_ASSUME_NONNULL_END
