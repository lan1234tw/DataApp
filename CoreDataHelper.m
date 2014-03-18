//
//  CoreDataHelper.m
//  DataApp
//
//  Created by HsiuYi on 2014/3/13.
//  Copyright (c) 2014年 HsiuYi. All rights reserved.
//

#import "CoreDataHelper.h"
#import "Item.h"

@implementation CoreDataHelper

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Initialization
+ (CoreDataHelper*)instance {
  static CoreDataHelper* _instance =nil;
  static dispatch_once_t once_token;
  
  dispatch_once(&once_token, ^{
      _instance =[[CoreDataHelper alloc] init];
  });
  
  return _instance;
}

#pragma mark - Save Context
- (void)saveContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } // if
  } // if
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  
  _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataApp.sqlite"];
  
  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}

#pragma mark - 回傳Application's Documents directory
- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Insert test data
- (void)insertTestData {
  Item *item =nil;
  
  // -------------
  item =[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                             inManagedObjectContext:self.managedObjectContext];
  
  item.name =@"aaa";
  item.type =@"type_a";
  item.item_id =@"0001";
  
  // -------------
  item =[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                      inManagedObjectContext:self.managedObjectContext];
  
  item.name =@"bbb";
  item.type =@"type_a";
  item.item_id =@"0002";
  
  // -------------
  item =[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                      inManagedObjectContext:self.managedObjectContext];
  
  item.name =@"ccc";
  item.type =@"type_a";
  item.item_id =@"0003";
  
  // -------------
  item =[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                      inManagedObjectContext:self.managedObjectContext];
  
  item.name =@"ddd";
  item.type =@"type_b";
  item.item_id =@"0004";
  
  // -------------
  item =[NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                      inManagedObjectContext:self.managedObjectContext];
  
  item.name =@"eee";
  item.type =@"type_b";
  item.item_id =@"0005";
  
  [self saveContext];
}


@end
