//
//  Created by Andrew Podkovyrin
//  Copyright © 2018 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DSSchemaPersistenceStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSchemaPersistenceStack ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSURL *storeURL;

@end

@implementation DSSchemaPersistenceStack

- (instancetype)initWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel fileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        _managedObjectModel = managedObjectModel;

        NSURL *directoryURL = [NSPersistentContainer defaultDirectoryURL];
        _storeURL = [directoryURL URLByAppendingPathComponent:fileName];

        NSPersistentStoreDescription *storeDescription = [[NSPersistentStoreDescription alloc] initWithURL:_storeURL];
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"AxeSchema" managedObjectModel:_managedObjectModel];
        _persistentContainer.persistentStoreDescriptions = @[ storeDescription ];
    }

    return self;
}

- (void)loadStack:(void (^_Nullable)(DSSchemaPersistenceStack *stack))completion {
    [self loadStack:completion cleanStart:NO];
}

#pragma mark Private

- (void)loadStack:(void (^_Nullable)(DSSchemaPersistenceStack *stack))completion cleanStart:(BOOL)cleanStart {
    __weak typeof(self) weakSelf = self;
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *_Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        if (error != nil) {
            NSLog(@"DSSchemaPersistenceStack: %@", error);

            if (cleanStart) {
                // TODO: handle more gently

                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                abort();
            }

            // remove existing database
            NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:strongSelf.managedObjectModel];
            [psc destroyPersistentStoreAtURL:strongSelf.storeURL withType:NSSQLiteStoreType options:nil error:nil];

            // try again
            [strongSelf loadStack:completion cleanStart:YES];
        }
        else {
            strongSelf.persistentContainer.viewContext.undoManager = nil;
            strongSelf.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
            strongSelf.persistentContainer.viewContext.automaticallyMergesChangesFromParent = YES;

            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(strongSelf);
                });
            }
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
