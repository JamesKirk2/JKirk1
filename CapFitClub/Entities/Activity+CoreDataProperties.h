//
//  Activity+CoreDataProperties.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 28/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Activity.h"
#import "MainChallenge.h"

NS_ASSUME_NONNULL_BEGIN

@interface Activity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSNumber *challengeId;
@property (nullable, nonatomic, retain) NSDate *activityDate;
@property (nullable, nonatomic, retain) NSNumber *activityValue;
@property (nullable, nonatomic, retain) MainChallenge *challenge;

@end

NS_ASSUME_NONNULL_END
