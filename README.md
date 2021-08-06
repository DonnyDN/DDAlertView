# DDAlertView

> 一个灵活易扩展的弹窗。  
> 使用方便;  
> 自定义样式;  
> 带输入框时自动防遮挡;  
> block防止内存泄漏~  


![alert](https://user-images.githubusercontent.com/16277225/128472441-11367a20-f0da-4129-adae-209f6d934938.gif)
![alert1](https://user-images.githubusercontent.com/16277225/128472454-3b2ccdf2-d263-40d0-881c-1cf5fdde31be.gif)
![alert2](https://user-images.githubusercontent.com/16277225/128472471-dea5a969-7868-4ca1-880b-1d9b9608e5f7.gif)


极易扩展:

普通业务弹窗，只需继承`DDPopupView`，实现以下两个协议方法，返回你自定义的2个view（展示区域+交互区域）即可
```
#pragma mark - DDPopupViewProtocol

/// 弹窗上部分（展示内容）
- (UIView *)popup_prepareCustomView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor orangeColor];
    
    // 此处自定义
    
    return view;
}

/// 弹窗下部分（交互按钮）
- (UIView *)popup_prepareActionView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor yellowColor];
    
    // 此处自定义
    
    return view;
}
```

普通弹窗：
```
[[DDAlertView alertWithTitle:@"温馨提示"
                     message:@"这里是提示内容，也可以传入富文本，内容高度自适应撑开"
                 cancelTitle:@"取消" cancelAction:nil
                confirmTitle:@"好的" confirmAction:^{
    NSLog(@"点击了好的");
}] show];
```

富文本内容：
```
NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:...
DDAlertView *alert = [DDAlertView alertWithTitle:@"温馨提示" 
                                     attrMessage:attrStr 
                                     cancelTitle:@"取消" cancelAction:^{
    
} confirmTitle:@"确定" confirmAction:^{
    
}];
alert.messageAlignment = NSTextAlignmentLeft;
[alert show];
```

输入框弹窗：
```
[[DDTextFieldAlertView alertWithTitle:@"输入框固定高度"
                              content:@"123456789"
                          cancelTitle:@"取消"
                         cancelAction:^{}
                         confirmTitle:@"确认"
                        confirmAction:^{}] show];
```
```
DDTextViewAlertView *alert = [DDTextViewAlertView alertWithTitle:@"输入框自增高"
                                                         content:nil
                                                     cancelTitle:@"取消"
                                                    cancelAction:^{}
                                                    confirmTitle:@"确认"
                                                   confirmAction:^{}];
// alert.actionAutoDismiss = NO;
[alert show];
```




