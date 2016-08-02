//
//  ChallengesViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 23/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ChallengesViewCell.h"
#import "Activity.h"

@interface ChallengesViewCell()<FilledChallengesViewDelegate>

@property (weak, nonatomic) IBOutlet FilledChallengesView *filledChallengeView;
@property (weak, nonatomic) IBOutlet UILabel *formatedEndDate;
@property (weak, nonatomic) IBOutlet UILabel *formattedCompletedValue;
@property (strong, nonatomic) MainChallenge *challenge;
@property (strong, nonatomic) NSDictionary *goalUnitDict;
@end

@implementation ChallengesViewCell

- (void)awakeFromNib {
    // Initialization code
    self.filledChallengeView.layer.cornerRadius = 22.0;
    if (!self.goalUnitDict) {
        self.goalUnitDict = @{@"distance":@"Miles", @"time":@"Mins", @"steps":@"Steps", @"floors":@"Floors", @"calories":@"Calories", @"storeys":@"Storeys", @"height":@"Meters"};
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)addGesture {
    [self.filledChallengeView addGesture];
}

- (void)setMainChallengeObject:(MainChallenge *)challenge {
    self.challenge = challenge;
    [self.filledChallengeView setMainChallengeObject:challenge];
    [self.filledChallengeView setFilledChallengesViewDelegate:self];
    
    NSString *endDate = [NSString stringWithFormat:@"Ends on %@", [CommonFunctions formatDateForLogActivity:[challenge endDate]]];
    [self.formatedEndDate setText:endDate];
}

- (void)setCompletedChallengeObject:(MainChallenge *)challenge {
    self.challenge = challenge;
    [self.filledChallengeView setMainChallengeObject:challenge];
    [self.filledChallengeView setFilledChallengesViewDelegate:self];
    
    Activity *logActivity = [[self.challenge activities] lastObject];
    NSString *endDate = [NSString stringWithFormat:@"Completed on %@", [CommonFunctions formatDateForLogActivity:[logActivity activityDate]]];
    [self.formatedEndDate setText:endDate];
}

- (void)setUserObject:(User *)user {
    [self.filledChallengeView setUserObject:user];
    NSNumber *completedQuantity = [user completedQuantity];
    NSNumber *totalQuantity = [self.challenge challengeGoal];
    if ([completedQuantity longLongValue] > [totalQuantity longLongValue]) {
        completedQuantity = totalQuantity;
    }
    NSString *completedValue = [NSString stringWithFormat:@"%@ of %@ %@", completedQuantity, totalQuantity, self.goalUnitDict[[self.challenge.challengeGoalUnit lowercaseString]]];
    [self.formattedCompletedValue setText:completedValue];
}

- (void)refreshView {
    [self.filledChallengeView refreshView];
}

- (void)hideDeleteButton {
    [self.filledChallengeView hideDeleteButton];
}

- (void)sendSelectedCell:(BOOL)isSelected {
    if (isSelected) {
        [self.challengesViewCellDelegate sendSelectedCell:self];
    } else {
        [self.challengesViewCellDelegate sendSelectedCell:nil];
    }
}

- (void)deleteCell:(BOOL)isDelete {
    [self.challengesViewCellDelegate deleteSelectedCell:self];
}

@end
