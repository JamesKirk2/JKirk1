//
//  SearchChallengeService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SearchChallengesSuccessCompletionBlock) (BOOL isChallengePresent);
typedef void (^SearchChallengesFailureCompletionBlock) (NSError *error);

@interface SearchChallengeService : NSObject

- (id)initWithUserId:(NSNumber *)userId;
- (id)initWithChallengeId:(NSString *)challengeId;
- (void)searchChallenges:(SearchChallengesSuccessCompletionBlock)success failure:(SearchChallengesFailureCompletionBlock)failure;
@end
