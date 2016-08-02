//
//  EntitiesFetcher.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 12/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SGTEntityFetcher.h"
#import "ProfileUser.h"
#import "User.h"
#import "Challenge.h"
#import "LocalChallenge.h"
#import "ChallengeType.h"
#import "Activity.h"
#import "Badge.h"

@interface EntitiesFetcher : SGTEntityFetcher

- (ProfileUser *)fetchProfileUserWithLoginId:(NSString *)loginId;
- (User *)fetchUserWithEmailId:(NSString *)emailId;

- (Challenge *)fetchChallengeWithChallengeId:(NSNumber *)challengeId;
- (LocalChallenge *)fetchLocalChallengeWithChallengeId:(NSNumber *)challengeId;

- (NSFetchedResultsController *)getChallengeFetchResultController;
- (NSFetchedResultsController *)getLocalChallengeFetchResultController;

- (ChallengeType *)fetchChallengeTypeWithType:(NSNumber *)challengeType;

- (NSFetchedResultsController *)getChallengeTypeFetchResultController;
- (void)deleteLocalChallengesWithChallengeIdZero;

- (NSFetchedResultsController *)getLogActivityChallengeFetchResultController;
- (NSFetchedResultsController *)getCompletedChallengeFetchResultController;

- (BOOL)isChallengesPresent;

- (NSFetchedResultsController *)getProgressBadgesFetchResultController;
- (NSFetchedResultsController *)getWonBadgesFetchResultController;
- (Badge *)fetchBadgeWithBadgeId:(NSNumber *)badgeId;
@end
