//
//  NSFetchRequest+SGTEntityKit.m
//  SGTEntityKit
//
//  Created by Greg Macko on 4/11/12.
//  Copyright (c) 2012 Sogeti USA, LLC. All rights reserved.
//

#import "NSFetchRequest+SGTEntityKit.h"


@implementation NSFetchRequest (SGTEntityKit)

- (void)setSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    self.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
}

- (void)addSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    NSMutableArray* currentSortDescriptors = self.sortDescriptors.mutableCopy;
    if (currentSortDescriptors) {
        [currentSortDescriptors addObject:sortDescriptor];
    } else {
        currentSortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    }
    self.sortDescriptors = [NSArray arrayWithArray:currentSortDescriptors];
}

@end
