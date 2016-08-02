//
//  UserProfileService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 12/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "UserProfileService.h"
#import "SharedSessionManager.h"
#import "EntitiesFetcher.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface UserProfileService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
//@property (nonatomic, strong) NSString *profileImageName;
@end

@implementation UserProfileService

- (id)initWithUserId:(NSNumber *)userId {
    if((self = [super init])) {
        NSString *absoluteURL = [NSString stringWithFormat:@"fit_club/user/%@", userId];
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:absoluteURL relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:nil error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (id)initWithUserId:(NSNumber *)userId andParameters:(NSDictionary *)parameters {
    if((self = [super init])) {
        NSString *absoluteURL = [NSString stringWithFormat:@"fit_club/user/%@", userId];
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"PUT" URLString:[[NSURL URLWithString:absoluteURL relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (id)initWithParameters:(NSDictionary *)parameters {
    if((self = [super init])) {
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"fit_club/file" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:parameters error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)getUserProfileForUser:(UserProfileSuccessCompletionBlock)success failure:(UserProfileFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {

//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"saveuserprofile" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&fileError];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&fileError];
            NSDictionary *userProfileDict = JSON;
            if (userProfileDict) {
                ProfileUser *profileUser = [self saveProfileUserWithProfile:userProfileDict];
                success(profileUser, nil);
            } else {
                NSString *message = JSON[@"message"];
                if (message) {
                    error = [NSError errorWithDomain:@"User Profile Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:message}];
                }
                failure(error);
            }
        }
        else {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (void)saveUserProfileForUser:(UserProfileSuccessCompletionBlock)success failure:(UserProfileFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"saveuserprofile" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&fileError];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *userProfileDict = JSON;
            if (userProfileDict) {
                ProfileUser *user = [self saveProfileUserWithProfile:userProfileDict];
                success(user, nil);
            } else {
                NSString *message = JSON[@"message"];
                if (message) {
                    error = [NSError errorWithDomain:@"User Profile Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:message}];
                }
                failure(error);
            }
        }
        else {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            failure(error);
        }
    }];
    [_dataTask resume];
}

- (ProfileUser *)saveProfileUserWithProfile:(NSDictionary *)userProfileDict {
    
    ProfileUser *profileUser = [CommonFunctions getLoggedInProfileUser:nil];
    if (!profileUser) {
        profileUser = [self.entityManager insertEntityWithName:NSStringFromClass([ProfileUser class])];
    }
    if (userProfileDict) {
        [profileUser setAttributes:userProfileDict];
    }
    
    NSError *error = nil;
    if ([self.entityManager save:&error]) {
        return profileUser;
    }
#if DEBUG
    NSLog(@"Update profile user: %@", [error localizedDescription]);
#endif
    return nil;
}

- (void)saveUserProfileImage:(UserProfileSuccessCompletionBlock)success failure:(UserProfileFailureCompletionBlock)failure {
    self.dataTask = [[SharedSessionManager sharedInstance] dataTaskWithRequest:_request completionHandler:^(NSURLResponse *__unused response, id responseObject, NSError *error) {
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"saveuserprofile" ofType:@"json"];
//        responseObject = [[NSData alloc] initWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&fileError];
        if(!error) {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
            id JSON = [jsonSerializer responseObjectForResponse:response data:responseObject error:nil];
            
//            id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            NSDictionary *userProfileDict = JSON[@"user"];
            if (userProfileDict) {
                ProfileUser *user = [self saveProfileUserWithProfile:userProfileDict];
                success(user, nil);
            } else {
                NSString *message = JSON[@"message"];
                error = [NSError errorWithDomain:@"User Profile Error !" code:404 userInfo:@{NSLocalizedDescriptionKey:message}];
                failure(error);
            }
        }
        else {
#if DEBUG
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@", responseString);
#endif
            failure(error);
        }
    }];
    [_dataTask resume];
}

@end
