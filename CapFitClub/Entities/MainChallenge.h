//
//  MainChallenge.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, User;

NS_ASSUME_NONNULL_BEGIN

@interface MainChallenge : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)setAttributes:(NSDictionary *)challengeDict;
@end

NS_ASSUME_NONNULL_END

#import "MainChallenge+CoreDataProperties.h"
