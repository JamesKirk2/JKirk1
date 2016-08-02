//
//  LogActivityUpdateCell.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 28/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LogActivityUpdateCell.h"

@interface LogActivityUpdateCell()

@property (weak, nonatomic) IBOutlet UILabel *lblActivityDate;
@property (weak, nonatomic) IBOutlet UILabel *lblActivityValue;
@property (weak, nonatomic) IBOutlet UILabel *lblActivityGoalUnit;

@property (weak, nonatomic) Activity *activity;
@property (strong, nonatomic) NSDictionary *goalUnitDict;
@end

@implementation LogActivityUpdateCell

- (void)awakeFromNib {
    // Initialization code
    if (!self.goalUnitDict) {
        self.goalUnitDict = @{@"distance":@"Miles", @"time":@"Mins", @"steps":@"Steps", @"floors":@"Floors", @"calories":@"Calories", @"storeys":@"Storeys", @"height":@"Meters"};
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLogActivity:(Activity *)activity WithGoalUnit:(NSString *)goalUnit {
    self.activity = activity;
    
    [self.lblActivityDate setText:[CommonFunctions formatDateForLogActivity:[activity activityDate]]];
    [self.lblActivityValue setText:[[activity activityValue] stringValue]];
    [self.lblActivityGoalUnit setText:self.goalUnitDict[[goalUnit lowercaseString]]];
}
@end
