//
//  GetChallengesService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 25/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ChallengesSuccessCompletionBlock) (BOOL isChallengePresent);
typedef void (^ChallengesFailureCompletionBlock) (NSError *error);

@interface GetChallengesService : NSObject

- (id)initWithUserId:(NSNumber *)userId;
- (void)getAllChallenges:(ChallengesSuccessCompletionBlock)success failure:(ChallengesFailureCompletionBlock)failure;
@end
