//
//  LeaveDeleteChallengeService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 31/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RemoveChallengesSuccessCompletionBlock) (BOOL isUpdated, NSString *message);
typedef void (^RemoveChallengesFailureCompletionBlock) (NSError *error);

@interface LeaveDeleteChallengeService : NSObject

- (id)initWithChallengeId:(NSNumber *)challengeId andUserId:(NSNumber *)userId forURL:(NSString *)url;
- (void)leaveChallenge:(RemoveChallengesSuccessCompletionBlock)success failure:(RemoveChallengesFailureCompletionBlock)failure;
- (void)deleteChallenge:(RemoveChallengesSuccessCompletionBlock)success failure:(RemoveChallengesFailureCompletionBlock)failure;
@end
