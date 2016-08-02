//
//  LogoutService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 06/04/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LogoutSuccessCompletionBlock) (BOOL isUpdate, NSString *statusMessage);
typedef void (^LogoutFailureCompletionBlock) (NSError *error);

@interface LogoutService : NSObject

- (void)logoutUser:(LogoutSuccessCompletionBlock)success failure:(LogoutFailureCompletionBlock)failure;
@end
