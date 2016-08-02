//
//  Challenge.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "Challenge.h"
#import "LocalChallenge.h"

@implementation Challenge

// Insert code here to add functionality to your managed object subclass
- (void)setAttributesFromLocalChallenge:(LocalChallenge *)challenge {
    self.challengeDescription = challenge.challengeDescription;
    self.challengeId = challenge.challengeId;
    self.challengeName = challenge.challengeName;
    self.challengeType = challenge.challengeType;
    self.startDate = challenge.startDate;
    self.endDate = challenge.endDate;
    self.challengeGoal = challenge.challengeGoal;
    self.challengeGoalUnit = challenge.challengeGoalUnit;
    self.completedQuantity = challenge.completedQuantity;
    self.isSearchable = challenge.isSearchable;
    self.isCompleted = challenge.isCompleted;
    if (challenge.activities) {
        self.activities = [NSOrderedSet orderedSetWithOrderedSet:challenge.activities];
    }
    if (challenge.users) {
        self.users = [NSOrderedSet orderedSetWithOrderedSet:challenge.users];
    }
}

- (NSString *)uniqueSectionIdentifierForChallenge {
    if (!self.sectionIdentifierForChallenge) {        
        if ([[self endDate] timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970] && ![[self isCompleted] boolValue]) {
            self.sectionIdentifierForChallenge = @"My Challenges";
        } else {
            self.sectionIdentifierForChallenge = @"Completed Challenges";
        }
    }
    return self.sectionIdentifierForChallenge;
}
@end
