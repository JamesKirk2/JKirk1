//
//  DescriptionViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "DescriptionViewCell.h"

@interface DescriptionViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionPlaceholder;
@end

@implementation DescriptionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.textView.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDescriptionText:(NSString *)descriptionText {
    [self.textView setText:descriptionText];
    [self.lblDescriptionText setText:descriptionText];
    if (descriptionText) {
        [self.descriptionPlaceholder setHidden:YES];
    }
}

- (void)makeTextViewAsFirstResponder {
    [self.textView becomeFirstResponder];
}

- (void)resignTextViewAsFirstResponder {
    [self.textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.profileCellDelegate callBackForScollingCell:self];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self.profileCellDelegate callBackForMakingNextCellAsFirstResponder:self];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location != 0) {
        [self.descriptionPlaceholder setHidden:YES];
    } else {
        if (text.length != 0) {
            [self.descriptionPlaceholder setHidden:YES];
        } else {
            [self.descriptionPlaceholder setHidden:NO];
        }
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *strValue = [textView text];
    if (text.length == 0) {
        strValue = [strValue substringToIndex:range.location];
    } else {
        strValue = [strValue stringByAppendingString:text];
    }
    [self.profileCellDelegate setValueForCell:self withValue:strValue];
    return YES;
}

@end
