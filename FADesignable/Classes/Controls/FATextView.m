//
//  FATextView.m
//  FADesignable
//
//  Created by Fadi Abuzant on 7/6/18.
//

#import "FATextView.h"

@implementation FATextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //handle edit mode
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textViewEditStatusChanged:) name:UITextViewTextDidBeginEditingNotification object:self];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textViewEditStatusChanged:) name:UITextViewTextDidEndEditingNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateDesignable];
}

-(void)updateDesignable{
    
    if (!bottomBorder && _isBottomBorder) {
        bottomBorder = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        bottomBorder.backgroundColor = isEditing ? _editingBorderColor : self.selected ? _selectedBorderColor : _borderColor;
        [self addSubview:bottomBorder];
    } else if (_isBottomBorder)
    {
        bottomBorder.backgroundColor = isEditing ? _editingBorderColor : self.selected ? _selectedBorderColor : _borderColor;
    }
    else
    {
        if (self.borderColor)
            self.layer.borderColor = isEditing ? [_editingBorderColor CGColor] : self.selected ? [_selectedBorderColor CGColor] : [_borderColor CGColor];
        
        if (self.borderWidth)
            self.layer.borderWidth = self.borderWidth;
        
        if (self.cornerRadius || self.cornerIsCircle)
            [self.layer setCornerRadius:self.cornerIsCircle ? self.frame.size.height/2 :self.cornerRadius];
    }
    
    //background
    if (isEditing) {
        if(_editingBackgroundColor)
            self.layer.backgroundColor = [_editingBackgroundColor CGColor];
    }else if (self.selected) {
        if(_selectedBackgroundColor)
            self.layer.backgroundColor = [_selectedBackgroundColor CGColor];
    } else {
        if(_normalBackgroundColor)
            self.layer.backgroundColor = [_normalBackgroundColor CGColor];
        else
            self.layer.backgroundColor = nil;
    }
    
    // drop shadow
    if (self.shadowRadius)
        [self.layer setShadowRadius:self.shadowRadius];
    
    if (self.shadowOpacity)
        [self.layer setShadowOpacity:self.shadowOpacity];
    
    if (self.shadowColor){
        [self.layer setShadowColor:self.shadowColor.CGColor];
        [self.layer setShadowOffset:self.shadowOffset];
        [self.layer setMasksToBounds:NO];
    }else{
        [self.layer setMasksToBounds:YES];
    }
    
    // set padding
    self.textContainerInset =UIEdgeInsetsMake(_textTopPadding ? _textTopPadding : self.textContainerInset.top,
                                              _textStartPadding ? _textStartPadding : self.textContainerInset.left,
                                              self.textContainerInset.bottom,
                                              _textStartPadding ? _textStartPadding : self.textContainerInset.right);
}

- (void)textViewEditStatusChanged:(NSNotification *)notification{
    if (notification.object == self){
        isEditing = notification.name == UITextViewTextDidBeginEditingNotification;
        [self updateDesignable];
    }
    
}

@end
