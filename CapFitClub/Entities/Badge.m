//
//  Badge.m
//  
//
//  Created by Sumit Sancheti on 04/02/16.
//
//

#import "Badge.h"

@implementation Badge

// Insert code here to add functionality to your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes forBadgeType:(NSString *)badgeType {
    self.badgeId = attributes[@"badge_id"];
    self.badgeName = attributes[@"badge_name"];
    self.badgeImageURL = attributes[@"badge_image_url"];
    self.badgeGoal = attributes[@"badge_goal"];
    self.badgeCompletedValue = attributes[@"badge_completed_value"];
    
    if ([self.badgeCompletedValue longLongValue] >= [self.badgeGoal longLongValue]) {
        self.isCompleted = [NSNumber numberWithBool:YES];
    } else {
        self.isCompleted = [NSNumber numberWithBool:NO];
    }
    if ([[badgeType lowercaseString] isEqualToString:@"loggedbadge"]) {
        self.badgeType = [NSNumber numberWithInt:LOGGED_BADGE];
    } else if ([[badgeType lowercaseString] isEqualToString:@"activitybadges"]) {
        self.badgeType = [NSNumber numberWithInt:ACTIVITY_BADGE];
    } else if ([[badgeType lowercaseString] isEqualToString:@"challengebadges"]) {
        self.badgeType = [NSNumber numberWithInt:CHALLENGE_BADGE];
    } else if ([[badgeType lowercaseString] isEqualToString:@"invitedfriendbages"]) {
        self.badgeType = [NSNumber numberWithInt:INVITED_USERS_BADGE];
    }
    self.badgeDescription = attributes[@"badge_description"];
    self.badgeGoalUnit = attributes[@"badge_unit"];
    self.challengeId = attributes[@"challenge_id"];
}
@end
