//
//  SharedSessionManager.h
//  CapFitClub
//
//  Created by Sumit Sancheti on 11/02/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

@interface SharedSessionManager : AFHTTPSessionManager

+(SharedSessionManager *)sharedInstance;

-(void)cancelAllRequests;
-(void)cancelAllRequestsOfType:(Class)requestClass;
@end
