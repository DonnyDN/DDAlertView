//
//  ViewController.m
//  DDAlertView
//
//  Created by duning03 on 2021/7/1.
//

#import "ViewController.h"
#import "DDExampleAlertView.h"
#import "DDAlertView.h"
#import "DDAlertView1.h"
#import "DDTextFieldAlertView.h"
#import "DDTextViewAlertView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *titleArray;
@property (copy, nonatomic) NSArray *subTitleArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[
        @[
            @{@"结构示例：内容区域+交互区域" : NSStringFromSelector(@selector(showExampleAlertView))}
        ],
        @[
            @{@"标准弹窗" : NSStringFromSelector(@selector(showAlertView))},
            @{@"富文本内容" : NSStringFromSelector(@selector(showAttributeMsgAlertView))},
            @{@"仅1个按钮" : NSStringFromSelector(@selector(showAlertView1))},
            @{@"自定义按钮" : NSStringFromSelector(@selector(showAlertView11))},
        ],
        @[
            @{@"输入框高度固定" : NSStringFromSelector(@selector(showTextFieldAlert))},
            @{@"输入框高度随内容变化" : NSStringFromSelector(@selector(showTextViewAlert))},
        ]
    ];
    
    _subTitleArray = @[
        @[
            @"DDExampleAlertView"
        ],
        @[
            @"DDAlertView",
            @"DDAlertView",
            @"DDAlertView",
            @"DDAlertView"
        ],
        @[
            @"DDTextFieldAlertView",
            @"DDTextViewAlertView"
        ]
    ];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - UITableView Delegate | Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = _titleArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict.allKeys.firstObject;
    cell.detailTextLabel.text = _subTitleArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width, 20)];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    switch (section) {
        case 1: label.text = @"普通样式："; break;
        case 2: label.text = @"带输入框："; break;
        default: break;
    }

    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = _titleArray[indexPath.section][indexPath.row];
    NSString *value = dict.allValues.firstObject;
    [self performSelector:NSSelectorFromString(value)];
}

#pragma mark - Alert

// 结构示例弹窗
- (void)showExampleAlertView {
    [[DDExampleAlertView alert] show];
}

// 富文本内容
- (void)showAttributeMsgAlertView {
    NSString *str1 = @"■使用AutoLayout撑开view，内容灵活展示；\n■结构分为：内容区域 / 交互区域\n■只需继承DDPopupView，实现两个协议方法，在里面自定义两个区域view即可。";
    NSString *str2 = @"\n①扩展性强；\n②默认自销毁block，防止内存泄漏；\n③调用方便，类方法写就是了；\n④自动监控键盘，输入框还能防遮挡~";
    NSString *str = [NSString stringWithFormat:@"%@%@", str1, str2];
    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
    para.lineSpacing = 4;
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{
        NSFontAttributeName : [UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName : [UIColor grayColor],
        NSParagraphStyleAttributeName : para
    }];
    [mAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]
                     range:[str rangeOfString:str2]];
    DDAlertView *alert = [DDAlertView alertWithTitle:@"温馨提示" attrMessage:mAttrStr cancelTitle:@"取消" cancelAction:^{
        
    } confirmTitle:@"确定" confirmAction:^{
        
    }];
    alert.messageAlignment = NSTextAlignmentLeft;
    [alert show];
}

// 普通弹窗
- (void)showAlertView {
    [[DDAlertView alertWithTitle:@"温馨提示"
                         message:@"这里是提示内容，也可以传入富文本，内容高度自适应撑开"
                     cancelTitle:@"取消" cancelAction:nil
                    confirmTitle:@"好的" confirmAction:^{
        NSLog(@"点击了好的");
    }] show];
}

// 普通弹窗-仅1个按钮
- (void)showAlertView1 {
    [[DDAlertView alertWithTitle:@"温馨提示"
                         message:@"取消按钮标题传空，就只剩下确认按钮了"
                     cancelTitle:nil cancelAction:nil
                    confirmTitle:@"好的" confirmAction:^{
        NSLog(@"点击了好的");
    }] show];
}

// 普通弹窗-自定义按钮样式
- (void)showAlertView11 {
    [[DDAlertView1 alertWithTitle:@"温馨提示"
                          message:@"自定义点击按钮样式，两个按钮样式随便修改"
                      cancelTitle:@"取消" cancelAction:nil
                     confirmTitle:@"好的" confirmAction:^{
        NSLog(@"点击了好的");
    }] show];
}

// 输入框弹窗-TextField
- (void)showTextFieldAlert {
    [[DDTextFieldAlertView alertWithTitle:@"输入框固定高度"
                                  content:@"123456789"
                              cancelTitle:@"取消"
                             cancelAction:^{}
                             confirmTitle:@"确认"
                            confirmAction:^{}] show];
}

// 输入框弹窗-TextView
- (void)showTextViewAlert {
    DDTextViewAlertView *alert = [DDTextViewAlertView alertWithTitle:@"输入框自增高"
                                                             content:nil
                                                         cancelTitle:@"取消"
                                                        cancelAction:^{}
                                                        confirmTitle:@"确认"
                                                       confirmAction:^{}];
//    alert.actionAutoDismiss = NO;
    [alert show];
}

@end
