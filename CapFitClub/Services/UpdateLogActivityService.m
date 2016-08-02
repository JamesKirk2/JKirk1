//
//  UpdateLogActivityService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 29/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "UpdateLogActivityService.h"
#import "SharedSessionManager.h"
#import "EntitiesFetcher.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface UpdateLogActivityService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation UpdateLogActivityService

- (id)initWithParameters:(NSDictionary *)parameters {
    if((self = [super init])) {
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"fit_club/logactivity" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)updateActivityForChallenge:(UpdateActivitySuccessCompletionBlock)success failure:(UpdateActivityFailureCompletionBlock)failure {
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
            NSDictionary *logActivityDict = JSON[@"Logactivity"];
            NSString *status = JSON[@"status"];
            NSString *message = JSON[@"message"];
            
            if (logActivityDict && [status isEqualToString:@"success"]) {
                BOOL isUpdated = [self updateChallengeWithLogActivity:logActivityDict withMessage:&message];
                if (isUpdated) {
                    success(isUpdated, message);
                } else {
                    error = [NSError errorWithDomain:@"Fit Club !" code:404 userInfo:@{NSLocalizedDescriptionKey:@"Error in saving Log Activity."}];
                    failure(error);
                }
            } else {
                error = [NSError errorWithDomain:@"Fit Club !" code:404 userInfo:@{NSLocalizedDescriptionKey:message}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (BOOL)updateChallengeWithLogActivity:(NSDictionary *)logActivityDict withMessage:(NSString **)messsage{
    NSNumber *challengeId = logActivityDict[@"challengeId"];
    NSNumber *userId = logActivityDict[@"userId"];
    NSNumber *completedValue = logActivityDict[@"completed"];
    
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    
    Challenge *challenge = [entityFetcher fetchChallengeWithChallengeId:challengeId];
    if (!challenge) {
        return NO;
    }
    
    User *user = [self getUserWithUserId:userId forChallenge:challenge];
    NSNumber *completedQuantity = [user completedQuantity];
    [user setCompletedQuantity:[NSNumber numberWithLongLong:([completedQuantity longLongValue] + [completedValue longLongValue])]];
    
    NSNumber *challengeCompletedValue = [challenge completedQuantity];
    [challenge setCompletedQuantity:[NSNumber numberWithLongLong:([challengeCompletedValue longLongValue] + [completedValue longLongValue])]];
    
    if (([challengeCompletedValue longLongValue] + [completedValue longLongValue]) > [[challenge challengeGoal] longLongValue]) {
        [challenge setIsCompleted:[NSNumber numberWithBool:YES]];
        [challenge setSectionIdentifierForChallenge:@"Completed Challenges"];
        *messsage = @"Your challenge has been successfully completed";
    }
    NSMutableOrderedSet *activitiesArray = [[NSMutableOrderedSet alloc] initWithOrderedSet:[challenge activities]];
    Activity *activity = [self.entityManager insertEntityWithName:NSStringFromClass([Activity class])];
    [activity setAttributes:logActivityDict];
    
    [activitiesArray addObject:activity];
    [challenge setActivities:activitiesArray];
    
    NSError *error;
    return [self.entityManager save:&error];
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
