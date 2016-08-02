//
//  MainChallenge+CoreDataProperties.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 12/05/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MainChallenge.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainChallenge (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *adminId;
@property (nullable, nonatomic, retain) NSString *challengeDescription;
@property (nullable, nonatomic, retain) NSNumber *challengeGoal;
@property (nullable, nonatomic, retain) NSString *challengeGoalUnit;
@property (nullable, nonatomic, retain) NSNumber *challengeId;
@property (nullable, nonatomic, retain) NSString *challengeName;
@property (nullable, nonatomic, retain) NSNumber *challengeType;
@property (nullable, nonatomic, retain) NSNumber *completedQuantity;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSNumber *isSearchable;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSNumber *isCompleted;
@property (nullable, nonatomic, retain) NSOrderedSet<Activity *> *activities;
@property (nullable, nonatomic, retain) NSOrderedSet<User *> *users;

@end

@interface MainChallenge (CoreDataGeneratedAccessors)

- (void)insertObject:(Activity *)value inActivitiesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromActivitiesAtIndex:(NSUInteger)idx;
- (void)insertActivities:(NSArray<Activity *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeActivitiesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInActivitiesAtIndex:(NSUInteger)idx withObject:(Activity *)value;
- (void)replaceActivitiesAtIndexes:(NSIndexSet *)indexes withActivities:(NSArray<Activity *> *)values;
- (void)addActivitiesObject:(Activity *)value;
- (void)removeActivitiesObject:(Activity *)value;
- (void)addActivities:(NSOrderedSet<Activity *> *)values;
- (void)removeActivities:(NSOrderedSet<Activity *> *)values;

- (void)insertObject:(User *)value inUsersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUsersAtIndex:(NSUInteger)idx;
- (void)insertUsers:(NSArray<User *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUsersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUsersAtIndex:(NSUInteger)idx withObject:(User *)value;
- (void)replaceUsersAtIndexes:(NSIndexSet *)indexes withUsers:(NSArray<User *> *)values;
- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSOrderedSet<User *> *)values;
- (void)removeUsers:(NSOrderedSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
