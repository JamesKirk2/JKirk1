//
//  Activity.m
//  
//
//  Created by Sumit Sancheti on 04/02/16.
//
//

#import "Activity.h"
#import "Challenge.h"
#import "User.h"

@implementation Activity

// Insert code here to add functionality to your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes {
    NSNumber *userId = attributes[@"userId"];
    if (userId) {
        self.userId = [self checkIfNull:userId];
    }
    NSNumber *challengeId = attributes[@"challengeId"];
    if (challengeId) {
        self.challengeId = [self checkIfNull:challengeId];
    }
    NSNumber *activityDate = attributes[@"date"];
    if (activityDate) {
        long long dateInterval = [[self checkIfNull:activityDate] longLongValue];
        self.activityDate = [NSDate dateWithTimeIntervalSince1970:dateInterval];
    }
    NSNumber *completedValue = attributes[@"completed"];
    if (completedValue) {
        self.activityValue = [self checkIfNull:completedValue];
    }
}

- (id)checkIfNull:(id)value {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return value;
}
@end
