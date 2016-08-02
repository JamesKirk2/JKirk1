//
//  LogActivityViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 28/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LogActivityViewCell.h"

@interface LogActivityViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *challengeTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblChallengeName;
@property (weak, nonatomic) IBOutlet UILabel *lblChallengeStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblChallengeEndDate;
@property (weak, nonatomic) IBOutlet UILabel *lblChallengeGoalUnit;
@property (weak, nonatomic) IBOutlet UITextField *txtEnteredGoal;
@property (weak, nonatomic) IBOutlet UILabel *lblTargetHeading;

@property (strong, nonatomic) NSDictionary *goalUnitDict;
@property (weak, nonatomic) Challenge *challenge;

@end

@implementation LogActivityViewCell

- (void)awakeFromNib {
    // Initialization code
    self.txtEnteredGoal.layer.cornerRadius = TEXTFIELD_CORNER_RADIUS;
    if (!self.goalUnitDict) {
        self.goalUnitDict = @{@"distance":@"Miles", @"time":@"Mins", @"steps":@"Steps", @"floors":@"Floors", @"calories":@"Calories", @"storeys":@"Storeys", @"height":@"Meters"};
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCurrentChallenge:(Challenge *)challenge {
    self.challenge = challenge;
    
    NSString *goalUnit = [challenge challengeGoalUnit];
    [self.lblChallengeName setText:[[challenge challengeName] uppercaseString]];
    [self.lblChallengeStartDate setText:[CommonFunctions formatDateForLogActivity:[challenge startDate]]];
    [self.lblChallengeEndDate setText:[CommonFunctions formatDateForLogActivity:[challenge endDate]]];
    [self.lblChallengeGoalUnit setText:[goalUnit uppercaseString]];
    [self.lblTargetHeading setText:[NSString stringWithFormat:@"Target %@ - %@", self.goalUnitDict[[goalUnit lowercaseString]], [challenge challengeGoal]]];
    [self.txtEnteredGoal setPlaceholder:self.goalUnitDict[[goalUnit lowercaseString]]];
}

- (void)setChallengeTypeImage:(UIImage *)image {
    [self.challengeTypeImageView setImage:image];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.profileCellDelegate callBackForScollingCell:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
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
