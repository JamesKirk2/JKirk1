//
//  NSFetchRequest+SGTEntityKit.h
//  SGTEntityKit
//
//  Created by Greg Macko on 4/11/12.
//  Copyright (c) 2012 Sogeti USA, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSFetchRequest (SGTEntityKit)

- (void)setSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending;
- (void)addSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending;

@end
