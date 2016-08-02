//
//  LeaveDeleteChallengeService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 31/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LeaveDeleteChallengeService.h"
#import "SharedSessionManager.h"
#import "EntitiesFetcher.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface LeaveDeleteChallengeService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation LeaveDeleteChallengeService

- (id)initWithChallengeId:(NSNumber *)challengeId andUserId:(NSNumber *)userId forURL:(NSString *)url {
    NSDictionary *parameters = @{@"challengeId":challengeId, @"userId":userId};
    if((self = [super init])) {
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)leaveChallenge:(RemoveChallengesSuccessCompletionBlock)success failure:(RemoveChallengesFailureCompletionBlock)failure {
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
            NSString *status = JSON[@"status"];
            NSString *statusMessage = JSON[@"message"];
            
            if (challengeId && [[status lowercaseString] isEqualToString:@"success"]) {
                BOOL isUpdated = [self removeChallengeWithChallengeId:challengeId];
                if (isUpdated) {
                    success(isUpdated, statusMessage);
                } else {
                    success(isUpdated, @"Challenge cannot be removed from local storage");
                }
            }
             else {
                error = [NSError errorWithDomain:@"Leave Challenge Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:statusMessage}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (void)deleteChallenge:(RemoveChallengesSuccessCompletionBlock)success failure:(RemoveChallengesFailureCompletionBlock)failure {
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
            NSNumber *challengeId = JSON[@"challengeId"];
            NSString *status = JSON[@"status"];
            NSString *statusMessage = JSON[@"message"];
            
            if (challengeId && [[status lowercaseString] isEqualToString:@"success"]) {
                BOOL isUpdated = [self removeChallengeWithChallengeId:challengeId];
                if (isUpdated) {
                    success(isUpdated, statusMessage);
                } else {
                    success(isUpdated, @"Challenge cannot be removed from local storage");
                }
            } else {
                error = [NSError errorWithDomain:@"Delete Challenge Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:statusMessage}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (BOOL)removeChallengeWithChallengeId:(NSNumber *)challengeId {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    
    Challenge *challenge = [entityFetcher fetchChallengeWithChallengeId:challengeId];
    if (!challenge) {
        return NO;
    }
    
    NSError *error;
    [self.entityManager deleteEntity:challenge];
    return [self.entityManager save:&error];
}
@end
