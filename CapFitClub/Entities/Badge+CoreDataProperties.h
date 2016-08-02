//
//  Badge+CoreDataProperties.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/05/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Badge.h"

NS_ASSUME_NONNULL_BEGIN

@interface Badge (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *badgeCompletedValue;
@property (nullable, nonatomic, retain) NSString *badgeDescription;
@property (nullable, nonatomic, retain) NSNumber *badgeGoal;
@property (nullable, nonatomic, retain) NSString *badgeGoalUnit;
@property (nullable, nonatomic, retain) NSNumber *badgeId;
@property (nullable, nonatomic, retain) NSString *badgeImageURL;
@property (nullable, nonatomic, retain) NSString *badgeName;
@property (nullable, nonatomic, retain) NSNumber *badgeType;
@property (nullable, nonatomic, retain) NSNumber *challengeId;
@property (nullable, nonatomic, retain) NSNumber *isCompleted;

@end

NS_ASSUME_NONNULL_END
