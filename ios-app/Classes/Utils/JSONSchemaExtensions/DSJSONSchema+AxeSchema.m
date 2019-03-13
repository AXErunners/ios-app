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

#import "DSJSONSchema+AxeSchema.h"

#import "DSJSONSchemaPVerValidator.h"
#import "DSSchemaStorage.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Storage Hodler

/**
 Holds schema storages by BOOL `removeAdditional` key
 
 We need to hold a reference to the `DSJSONSchema` objects outside because
 validators reference external schemas by weak reference to prevent retain cycles
 */
@interface DSJSONSchemaStorageHolder : NSObject

@property (strong, nonatomic) NSMutableDictionary<NSString *, DSJSONSchemaStorage *> *storageMapping;

- (DSJSONSchemaStorage *)jsonSchemaStorageRemoveAdditional:(BOOL)removeAdditional;
- (DSJSONSchemaStorage *)systemSchemaStorageRemoveAdditional:(BOOL)removeAdditional;

@end

@implementation DSJSONSchemaStorageHolder

+ (instancetype)sharedInstance {
    static DSJSONSchemaStorageHolder *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _storageMapping = [NSMutableDictionary dictionary];
    }
    return self;
}

- (DSJSONSchemaStorage *)jsonSchemaStorageRemoveAdditional:(BOOL)removeAdditional {
    NSString *key = [self keyWithPrefix:@"json" removeAdditional:removeAdditional];
    DSJSONSchemaStorage *storage = self.storageMapping[key];
    if (!storage) {
        DSJSONSchema *jsonSchema = [DSJSONSchema jsonSchemaRemoveAdditional:removeAdditional];
        storage = [DSJSONSchemaStorage storageWithSchema:jsonSchema];
        self.storageMapping[key] = storage;
    }
    return storage;
}

- (DSJSONSchemaStorage *)systemSchemaStorageRemoveAdditional:(BOOL)removeAdditional {
    NSString *key = [self keyWithPrefix:@"system" removeAdditional:removeAdditional];
    DSJSONSchemaStorage *storage = self.storageMapping[key];
    if (!storage) {
        DSJSONSchema *axeSchema = [DSJSONSchema systemSchemaRemoveAdditional:removeAdditional];
        storage = [DSJSONSchemaStorage storageWithSchema:axeSchema];
        self.storageMapping[key] = storage;
    }
    return storage;
}

- (NSString *)keyWithPrefix:(NSString *)prefix removeAdditional:(BOOL)removeAdditional {
    NSParameterAssert(prefix);
    return [NSString stringWithFormat:@"%@-removeAdditional:%@", prefix, removeAdditional ? @"1" : @"0"];
}

@end

#pragma mark - Schema

@implementation DSJSONSchema (AxeSchema)

+ (void)load {
    BOOL success = [DSJSONSchema registerValidatorClass:DSJSONSchemaPVerValidator.class
                                       forMetaschemaURI:nil
                                          specification:[DSJSONSchemaSpecification draft7]
                                              withError:NULL];

    if (success == NO) {
        [NSException raise:NSInternalInconsistencyException format:@"Failed to register Axe Schema validator."];
    }
}

+ (instancetype)systemSchemaRemoveAdditional:(BOOL)removeAdditional {
    DSJSONSchemaStorage *jsonSchemaStorage = [[DSJSONSchemaStorageHolder sharedInstance] jsonSchemaStorageRemoveAdditional:removeAdditional];

    return [self customSchemaWithObject:[DSSchemaStorage system]
                       referenceStorage:jsonSchemaStorage
                       removeAdditional:removeAdditional
                                  error:NULL];
}

+ (instancetype)jsonSchemaRemoveAdditional:(BOOL)removeAdditional {
    return [self customSchemaWithObject:[DSSchemaStorage json]
                       referenceStorage:nil
                       removeAdditional:removeAdditional
                                  error:NULL];
}

+ (instancetype)axeCustomSchemaWithObject:(NSDictionary<NSString *, id> *)schemaObject
                          removeAdditional:(BOOL)removeAdditional
                                     error:(NSError *__autoreleasing *)error {
    DSJSONSchemaStorage *axeSchemaStorage = [[DSJSONSchemaStorageHolder sharedInstance] systemSchemaStorageRemoveAdditional:removeAdditional];

    DSJSONSchema *schema = [self customSchemaWithObject:schemaObject
                                       referenceStorage:axeSchemaStorage
                                       removeAdditional:removeAdditional
                                                  error:error];
    return schema;
}

+ (instancetype)customSchemaWithObject:(NSDictionary<NSString *, id> *)schemaObject
                      referenceStorage:(nullable DSJSONSchemaStorage *)referenceStorage
                      removeAdditional:(BOOL)removeAdditional
                                 error:(NSError *__autoreleasing *)error {
    DSJSONSchemaValidationOptions *options = [[DSJSONSchemaValidationOptions alloc] init];
    if (removeAdditional) {
        options.removeAdditional = DSJSONSchemaValidationOptionsRemoveAdditionalYes;
    }

    DSJSONSchema *schema = [DSJSONSchema schemaWithObject:schemaObject
                                                  baseURI:nil
                                         referenceStorage:referenceStorage
                                            specification:[DSJSONSchemaSpecification draft7]
                                                  options:options
                                                    error:error];
    return schema;
}

@end

NS_ASSUME_NONNULL_END
