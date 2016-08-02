//
//  LocalChallenge.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LocalChallenge.h"
#import "Challenge.h"

@implementation LocalChallenge

// Insert code here to add functionality to your managed object subclass
- (void)setAttributesFromChallenge:(Challenge *)challenge {
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
    
    self.sectionIdentifierForChallenge = [[self.challengeName substringToIndex:1] uppercaseString];
}

- (NSString *)uniqueSectionIdentifierForChallenge {
    if (!self.sectionIdentifierForChallenge) {
        self.sectionIdentifierForChallenge = [[self.challengeName substringToIndex:1] uppercaseString];
    }
    return self.sectionIdentifierForChallenge;
}
@end
