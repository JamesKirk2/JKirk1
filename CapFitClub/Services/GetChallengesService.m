//
//  GetChallengesService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 25/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "GetChallengesService.h"
#import "SharedSessionManager.h"
#import "Challenge.h"
#import "User.h"
#import "EntitiesFetcher.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface GetChallengesService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation GetChallengesService

- (id)initWithUserId:(NSNumber *)userId {
    if((self = [super init])) {
        NSString *absoluteURL = [NSString stringWithFormat:@"fit_club/getchallenges/%lld", [userId longLongValue]];
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:absoluteURL relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:nil error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)getAllChallenges:(ChallengesSuccessCompletionBlock)success failure:(ChallengesFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"challenges" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&fileError];
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
                    [self createChallengeWithDetails:challengeDict];
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
                success(NO);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (void)createChallengeWithDetails:(NSDictionary *)challengeDict {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    NSNumber *challengeId = challengeDict[@"challengeId"];
    
    Challenge *challenge = [entityFetcher fetchChallengeWithChallengeId:challengeId];
    if (!challenge) {
        challenge = [self.entityManager insertEntityWithName:NSStringFromClass([Challenge class])];
    }
    if (challengeDict) {
        [challenge setAttributes:challengeDict];
    }
    
    NSMutableOrderedSet *usersArray = [[NSMutableOrderedSet alloc] init];
    id users = challengeDict[@"users"];
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
}

- (void)updateUserCompletionFromActivity:(Activity *)activity forChallenge:(Challenge *)challenge {
    User *user = [self getUserWithUserId:[activity userId] forChallenge:challenge];
    
    NSNumber *userCompletedValue = [user completedQuantity];
    NSNumber *activityCompletedValue = [activity activityValue];
    
    [user setCompletedQuantity:[NSNumber numberWithLongLong:([userCompletedValue longLongValue] + [activityCompletedValue longLongValue])]];
    
    NSNumber *challengeCompletedValue = [challenge completedQuantity];
    [challenge setCompletedQuantity:[NSNumber numberWithLongLong:([challengeCompletedValue longLongValue] + [activityCompletedValue longLongValue])]];
    
    if (([challengeCompletedValue longLongValue] + [activityCompletedValue longLongValue]) > [[challenge challengeGoal] longLongValue]) {
        [challenge setIsCompleted:[NSNumber numberWithBool:YES]];
        [challenge setSectionIdentifierForChallenge:@"Completed Challenges"];
    }
}

- (User *)getUserWithUserId:(NSNumber *)userId forChallenge:(Challenge *)challenge {
    NSArray *array = [[challenge users] array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.userId == %@", userId];
    NSArray *usersArray = [array filteredArrayUsingPredicate:predicate];
    
    if ([usersArray count] > 0) {
        return (usersArray[0]);
    }
    return nil;
}
@end
