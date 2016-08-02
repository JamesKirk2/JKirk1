//
//  CreateUpdateChallengeService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 21/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CreateUpdateChallengesSuccessCompletionBlock) (NSNumber *challengeId);
typedef void (^CreateUpdateChallengesFailureCompletionBlock) (NSError *error);

@interface CreateUpdateChallengeService : NSObject

- (id)initWithParameters:(NSDictionary *)parameters forURL:(NSString *)url;
- (void)createUpdateChallenge:(CreateUpdateChallengesSuccessCompletionBlock)success failure:(CreateUpdateChallengesFailureCompletionBlock)failure;
@end
