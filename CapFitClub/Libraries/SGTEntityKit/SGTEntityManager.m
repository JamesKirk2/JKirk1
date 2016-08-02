//
//  SGTEntityManager.m
//  SGTEntityKit
//
//  Created by Greg Macko on 4/11/12.
//  Copyright (c) 2012 Sogeti USA, LLC. All rights reserved.
//

#import "SGTEntityManager.h"


@interface SGTEntityManager()

@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) NSManagedObjectModel* model;

@end


@implementation SGTEntityManager

static NSManagedObjectContext * mainContext;

+ (void)initializeWithModelURL:(NSURL*)modelURL storeURL:(NSURL*)storeURL {
    NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString* storeType = storeURL == nil ? NSInMemoryStoreType : NSSQLiteStoreType;
    NSError* error;
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                     NSInferMappingModelAutomaticallyOption: @YES};
    if (![coordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [coordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:nil];
    }
    mainContext = [[NSManagedObjectContext alloc] init];
    [mainContext setPersistentStoreCoordinator:coordinator];
}


// MARK: - NSObject

- (id)init {
    self = [super init];
    if (self) {
        NSAssert(mainContext != nil, @"Can't create an entity manager without a managedObjectContext");
        if ([NSThread isMainThread]) {
            self.context = mainContext;
            self.model = self.context.persistentStoreCoordinator.managedObjectModel;
        } else {
            self.context = [[NSManagedObjectContext alloc] init];
            self.context.persistentStoreCoordinator = mainContext.persistentStoreCoordinator;
            self.context.propagatesDeletesAtEndOfEvent = mainContext.propagatesDeletesAtEndOfEvent;
            self.context.retainsRegisteredObjects = mainContext.retainsRegisteredObjects;
            self.context.stalenessInterval = mainContext.stalenessInterval;
            self.context.mergePolicy = mainContext.mergePolicy;
            self.model = self.context.persistentStoreCoordinator.managedObjectModel;
        }
    }
    
    return self;
}


// MARK: - SGTEntityManager
// Method added to create local copy of entity
- (id)entityForName:(NSString *)name {
    return [NSEntityDescription entityForName:name inManagedObjectContext:self.context];
}

- (void)insertEntity:(NSManagedObject *)entity {
    [self.context insertObject:entity];
}

- (id)insertEntityWithName:(NSString*)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name 
                                         inManagedObjectContext:self.context];
}

- (void)deleteEntity:(NSManagedObject*)entity {
    [self.context deleteObject:entity];
}

- (void)deleteEntities:(id<NSFastEnumeration>)entities {
    for (NSManagedObject* entity in entities) {
		[self.context deleteObject:entity];
	}
}

- (NSFetchRequest*)fetchRequestFromTemplateWithName:(NSString*)name {
    return [[self.model fetchRequestTemplateForName:name] copy];
}

- (NSFetchRequest*)fetchRequestFromTemplateWithName:(NSString*)name substitutionVariables:(NSDictionary*)variables {
    return [self.model fetchRequestFromTemplateWithName:name substitutionVariables:variables];
    
}

- (NSFetchRequest*)fetchRequestFromTemplateWithName:(NSString*)name variable:(id)variable forKey:(NSString*)key {
    NSDictionary* variables = [NSDictionary dictionaryWithObject:variable forKey:key];
    NSFetchRequest* request = [self.model fetchRequestFromTemplateWithName:name substitutionVariables:variables];
    
    return request;
}

- (NSUInteger)countForFetchRequest:(NSFetchRequest*)request {
    NSError* error;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    if (count == NSNotFound) {
#if DEBUG
        NSLog(@"%s\n%@\n%@", __PRETTY_FUNCTION__, error.localizedDescription, error.userInfo);
#endif
        count = 0;
    }
    
    return count;
}

- (id)entityForFetchRequest:(NSFetchRequest*)request {
    return [[self entitiesForFetchRequest:request] lastObject];
}

- (NSArray*)entitiesForFetchRequest:(NSFetchRequest*)request {
    NSError* error;
    NSArray* entities = [self.context executeFetchRequest:request error:&error];
    if (!entities) {
#if DEBUG
        NSLog(@"%s\n%@\n%@", __PRETTY_FUNCTION__, error.localizedDescription, error.userInfo);
#endif
    }
    
    return entities;
}

- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request {
    return [self fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:nil cacheName:nil];
}

- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request sectionNameKeyPath:(NSString*)path {
    return [self fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:path cacheName:nil];
}

- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request cacheName:(NSString*)name {
    return [self fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:nil cacheName:name];
}

- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request sectionNameKeyPath:(NSString*)path cacheName:(NSString*)name {
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                                 managedObjectContext:self.context
                                                                                   sectionNameKeyPath:path 
                                                                                            cacheName:name];
    [controller performFetch:nil];
    
    return controller;
}

- (BOOL)save:(NSError**)error {
    BOOL success = NO;
    
    @synchronized (mainContext) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        if (![NSThread isMainThread]) {
            [notificationCenter addObserver:self 
                                   selector:@selector(mergeChangesFromSaveNotification:)
                                       name:NSManagedObjectContextDidSaveNotification 
                                     object:self.context];
        }
        success = [self.context save:error];
        
        if (![NSThread isMainThread]) {
            [notificationCenter removeObserver:self 
                                          name:NSManagedObjectContextDidSaveNotification 
                                        object:self.context];
        }    
    }
    
	return success;
}

- (void)rollback {
	[self.context rollback];
}

- (void)mergeChangesFromSaveNotification:(NSNotification*)notification {
    [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                                     withObject:notification
                                                  waitUntilDone:YES];
}

- (id)objectWithID:(NSManagedObjectID*)objectID {
    return [self.context objectWithID:objectID];
}

- (void)deleteObjectsForName:(NSString *)objectName
{
    NSFetchRequest *fetchRequest	= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity		= [NSEntityDescription entityForName:objectName
                                               inManagedObjectContext:self.context];
    
    if (entity) {
        NSError* error = nil;
        
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *object in fetchedObjects)
        {
            [self.context deleteObject:object];
        }
        
        error = nil;
        [self.context save:&error];
    }
#if DEBUG
    NSLog(@"%@ %@", objectName,  @" deleted");
#endif
}

@end
