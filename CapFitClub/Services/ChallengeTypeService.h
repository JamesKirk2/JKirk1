//
//  ChallengeTypeService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 16/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ChallengeTypeSuccessCompletionBlock) (NSError *error);
typedef void (^ChallengeTypeFailureCompletionBlock) (NSError *error);

@interface ChallengeTypeService : NSObject

- (void)getAllChallengeTypes:(ChallengeTypeSuccessCompletionBlock)success failure:(ChallengeTypeFailureCompletionBlock)failure;
@end
