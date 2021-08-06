//
//  DDTextViewAlertView.h
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import "DDPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTextViewAlertView : DDPopupView

// 触发事件按钮，是否自动弹窗消失（默认YES）
@property (nonatomic, assign) BOOL actionAutoDismiss;

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                       content:(NSString *_Nullable)content
                   cancelTitle:(NSString *_Nullable)cancelTitle
                  cancelAction:(dispatch_block_t _Nullable)cancelAction
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction;
@end

NS_ASSUME_NONNULL_END
