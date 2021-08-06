//
//  DDTextView.m
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import "DDTextView.h"

@interface DDTextView ()

@end

@implementation DDTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)note {
    // 会重新调用 drawRect
    [self setNeedsDisplay];
}

// 每次调用 drawRect 都会将以前画的东西清除掉
- (void)drawRect:(CGRect)rect {
    if (self.hasText) return;
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.placeholderFont ?: self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor ?: self.textColor;
    
    CGRect caretFrame = [self caretRectForPosition:self.beginningOfDocument]; // 光标Frame
    CGFloat placeholderHeight = [self.placeholder sizeWithAttributes:attrs].height;
    
    rect.origin.x = caretFrame.origin.x + 2;
    if (placeholderHeight < caretFrame.size.height) {
        rect.origin.y = caretFrame.origin.y + (caretFrame.size.height - placeholderHeight) / 2.f;
    } else {
        rect.origin.y = caretFrame.origin.y;
    }
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat contentHeight = [self sizeThatFits:CGSizeMake(self.frame.size.width, 0)].height;
        if (contentHeight < self.maxAutoHeight) {
            self.contentOffset = CGPointZero;
        }
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(MIN(self.maxAutoHeight, contentHeight));
        }];
    });
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
