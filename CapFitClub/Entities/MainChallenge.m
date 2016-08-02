//
//  MainChallenge.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "MainChallenge.h"
#import "Activity.h"
#import "User.h"
#import "CommonFunctions.h"

@implementation MainChallenge

// Insert code here to add functionality to your managed object subclass
- (void)setAttributes:(NSDictionary *)challengeDict {
    self.challengeName = [self checkIfNull:challengeDict[@"name"]];
    self.challengeDescription = [self checkIfNull:challengeDict[@"description"]];
    self.challengeId = [self checkIfNull:challengeDict[@"challengeId"]];
    self.challengeType = [self checkIfNull:challengeDict[@"type"]];
    self.challengeGoal = [self checkIfNull:challengeDict[@"goal"]];
    self.challengeGoalUnit = [self checkIfNull:challengeDict[@"goal_unit"]];
    self.isSearchable = [self checkIfNull:challengeDict[@"isSearchable"]];
    self.adminId = [self checkIfNull:challengeDict[@"adminId"]];
    
    long long startDateInterval = [[self checkIfNull:challengeDict[@"startDate"]] longLongValue];
    self.startDate = [NSDate dateWithTimeIntervalSince1970:startDateInterval];
    
    long long endDateInterval = [[self checkIfNull:challengeDict[@"endDate"]] longLongValue];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:endDateInterval];
    
    self.completedQuantity = [self checkIfNull:challengeDict[@"completed"]];
}

- (id)checkIfNull:(id)value {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}
@end
