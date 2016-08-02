//
//  JoinChallengeService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 31/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JoinChallengesSuccessCompletionBlock) (NSNumber *challengeId, NSString *message);
typedef void (^JoinChallengesFailureCompletionBlock) (NSError *error);

@interface JoinChallengeService : NSObject

- (id)initWithChallengeId:(NSNumber *)challengeId andUserId:(NSNumber *)userId;
- (void)joinChallengeForUser:(JoinChallengesSuccessCompletionBlock)success failure:(JoinChallengesFailureCompletionBlock)failure;
@end
