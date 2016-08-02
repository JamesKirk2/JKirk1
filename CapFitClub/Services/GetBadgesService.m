//
//  GetBadgesService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 12/04/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "GetBadgesService.h"
#import "SharedSessionManager.h"
#import "AFHTTPRequestSerializer+Headers.h"
#import "EntitiesFetcher.h"

@interface GetBadgesService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation GetBadgesService

- (id)initWithUserId:(NSNumber *)userId {
    if((self = [super init])) {
        NSDictionary *parameters = @{@"userId":userId};
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"fit_club/getbadges/badge" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)getBadges:(BadgesSuccessCompletionBlock)success failure:(BadgesFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        error = nil;
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"badges" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *badgeDict = JSON[@"Badgedetails"];
            if (badgeDict) {
                NSArray *allKeys = [badgeDict allKeys];
                for (int i = 0; i < [allKeys count]; i++) {
                    NSString *badgeType = (NSString *)allKeys[i];
                    id badgeArray = badgeDict[badgeType];
                    if ([badgeArray isKindOfClass:[NSArray class]]) {
                        for (int j = 0; j < [badgeArray count]; j++) {
                            NSDictionary *badgeDict = (NSDictionary *)badgeArray[j];
                            [self createAndAddBadge:badgeDict forBadgeType:badgeType];
                        }
                    }
                }
                
                if ([self.entityManager save:&error]) {
                    success(YES, @"Badges successfully retrieved.");
                } else {
#if DEBUG
                    NSLog(@"%@", [error description]);
#endif
                    failure(error);
                }
            } else {
                NSString *message = @"No badges found.";
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

- (void)createAndAddBadge:(NSDictionary *)badgeDict forBadgeType:(NSString *)badgeType {
    EntitiesFetcher *entityFetcher = [[EntitiesFetcher alloc] initWithEntityManager:self.entityManager];
    NSNumber *badgeId = badgeDict[@"badge_id"];
    
    if (badgeId) {
        Badge *badge = [entityFetcher fetchBadgeWithBadgeId:badgeId];
        if (!badge) {
            badge = [self.entityManager insertEntityWithName:NSStringFromClass([Badge class])];
        }
        if (badgeDict) {
            [badge setAttributes:badgeDict forBadgeType:badgeType];
        }
        NSLog(@"%@", badge);
    }
}
@end
