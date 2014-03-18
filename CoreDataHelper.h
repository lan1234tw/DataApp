//
//  CoreDataHelper.h
//  DataApp
//
//  Created by HsiuYi on 2014/3/13.
//  Copyright (c) 2014年 HsiuYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataHelper*)instance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertTestData;

@end
