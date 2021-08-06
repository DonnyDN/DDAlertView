//
//  DDTextField.m
//  DDAlertView
//
//  Created by duning03 on 2021/8/5.
//

#import "DDTextField.h"

@interface DDTextField ()

@end

@implementation DDTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.returnKeyType = UIReturnKeyDone;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:16.0];
        
        self.cursorOffset = 10;
    }
    return self;
}

#pragma mark - Override

- (CGRect)textRectForBounds:(CGRect)bounds {
    BOOL hasClearBtn = self.clearButtonMode != UITextFieldViewModeNever;
    CGFloat originX = bounds.origin.x + self.cursorOffset;
    return CGRectMake(originX,
                      bounds.origin.y,
                      bounds.size.width - originX - (hasClearBtn ? 25 : 0),
                      bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    BOOL hasClearBtn = self.clearButtonMode != UITextFieldViewModeNever;
    CGFloat originX = bounds.origin.x + self.cursorOffset;
    return CGRectMake(originX,
                      bounds.origin.y,
                      bounds.size.width - originX - (hasClearBtn ? (25+2) : 0),
                      bounds.size.height);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGFloat originX = bounds.origin.x + self.cursorOffset;
    return CGRectMake(originX,
                      bounds.origin.y,
                      bounds.size.width - originX,
                      bounds.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.size.width - 25, (bounds.size.height - 15) * 0.5f, 15, 15);
}


//自定义光标Frame
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.origin.y = CGRectGetMidY(originalRect) - 22 * 0.5f;
    originalRect.size.height = 22;
    originalRect.size.width = 2;
    return originalRect;
}

#pragma mark - Getter & Setter

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    if (placeholder.length > 0) {
        NSMutableDictionary *attr = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]}.mutableCopy;
        if (_placeholderFont) {
            [attr setValue:_placeholderFont forKey:NSFontAttributeName];
        }
        if (_placeholderColor) {
            [attr setValue:_placeholderColor forKey:NSForegroundColorAttributeName];
        }
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:attr];
        self.attributedPlaceholder = placeholderString;
    }
}

@end
