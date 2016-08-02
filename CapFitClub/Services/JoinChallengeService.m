//
//  JoinChallengeService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 31/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "JoinChallengeService.h"
#import "SharedSessionManager.h"
#import "EntitiesFetcher.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface JoinChallengeService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation JoinChallengeService

- (id)initWithChallengeId:(NSNumber *)challengeId andUserId:(NSNumber *)userId {
    NSDictionary *parameters = @{@"challengeId":challengeId, @"userId":userId};
    if((self = [super init])) {
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"fit_club/joinchallenge" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)joinChallengeForUser:(JoinChallengesSuccessCompletionBlock)success failure:(JoinChallengesFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"joinchallenges" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&fileError];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&fileError];
            NSNumber *challengeId = JSON[@"challengeId"];
//            NSNumber *userId = JSON[@"userId"];
            NSString *statusMessage = JSON[@"status"];
            
            BOOL isUpdated = [self updateChallengeWithChallengeId:challengeId];
            if (challengeId) {
                success(challengeId, statusMessage);
            } else {
                error = [NSError errorWithDomain:@"Join Challenge Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:statusMessage}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (BOOL)updateChallengeWithChallengeId:(NSNumber *)challengeId {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    
    LocalChallenge *localChallenge = [entityFetcher fetchLocalChallengeWithChallengeId:challengeId];
    if (!localChallenge) {
        return NO;
    }
    
    BOOL isCreated = [self createChallengeFromLocalChallenge:localChallenge];
    return isCreated;
}

- (BOOL)createChallengeFromLocalChallenge:(LocalChallenge *)localChallenge {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    
    Challenge *challenge = [entityFetcher fetchChallengeWithChallengeId:[localChallenge challengeId]];
    if (!challenge) {
        challenge = [self.entityManager insertEntityWithName:NSStringFromClass([Challenge class])];
    }
    [challenge setAttributesFromLocalChallenge:localChallenge];
    
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    NSMutableOrderedSet *usersArray = [[NSMutableOrderedSet alloc] initWithOrderedSet:[challenge users]];
    User *user = [self.entityManager insertEntityWithName:NSStringFromClass([User class])];
    [user setattributesFromProfileUser:profileUser];
    
    [usersArray addObject:user];
    [challenge setUsers:usersArray];
    
    [self.entityManager deleteEntity:localChallenge];
    
    NSError *error;
    return [self.entityManager save:&error];
}
@end
