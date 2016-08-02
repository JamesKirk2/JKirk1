//
//  SharedSessionManager.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "SharedSessionManager.h"

@implementation SharedSessionManager

+(SharedSessionManager *)sharedInstance {
    static SharedSessionManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _sharedInstance = [[SharedSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]]; });
    return _sharedInstance;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if(!self) {
        return nil;
    }
    
//    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//    self.securityPolicy.allowInvalidCertificates = YES;
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    // Cannot use default AFJSONResponseSerializer here as we cannot have different per request
    self.responseSerializer =  [AFHTTPResponseSerializer serializer];
    
    return self;
}

-(void)cancelAllRequests {
    for(NSURLSessionTask *task in self.tasks) {
        [task cancel];
    }
}

-(void)cancelAllRequestsOfType:(Class)requestClass {
    for(NSURLSessionTask *task in self.tasks) {
        if([task isKindOfClass:requestClass])
            [task cancel];
    }
}
@end
