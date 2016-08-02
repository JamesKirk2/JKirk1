//
//  ChallengeType+CoreDataProperties.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 16/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChallengeType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChallengeType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *challengeType;
@property (nullable, nonatomic, retain) NSString *challengeName;

@end

NS_ASSUME_NONNULL_END
