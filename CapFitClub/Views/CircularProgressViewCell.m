//
//  CircularProgressViewCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 03/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CircularProgressViewCell.h"
#import "MBCircularProgressBarView.h"
#import "User.h"

@interface CircularProgressViewCell()

@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *circularProgressQuantity;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *circularProgressDuration;

@property (weak, nonatomic) IBOutlet UILabel *goalUnitLabel;

@property (strong, nonatomic) Challenge *currentChallenge;
@property (strong, nonatomic) NSDictionary *goalUnitDict;
@end

@implementation CircularProgressViewCell

- (void)awakeFromNib {
    // Initialization code
    self.goalUnitDict = @{@"calories":@"Calories burned", @"steps":@"Steps climbed", @"floors":@"Floors climbed", @"distance":@"Distance covered", @"time":@"Mins. elapsed", @"height":@"Height covered"};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setValueForCompletion:(NSNumber *)value {
    [self.circularProgressQuantity setValue:[value longLongValue] animateWithDuration:1.0];
}

- (void)setValueForDuration:(NSDateComponents *)value {
    [self.circularProgressDuration setValue:((value.day > 0) ? ((value.hour > 0) ? (value.day + 1) : value.day) : ((value.hour > 0) ? 1 : 0)) animateWithDuration:1.0];
}

- (void)setChallenge:(Challenge *)challenge {
    self.currentChallenge = challenge;
    
    NSString *unitName = [[self.currentChallenge challengeGoalUnit] lowercaseString];
    [self.goalUnitLabel setText:self.goalUnitDict[unitName]];
    
    long long totalQuantity = [[self.currentChallenge challengeGoal] longLongValue];
    [self.circularProgressQuantity setMaxValue:totalQuantity];
    [self.circularProgressQuantity setValue:0];
    
    __block long long completedQuantity = 0;
    NSArray *users = [[self.currentChallenge users] array];
    [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        User *user = (User *)obj;
        completedQuantity += [[user completedQuantity] longLongValue];
    }];
    
    if (completedQuantity > totalQuantity) {
        completedQuantity = totalQuantity;
    }
    NSDateComponents *totalDays = [CommonFunctions getDateComponentsFromEndDate:[self.currentChallenge endDate] toStartDate:[self.currentChallenge startDate]];
    NSDateComponents *completedDays = [CommonFunctions getDateComponentsFromEndDate:[self.currentChallenge endDate] toStartDate:[NSDate date]];
    
    NSDateComponents *value = totalDays;
    [self.circularProgressDuration setMaxValue:((value.day > 0) ? ((value.hour > 0) ? (value.day + 1) : value.day) : ((value.hour > 0) ? 1 : 0))];
    [self.circularProgressDuration setValue:((value.day > 0) ? ((value.hour > 0) ? (value.day + 1) : value.day) : ((value.hour > 0) ? 1 : 0))];
    
    [self performSelector:@selector(setValueForCompletion:) withObject:[NSNumber numberWithLongLong:completedQuantity] afterDelay:0.5];
    [self performSelector:@selector(setValueForDuration:) withObject:completedDays afterDelay:0.5];
}

@end
