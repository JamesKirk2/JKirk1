//
//  UserProfileService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 12/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileUser.h"

typedef void (^UserProfileSuccessCompletionBlock) (ProfileUser *profileUser, NSError *error);
typedef void (^UserProfileFailureCompletionBlock) (NSError *error);

@interface UserProfileService : NSObject

- (id)initWithUserId:(NSNumber *)userId;
- (id)initWithUserId:(NSNumber *)userId andParameters:(NSDictionary *)parameters;
- (id)initWithParameters:(NSDictionary *)parameters;
- (void)getUserProfileForUser:(UserProfileSuccessCompletionBlock)success failure:(UserProfileFailureCompletionBlock)failure;
- (void)saveUserProfileForUser:(UserProfileSuccessCompletionBlock)success failure:(UserProfileFailureCompletionBlock)failure;
- (void)saveUserProfileImage:(UserProfileSuccessCompletionBlock)success failure:(UserProfileFailureCompletionBlock)failure;
@end
