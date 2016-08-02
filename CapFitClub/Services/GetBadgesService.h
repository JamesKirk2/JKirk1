//
//  GetBadgesService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 12/04/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BadgesSuccessCompletionBlock) (BOOL isUpdate, NSString *statusMessage);
typedef void (^BadgesFailureCompletionBlock) (NSError *error);

@interface GetBadgesService : NSObject

- (id)initWithUserId:(NSNumber *)userId;
- (void)getBadges:(BadgesSuccessCompletionBlock)success failure:(BadgesFailureCompletionBlock)failure;
@end
