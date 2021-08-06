//
//  DDAlertView1.h
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import "DDPopupView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDAlertView1 : DDPopupView

// message textAlignment （默认 center）
@property (nonatomic, assign) NSTextAlignment messageAlignment;

// 触发事件按钮，是否自动弹窗消失（默认YES）
@property (nonatomic, assign) BOOL actionAutoDismiss;

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                       message:(NSString *_Nullable)message
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction;

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                       message:(NSString *_Nullable)message
                   cancelTitle:(NSString *_Nullable)cancelTitle
                  cancelAction:(dispatch_block_t _Nullable)cancelAction
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction;

+ (instancetype)alertWithTitle:(NSString *_Nullable)title
                   attrMessage:(NSAttributedString *_Nullable)attrMessage
                   cancelTitle:(NSString *_Nullable)cancelTitle
                  cancelAction:(dispatch_block_t _Nullable)cancelAction
                  confirmTitle:(NSString *_Nullable)confirmTitle
                 confirmAction:(dispatch_block_t _Nullable)confirmAction;

+ (instancetype)alertWithAttrTitle:(NSAttributedString *_Nullable)attrTitle
                       attrMessage:(NSAttributedString *_Nullable)attrMessage
                       cancelTitle:(NSString *_Nullable)cancelTitle
                      cancelAction:(dispatch_block_t _Nullable)cancelAction
                      confirmTitle:(NSString *_Nullable)confirmTitle
                     confirmAction:(dispatch_block_t _Nullable)confirmAction;

@end

NS_ASSUME_NONNULL_END
