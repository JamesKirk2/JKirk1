//
//  ChallengeType.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 16/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ChallengeType.h"

@implementation ChallengeType

// Insert code here to add functionality to your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes {
    self.challengeType = attributes[@"type"];
    self.challengeName = attributes[@"name"];
}
@end
