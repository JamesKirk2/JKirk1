//
//  ChallengeTypeService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 16/03/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "ChallengeTypeService.h"
#import "SharedSessionManager.h"
#import "EntitiesFetcher.h"
#import "ChallengeType.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface ChallengeTypeService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation ChallengeTypeService

- (id)init {
    if((self = [super init])) {
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:@"fit_club/challenge_list" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:nil error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)getAllChallengeTypes:(ChallengeTypeSuccessCompletionBlock)success failure:(ChallengeTypeFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"challengetypelist" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&fileError];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            NSArray *challengeTypeArray = JSON[@"challengeTypeList"];
            
            if (challengeTypeArray) {
                [challengeTypeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *challengeDict = (NSDictionary *)obj;
                    [self createAndAddChallengeType:challengeDict];
                }];
                
                if ([self.entityManager save:&error]) {
                    success(nil);
                } else {
#if DEBUG
                    NSLog(@"%@", [error description]);
#endif
                    failure(error);
                }
            } else {
                error = [NSError errorWithDomain:@"Fit Club !" code:404 userInfo:@{NSLocalizedDescriptionKey:@"Error fetching challenge type list from server. Please contact your administrator."}];
                failure(error);
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (void)createAndAddChallengeType:(NSDictionary *)challengeDict {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    NSNumber *challengeType = challengeDict[@"type"];
    
    ChallengeType *challenge = [entityFetcher fetchChallengeTypeWithType:challengeType];
    if (!challenge) {
        challenge = [self.entityManager insertEntityWithName:NSStringFromClass([ChallengeType class])];
    }
    if (challengeDict) {
        [challenge setAttributes:challengeDict];
    }
}
@end
