//
//  SGTEntityManager.h
//  SGTEntityKit
//
//  Created by Greg Macko on 4/11/12.
//  Copyright (c) 2012 Sogeti USA, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/* SGTEntityManager is an abstraction of NSManagedObjectModel and NSManagedObjectContext.  You should
 * typically not need to access a model or context directly but should instead use SGTEntityManager to interact
 * with the other Core Data classes such as NSManagedObject (or subclasses), NSFetchRequest,
 * and NSFetchedResultsController.
 *
 * You will typically call + (void)setMainContext:(NSManagedObjectContext *)context; with the context created in your
 * implementation of the UIApplicationDelegate protocol.
 */
@interface SGTEntityManager : NSObject


// this method must be called before creating any instaces of SGTEntityManager
+ (void)initializeWithModelURL:(NSURL *)modelURL storeURL:(NSURL *)storeURL;

/* Designated initializer
 *
 * Calling init from the main thread will create an entity manager with the main context.
 * Calling init from a background thread will create an entity manager with the a new context.  The changes will
 * automatically be merged with the main context the entity manager is sent the save message.
 */
- (id)init;

// create entity for local use
- (id)entityForName:(NSString *)name;

// Add local copy to data store
- (void)insertEntity:(NSManagedObject *)entity;

// create entities
- (id)insertEntityWithName:(NSString*)name;

// delete entities
- (void)deleteEntity:(NSManagedObject*)entity;
- (void)deleteEntities:(id<NSFastEnumeration>)entities;

// configure fetch requests
- (NSFetchRequest*)fetchRequestFromTemplateWithName:(NSString*)name;
- (NSFetchRequest*)fetchRequestFromTemplateWithName:(NSString*)name substitutionVariables:(NSDictionary*)variables;
- (NSFetchRequest*)fetchRequestFromTemplateWithName:(NSString*)name variable:(id)variable forKey:(NSString*)key;

// execute fetch requests
- (NSUInteger)countForFetchRequest:(NSFetchRequest*)request;
- (id)entityForFetchRequest:(NSFetchRequest*)request;
- (NSArray*)entitiesForFetchRequest:(NSFetchRequest*)request;

// configure fetched results controllers
- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request;
- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request sectionNameKeyPath:(NSString*)path;
- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request cacheName:(NSString*)name;
- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)request sectionNameKeyPath:(NSString*)path cacheName:(NSString*)name;

// update the persistent store
- (BOOL)save:(NSError**)error;
- (void)rollback;

// fetch ObjectWithObjectID
- (id)objectWithID:(NSManagedObjectID*)objectID;

- (void)deleteObjectsForName:(NSString *)objectName;
@end
