//
//  SGTEntityFetcher.h
//  Synchronicity
//
//  Created by Greg Macko on 6/5/12.
//  Copyright (c) 2012 Sogeti USA, LLC. All rights reserved.
//

#import "SGTEntityKit.h"

@class SGTEntityManager;


@interface SGTEntityFetcher : NSObject

@property (nonatomic, strong) SGTEntityManager* entityManager;

- (id)initWithEntityManager:(SGTEntityManager*)entityManager;

@end
