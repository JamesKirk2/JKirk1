//
//  LoginService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileUser.h"

typedef void (^LoginServiceSuccessCompletionBlock) (ProfileUser *profileUser);
typedef void (^LoginServiceFailureCompletionBlock) (NSError *error);

@interface LoginService : NSObject

- (id)initWithParameters:(NSDictionary *)parameters;
- (void)getAppAuthentication:(LoginServiceSuccessCompletionBlock)success failure:(LoginServiceFailureCompletionBlock)failure;
@end
