//
//  SetChallengeGoalViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 01/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SetChallengeGoalViewCell.h"

@interface SetChallengeGoalViewCell()

@property (weak, nonatomic) IBOutlet UISegmentedControl *goalSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *txtCondition1;
@property (weak, nonatomic) IBOutlet UILabel *lblCondition1;
@property (weak, nonatomic) IBOutlet UITextField *txtCondition2;
@property (weak, nonatomic) IBOutlet UILabel *lblCondition2;
@property (weak, nonatomic) IBOutlet UIView *backgroundSegmentView;

- (IBAction)valueChanged:(id)sender;
@end

@implementation SetChallengeGoalViewCell

- (void)awakeFromNib {
    // Initialization code
    self.txtCondition1.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    self.txtCondition2.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    [self.goalSegmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.goalSegmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:5.0/255.0 green:86.0/255.0 blue:144.0/255.0 alpha:1.0]} forState:UIControlStateSelected];
    
    [self.goalSegmentControl setBackgroundImage:[UIImage imageNamed:@"transparentNavBar"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.goalSegmentControl setBackgroundImage:[UIImage imageNamed:@"segmentBackground"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    self.backgroundSegmentView.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    self.backgroundSegmentView.layer.borderColor = [[[UIColor alloc] initWithWhite:1.0 alpha:0.2] CGColor];
    self.backgroundSegmentView.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSegmentWithItems:(NSArray *)items {
    [self.goalSegmentControl removeAllSegments];
    
    for (int i = 0; i < [items count]; i++) {
        NSString *item = items[i];
        [self.goalSegmentControl insertSegmentWithTitle:item atIndex:i animated:NO];
    }
}

- (void)setGoal:(NSNumber *)goal withGoalUnit:(NSString *)goalUnit {
    NSInteger selectedIndex = 0;
    NSInteger noOfSegments = [self.goalSegmentControl numberOfSegments];
    
    if (goalUnit) {
        for (int i = 0; i < noOfSegments; i++) {
            NSString *title = [self.goalSegmentControl titleForSegmentAtIndex:i];
            if ([[title lowercaseString] isEqualToString:[goalUnit lowercaseString]]) {
                selectedIndex = i;
                break;
            }
        }
    }
    
    if (noOfSegments > 0) {
        [self.goalSegmentControl setSelectedSegmentIndex:selectedIndex];
        [self valueChanged:self.goalSegmentControl];
        
        if ([[goalUnit lowercaseString] isEqualToString:@"time"]) {
            long long hours = ([goal longLongValue] / 60);
            long long mins = ([goal longLongValue] % 60);
            [self.txtCondition1 setText:[NSString stringWithFormat:@"%lld", hours]];
            [self.txtCondition2 setText:[NSString stringWithFormat:@"%lld", mins]];
        } else {
            [self.txtCondition1 setText:[goal stringValue]];
        }
    }
}

- (IBAction)valueChanged:(id)sender {
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    
    NSString *title = [segmentControl titleForSegmentAtIndex:[segmentControl selectedSegmentIndex]];
    
    [self.txtCondition1 setHidden:NO];
    [self.lblCondition1 setHidden:NO];
    [self.txtCondition1 setReturnKeyType:UIReturnKeyDone];
    
    
    [self.txtCondition2 setHidden:YES];
    [self.lblCondition2 setHidden:YES];
    [self.txtCondition2 setReturnKeyType:UIReturnKeyDone];
    
    if ([[title lowercaseString] isEqualToString:@"distance"]) {
        [self.lblCondition1 setText:@"miles"];
    } else if([[title lowercaseString] isEqualToString:@"time"]) {
        [self.txtCondition2 setHidden:NO];
        [self.lblCondition2 setHidden:NO];
        [self.txtCondition1 setReturnKeyType:UIReturnKeyNext];
        
        [self.lblCondition1 setText:@"hours"];
        [self.lblCondition2 setText:@"mins"];
    } else if([[title lowercaseString] isEqualToString:@"height"]) {
        [self.lblCondition1 setText:@"meters"];
    } else if([[title lowercaseString] isEqualToString:@"floors"] ||
              [[title lowercaseString] isEqualToString:@"storeys"]  ||
              [[title lowercaseString] isEqualToString:@"calories"] ||
              [[title lowercaseString] isEqualToString:@"steps"]) {
        
        [self.lblCondition1 setText:[title lowercaseString]];
    }
    
    [self.profileCellDelegate setGoalUnitForChallenge:title];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.profileCellDelegate callBackForScollingCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.txtCondition2 becomeFirstResponder];
        return NO;
    }
    else {
        if (![self.txtCondition2 isHidden]) {
            [self.profileCellDelegate callBackForMakingNextCellAsFirstResponder:self];
        }
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
    
    if (![self.txtCondition2 isHidden]) {
        NSString *hours = [self.txtCondition1 text];
        NSString *mins = [self.txtCondition2 text];
        
        if ([textField isEqual:self.txtCondition1]) {
            hours = (strValue) ? strValue : @"0";
        } else {
            mins = (strValue) ? strValue : @"0";
        }
        strValue = [NSString stringWithFormat:@"%d", (([hours intValue] * 60) + [mins intValue])];
    }
    [self.profileCellDelegate setValueForCell:self withValue:strValue];
    return YES;
}
@end
