//
//  EntitiesFetcher.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 12/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "EntitiesFetcher.h"

static NSString *const GetProfileUserWithLoginId = @"getProfileUserWithLoginId";
static NSString *const GetUserWithEmailId = @"getUserWithEmailId";

static NSString *const GetChallengeWithChallengeId = @"getChallengeWithChallengeId";
static NSString *const GetLocalChallengeWithChallengeId = @"getLocalChallengeWithChallengeId";

static NSString *const GetAllChallenges = @"getAllChallenges";
static NSString *const GetAllLocalChallenges = @"getAllLocalChallenges";
static NSString *const GetAllChallengeTypes = @"getAllChallengeTypes";

static NSString *const GetChallengeTypeWithType = @"getChallengeTypeWithType";
static NSString *const GetAllLocalChallengesUnsavedObjects = @"getAllLocalChallengesUnsavedObjects";

static NSString *const GetAllChallengesForLogActivity = @"getAllChallengesForLogActivity";
static NSString *const GetAllCompletedChallenges = @"getAllCompletedChallenges";

static NSString *const GetAllProgressBadges = @"getAllProgressBadges";
static NSString *const GetAllWonBadges = @"getAllWonBadges";
static NSString *const GetBadgeWithBadgeId = @"getBadgeWithBadgeId";

@implementation EntitiesFetcher

- (ProfileUser *)fetchProfileUserWithLoginId:(NSString *)loginId {
    if (!loginId) {
        loginId = @"";
    }
    NSDictionary *variables = [NSDictionary dictionaryWithObject:loginId forKey:@"LOGIN_ID"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetProfileUserWithLoginId substitutionVariables:variables];
    ProfileUser *profileUser = [self.entityManager entityForFetchRequest:request];
    
    return profileUser;
}

- (User *)fetchUserWithEmailId:(NSString *)emailId {
    if (!emailId) {
        emailId = @"";
    }
    NSDictionary *variables = [NSDictionary dictionaryWithObject:emailId forKey:@"EMAIL_ID"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetUserWithEmailId substitutionVariables:variables];
    User *user = [self.entityManager entityForFetchRequest:request];
    
    return user;
}

- (Challenge *)fetchChallengeWithChallengeId:(NSNumber *)challengeId {
    if (!challengeId) {
        return nil;
    }
    NSDictionary *variables = [NSDictionary dictionaryWithObject:challengeId forKey:@"CHALLENGE_ID"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetChallengeWithChallengeId substitutionVariables:variables];
    Challenge *challenge = [self.entityManager entityForFetchRequest:request];
    
    return challenge;
}

- (LocalChallenge *)fetchLocalChallengeWithChallengeId:(NSNumber *)challengeId {
    if (!challengeId) {
        return nil;
    }
    NSDictionary *variables = [NSDictionary dictionaryWithObject:challengeId forKey:@"CHALLENGE_ID"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetLocalChallengeWithChallengeId substitutionVariables:variables];
    LocalChallenge *challenge = [self.entityManager entityForFetchRequest:request];
    
    return challenge;
}

- (NSFetchedResultsController *)getChallengeFetchResultController {
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllChallenges];
//    [request setSortDescriptorWithKey:@"startDate" ascending:NO];
    [request addSortDescriptorWithKey:@"sectionIdentifierForChallenge" ascending:NO];
    [request addSortDescriptorWithKey:@"challengeName" ascending:YES];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:@"uniqueSectionIdentifierForChallenge"];
    return fetchedResultsController;
}

- (NSFetchedResultsController *)getLocalChallengeFetchResultController {
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllLocalChallenges];
//    [request addSortDescriptorWithKey:@"startDate" ascending:NO];
    [request addSortDescriptorWithKey:@"sectionIdentifierForChallenge" ascending:YES];
    [request addSortDescriptorWithKey:@"challengeName" ascending:YES];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:@"uniqueSectionIdentifierForChallenge"];
    return fetchedResultsController;
}

- (ChallengeType *)fetchChallengeTypeWithType:(NSNumber *)challengeType {
    if (!challengeType) {
        return nil;
    }
    NSDictionary *variables = [NSDictionary dictionaryWithObject:challengeType forKey:@"CHALLENGE_TYPE"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetChallengeTypeWithType substitutionVariables:variables];
    ChallengeType *challenge = [self.entityManager entityForFetchRequest:request];
    
    return challenge;
}

- (NSFetchedResultsController *)getChallengeTypeFetchResultController {
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllChallengeTypes];
    [request setSortDescriptorWithKey:@"challengeType" ascending:YES];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request];
    return fetchedResultsController;
}

- (void)deleteLocalChallengesWithChallengeIdZero {
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllLocalChallengesUnsavedObjects];
    [request setSortDescriptorWithKey:@"startDate" ascending:YES];
    
    NSArray *entities = [self.entityManager entitiesForFetchRequest:request];
    [self.entityManager deleteEntities:entities];
    [self.entityManager save:nil];
}

- (NSFetchedResultsController *)getLogActivityChallengeFetchResultController {
    NSDictionary *variables = [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"END_DATE"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllChallengesForLogActivity substitutionVariables:variables];
    [request addSortDescriptorWithKey:@"challengeName" ascending:YES];
    [request addSortDescriptorWithKey:@"endDate" ascending:YES];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request];
    return fetchedResultsController;
}

- (NSFetchedResultsController *)getCompletedChallengeFetchResultController {
    NSDictionary *variables = [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"END_DATE"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllCompletedChallenges substitutionVariables:variables];
    [request addSortDescriptorWithKey:@"challengeName" ascending:YES];
    [request addSortDescriptorWithKey:@"endDate" ascending:NO];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request];
    return fetchedResultsController;
}

- (BOOL)isChallengesPresent {
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllChallenges];
    [request setSortDescriptorWithKey:@"startDate" ascending:NO];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request];
    if ([fetchedResultsController fetchedObjects].count > 0) {
        return YES;
    }
    return NO;
}

- (NSFetchedResultsController *)getProgressBadgesFetchResultController {
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllProgressBadges];
    [request addSortDescriptorWithKey:@"badgeName" ascending:YES];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request];
    return fetchedResultsController;
}

- (NSFetchedResultsController *)getWonBadgesFetchResultController {
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetAllWonBadges];
    [request addSortDescriptorWithKey:@"badgeName" ascending:YES];
    
    NSFetchedResultsController *fetchedResultsController = [self.entityManager fetchedResultsControllerWithFetchRequest:request];
    return fetchedResultsController;
}

- (Badge *)fetchBadgeWithBadgeId:(NSNumber *)badgeId {
    if (!badgeId) {
        return nil;
    }
    NSDictionary *variables = [NSDictionary dictionaryWithObject:badgeId forKey:@"BADGE_ID"];
    NSFetchRequest *request = [self.entityManager fetchRequestFromTemplateWithName:GetBadgeWithBadgeId substitutionVariables:variables];
    Badge *badge = [self.entityManager entityForFetchRequest:request];
    
    return badge;
}
@end
