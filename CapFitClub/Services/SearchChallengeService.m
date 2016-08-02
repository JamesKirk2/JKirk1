//
//  SearchChallengeService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 10/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SearchChallengeService.h"
#import "SharedSessionManager.h"
#import "EntitiesFetcher.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface SearchChallengeService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation SearchChallengeService

- (id)initWithUserId:(NSNumber *)userId {
    if((self = [super init])) {
        NSDictionary *parameters = @{@"userId":userId};
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"fit_club/searchchallenge/search" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (id)initWithChallengeId:(NSString *)challengeId {
    if((self = [super init])) {
        NSDictionary *parameters = @{@"cid":challengeId};
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"fit_club/getchallenge/cid" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)searchChallenges:(SearchChallengesSuccessCompletionBlock)success failure:(SearchChallengesFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"joinchallenges" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&fileError];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JOIN_CHALLENGE_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            NSArray *challengesArray = JSON[@"challengeList"];
            if (challengesArray) {
                [challengesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *challengeDict = (NSDictionary *)obj;
                    [self createLocalChallengeWithDetails:challengeDict];
                }];
                
                if ([self.entityManager save:&error]) {
                    success(YES);
                } else {
#if DEBUG
                    NSLog(@"%@", [error description]);
#endif
                    failure(error);
                }
            } else {
                NSString *statusMessage = JSON[@"status"];
                error = [NSError errorWithDomain:@"Search Challenge Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:statusMessage}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (LocalChallenge *)createLocalChallengeWithDetails:(NSDictionary *)challengeDict {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    NSNumber *challengeId = challengeDict[@"challengeId"];
    
    LocalChallenge *challenge = [entityFetcher fetchLocalChallengeWithChallengeId:challengeId];
    if (!challenge) {
        challenge = [self.entityManager insertEntityWithName:NSStringFromClass([LocalChallenge class])];
    }
    if (challengeDict) {
        [challenge setAttributes:challengeDict];
    }
    
    NSMutableOrderedSet *usersArray = [[NSMutableOrderedSet alloc] init];
    NSArray *users = challengeDict[@"users"];
    if ([users isKindOfClass:[NSArray class]]) {
        [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *userDict = (NSDictionary *)obj;
            User *user = [self.entityManager insertEntityWithName:NSStringFromClass([User class])];
            [user setAttributes:userDict];
            [usersArray addObject:user];
        }];
        
        [challenge setUsers:usersArray];
    }
    
    NSMutableOrderedSet *activityArray = [[NSMutableOrderedSet alloc] init];
    id activities = challengeDict[@"activities"];
    if ([activities isKindOfClass:[NSArray class]]) {
        [activities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *activityDict = (NSDictionary *)obj;
            Activity *activity = [self.entityManager insertEntityWithName:NSStringFromClass([Activity class])];
            [activity setAttributes:activityDict];
            [activity setChallengeId:challengeId];
            [self updateUserCompletionFromActivity:activity forChallenge:challenge];
            [activityArray addObject:activity];
        }];
        
        [challenge setActivities:activityArray];
    }
    
    return challenge;
}

- (void)updateUserCompletionFromActivity:(Activity *)activity forChallenge:(LocalChallenge *)challenge {
    User *user = [self getUserWithUserId:[activity userId] forChallenge:challenge];
    
    NSNumber *userCompletedValue = [user completedQuantity];
    NSNumber *activityCompletedValue = [activity activityValue];
    
    [user setCompletedQuantity:[NSNumber numberWithLongLong:([userCompletedValue longLongValue] + [activityCompletedValue longLongValue])]];
    if (([userCompletedValue longLongValue] + [activityCompletedValue longLongValue]) > [[challenge challengeGoal] longLongValue]) {
        [challenge setIsCompleted:[NSNumber numberWithBool:YES]];
//        [challenge setSectionIdentifierForChallenge:@"Completed Challenges"];
    }
}

- (User *)getUserWithUserId:(NSNumber *)userId forChallenge:(LocalChallenge *)challenge {
    NSArray *array = [[challenge users] array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.userId == %@", userId];
    NSArray *usersArray = [array filteredArrayUsingPredicate:predicate];
    
    if ([usersArray count] > 0) {
        return (usersArray[0]);
    }
    return nil;
}
@end
