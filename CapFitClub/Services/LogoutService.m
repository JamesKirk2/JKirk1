//
//  LogoutService.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 06/04/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "LogoutService.h"
#import "SharedSessionManager.h"
#import "AFHTTPRequestSerializer+Headers.h"

@interface LogoutService()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, strong) SGTEntityManager *entityManager;
@end

@implementation LogoutService

- (id)init {
    if((self = [super init])) {
        self.request = [[SharedSessionManager sharedInstance].requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"fit_club/getChallenge/user/logout" relativeToURL:[SharedSessionManager sharedInstance].baseURL] absoluteString] parameters:nil error:nil];
        [[SharedSessionManager sharedInstance].requestSerializer addTokenAndCookieHeader];
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    return self;
}

- (void)logoutUser:(LogoutSuccessCompletionBlock)success failure:(LogoutFailureCompletionBlock)failure {
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
//            NSString *message = JSON[@"message"];
            if (JSON) {
                success(YES, @"You have been successfully logged off.");
            }
        }
        else {
            failure(error);
        }
    }];
    [_dataTask resume];
}
@end
