//
//  CoreDataManager.h
//  tea
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize privateObjectContext = _privateObjectContext;
@synthesize backgroundContext = _backgroundContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize databaseName = _databaseName;
@synthesize modelName = _modelName;
@synthesize persistentStore = _persistentStore;

- (id)init {
    self = [super init];
    if (self) {
        [self addNotifications];
    }
    return self;
}

+ (id)instance {
    return [self sharedManager];
}


+ (instancetype)sharedManager {
    static CoreDataManager *singleton;
    static dispatch_once_t singletonToken;
    dispatch_once(&singletonToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}


#pragma mark - Private

- (NSString *)appName {
    return [[NSBundle bundleForClass:[self class]] infoDictionary][@"CFBundleName"];
}

- (NSString *)databaseName {
    if (_databaseName != nil) return _databaseName;

    _databaseName = [[[self appName] stringByAppendingString:@".sqlite"] copy];
    return _databaseName;
}

- (NSString *)modelName {
    if (_modelName != nil) return _modelName;

    _modelName = [[self appName] copy];
    return _modelName;
}

#pragma mark - merge notification methods

- (void)mainManageObjectContextDidSaved:(NSNotification *)notification {
    @synchronized(self){
        [self.privateObjectContext performBlock:^{
            [self.privateObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)privateManageObjectContextDidSaved:(NSNotification *)notification {
    @synchronized(self){
        [self.managedObjectContext performBlock:^{
            //http://stackoverflow.com/questions/3923826/nsfetchedresultscontroller-with-predicate-ignores-changes-merged-from-different
            for(NSManagedObject *object in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]) {
                [[self.managedObjectContext objectWithID:[object objectID]] willAccessValueForKey:nil];
            }
            [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

#pragma mark - Custom methods

- (void)removeAllRecord {
    NSError *error = nil;
    NSPersistentStoreCoordinator *storeCoodinator = self.persistentStoreCoordinator;
    [storeCoodinator removePersistentStore:self.persistentStore error:&error];
    
    [self removeNotifications];
    _privateObjectContext = nil;
    _managedObjectModel = nil;
    if ([self removeSQLiteFilesAtStoreURL:[self sqliteStoreURL] error:&error]) {
        self.persistentStore = [self.persistentStoreCoordinator
                                addPersistentStoreWithType:NSSQLiteStoreType
                                configuration:nil
                                URL:[self sqliteStoreURL]
                                options:@{ NSMigratePersistentStoresAutomaticallyOption: @YES,
                                           NSInferMappingModelAutomaticallyOption: @YES }

                                error:&error];
        [self addNotifications];
    }
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mainManageObjectContextDidSaved:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:[self managedObjectContext]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(privateManageObjectContextDidSaved:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:[self privateObjectContext]];
}
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) return _managedObjectContext;

    if (self.persistentStoreCoordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}
- (NSManagedObjectContext *)privateObjectContext {
    if (_privateObjectContext) return _privateObjectContext;
    
    if (self.persistentStoreCoordinator) {
        _privateObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_privateObjectContext setParentContext:self.managedObjectContext];
    }
    return _privateObjectContext;
}
- (NSManagedObjectContext *)backgroundContext {
    if (_backgroundContext) return _backgroundContext;
    
    if (self.persistentStoreCoordinator) {
        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundContext setParentContext:self.managedObjectContext];
    }
    return _backgroundContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) return _managedObjectModel;

    NSURL *modelURL = [[NSBundle bundleForClass:[self class]] URLForResource:[self modelName] withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;

    _persistentStoreCoordinator = [self persistentStoreCoordinatorWithStoreType:NSSQLiteStoreType
                                                                       storeURL:[self sqliteStoreURL]];
    return _persistentStoreCoordinator;
}

- (void)useInMemoryStore {
    _persistentStoreCoordinator = [self persistentStoreCoordinatorWithStoreType:NSInMemoryStoreType storeURL:nil];
}

- (BOOL)saveContext {
    if (self.managedObjectContext == nil) return NO;
    if (![self.managedObjectContext hasChanges])return NO;

    NSError *error = nil;

    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error in saving context! %@, %@", error, [error userInfo]);
        return NO;
    }

    return YES;
}


#pragma mark - SQLite file directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)applicationSupportDirectory {
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
                                                   inDomains:NSUserDomainMask] lastObject]
            URLByAppendingPathComponent:[self appName]];
}


#pragma mark - Private

- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithStoreType:(NSString *const)storeType
                                                                 storeURL:(NSURL *)storeURL {

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption: @YES,
                               NSInferMappingModelAutomaticallyOption: @YES };

    NSError *error = nil;
    self.persistentStore = [coordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:&error];
    if (!self.persistentStore){
        NSLog(@"ERROR WHILE CREATING PERSISTENT STORE COORDINATOR! %@, %@", error, [error userInfo]);
    error = nil;
    if ([self removeSQLiteFilesAtStoreURL:storeURL error:&error]) {
        self.persistentStore = [_persistentStoreCoordinator
                                addPersistentStoreWithType:NSSQLiteStoreType
                                configuration:nil
                                URL:storeURL
                                options:options
                                error:&error];
    }else{
        NSLog(@"could not remove has changed sqilte");
    }
    }


    return coordinator;
}

- (NSURL *)sqliteStoreURL {
    NSURL *directory = [self isOSX] ? self.applicationSupportDirectory : self.applicationDocumentsDirectory;
    NSURL *databaseDir = [directory URLByAppendingPathComponent:[self databaseName]];
    NSLog(@"db------->%@",databaseDir);
    [self createApplicationSupportDirIfNeeded:directory];
    return databaseDir;
}

- (BOOL)isOSX {
    if (NSClassFromString(@"UIDevice")) return NO;
    return YES;
}

- (void)createApplicationSupportDirIfNeeded:(NSURL *)url {
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.absoluteString]) return;

    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES attributes:nil error:nil];
}

- (BOOL)removeSQLiteFilesAtStoreURL:(NSURL *)storeURL error:(NSError * __autoreleasing *)error {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *storeDirectory = [storeURL URLByDeletingLastPathComponent];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:storeDirectory
                                          includingPropertiesForKeys:nil
                                                             options:0
                                                        errorHandler:nil];
    
    NSString *storeName = [storeURL.lastPathComponent stringByDeletingPathExtension];
    for (NSURL *url in enumerator) {
        
        if ([url.lastPathComponent hasPrefix:storeName] == NO) {
            continue;
        }
        
        NSError *fileManagerError = nil;
        if ([fileManager removeItemAtURL:url error:&fileManagerError] == NO) {
            
            if (error != NULL) {
                *error = fileManagerError;
            }
            
            return NO;
        }
    }
    
    return YES;
}

@end
