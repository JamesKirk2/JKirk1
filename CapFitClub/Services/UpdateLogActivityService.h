//
//  UpdateLogActivityService.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"

typedef void (^UpdateActivitySuccessCompletionBlock) (BOOL isUpdate, NSString *statusMessage);
typedef void (^UpdateActivityFailureCompletionBlock) (NSError *error);

@interface UpdateLogActivityService : NSObject

- (id)initWithParameters:(NSDictionary *)parameters;
- (void)updateActivityForChallenge:(UpdateActivitySuccessCompletionBlock)success failure:(UpdateActivityFailureCompletionBlock)failure;
@end
