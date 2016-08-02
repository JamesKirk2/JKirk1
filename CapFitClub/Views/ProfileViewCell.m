//
//  ProfileViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ProfileViewCell.h"
#import "CustomTextField.h"

@interface ProfileViewCell()

@property (weak, nonatomic) IBOutlet UIView *backgroundCellView;
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *valueButton;

- (IBAction)buttonClicked:(id)sender;
@end

@implementation ProfileViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundCellView.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    self.valueTextField.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeadingText:(NSString *)heading {
    [self.headingLabel setText:heading];
//    [self.headingLabel setFont:[UIFont fontWithName:@"PT Sans" size:20.0]];
}

- (void)setTextFieldPlaceholderText:(NSString *)text withTag:(NSInteger)tag {
    [self.valueTextField setPlaceholder:[text lowercaseString]];
    [self.valueTextField setTag:tag];
    [self.valueTextField setHidden:NO];
    [self.valueButton setHidden:YES];
}

- (void)setTextFieldText:(NSString *)text withReturnKey:(UIReturnKeyType) returnKeyType {
    [self.valueTextField setText:text];
    [self.valueTextField setReturnKeyType:returnKeyType];
}

- (void)setPlaceHolderForButton:(NSString *)placeholder {
    [self.valueButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    [self.valueButton setTitle:placeholder forState:UIControlStateNormal];
    [self.valueTextField setHidden:YES];
    [self.valueButton setHidden:NO];
}

- (void)setButtonValue:(NSString *)text {
    [self.valueButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.valueButton setTitle:text forState:UIControlStateNormal];
    [self.valueTextField setHidden:YES];
    [self.valueButton setHidden:NO];
}

- (void)makeTextFieldAsFirstResponder {
    [self.valueTextField becomeFirstResponder];
}

- (void)resignTextFieldAsFirstResponder {
    [self.valueTextField resignFirstResponder];
}

- (IBAction)buttonClicked:(id)sender {
    [self.profileCellDelegate callBackForScollingCell:self];
}

- (void)makeButtonAsFirstResponder {
    [self.profileCellDelegate callBackForScollingCell:self];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.profileCellDelegate callBackForScollingCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.profileCellDelegate callBackForMakingNextCellAsFirstResponder:self];
        return NO;
    }
    else {
        return [textField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *strValue = [textField text];
    if (string.length == 0) {
        strValue = [strValue substringToIndex:range.location];
    } else {
        strValue = [strValue stringByAppendingString:string];
    }
    [self.profileCellDelegate setValueForCell:self withValue:strValue];
    return YES;
}

@end
