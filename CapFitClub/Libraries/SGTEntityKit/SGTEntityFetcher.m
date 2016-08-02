//
//  SGTEntityFetcher.m
//  Synchronicity
//
//  Created by Greg Macko on 6/5/12.
//  Copyright (c) 2012 Sogeti USA, LLC. All rights reserved.
//

#import "SGTEntityFetcher.h"


@implementation SGTEntityFetcher

// MARK: - NSObject

- (id)init {
    self = [super init];
    if (self) {
        self.entityManager = [[SGTEntityManager alloc] init];
    }
    
    return self;
}


// MARK: - SGTEntityFetcher

- (id)initWithEntityManager:(SGTEntityManager *)anEntityManager {
    self = [super init];
    if (self) {
        self.entityManager = anEntityManager;
    }
    
    return self;
}

@end
