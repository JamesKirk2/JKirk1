//
//  ChallengeType.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 16/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChallengeType : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setAttributes:(NSDictionary *)attributes;
@end

NS_ASSUME_NONNULL_END

#import "ChallengeType+CoreDataProperties.h"
