//
//  DDAlertView.h
//  aiinquiry
//
//  Created by duning03 on 2021/6/18.
//  Copyright © 2021 Baidu. All rights reserved.
//

#import "DDPopupView.h"
@class DDAlertDefaultModel;

NS_ASSUME_NONNULL_BEGIN

@interface DDAlertView : DDPopupView

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

+ (void)configDefaultAlertStyle:(void(^)(DDAlertDefaultModel *_Nonnull model))style;

@end


@interface DDAlertDefaultModel : NSObject
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, assign) CGFloat messageLineSpace;
@property (nonatomic, assign) NSTextAlignment messageAlignment;
@end

NS_ASSUME_NONNULL_END
