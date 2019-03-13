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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const DS_ACT;
extern NSString *const DS_ALL_OF;
extern NSString *const DS_DAPOBJECTS;
extern NSString *const DS_DEFINITIONS;
extern NSString *const DS_DAPMETASCHEMA;
extern NSString *const DS_INDEX;
extern NSString *const DS_IS_ROLE;
extern NSString *const DS_OBJECTS;
extern NSString *const DS_OBJTYPE;
extern NSString *const DS_PROPERTIES;
extern NSString *const DS_REF;
extern NSString *const DS_REV;
extern NSString *const DS_STPACKET;
extern NSString *const DS_STHEADER;
extern NSString *const DS_TITLE;
extern NSString *const DS_TYPE;
extern NSString *const DS_USER_ID;
extern NSString *const DS_BUID;
extern NSString *const DS_SCHEMA_ID;
extern NSString *const DS_SCHEMA;

extern NSUInteger const DS_CREATE_OBJECT_ACTION;
extern NSUInteger const DS_UPDATE_OBJECT_ACTION;
extern NSUInteger const DS_REMOVE_OBJECT_ACTION;

@interface DSSchemaObject : NSObject

/**
 * Clone a Schema instance by extracting only Schema defined properties
 * Optionally specify a dapSchema to clone a DAP Object
 * @param object Schema object instance
 * @param dapSchema DapSchema (optional)
 * @return object with allowed properties only
 */
+ (NSDictionary<NSString *, id> *)fromObject:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema;

/**
 * Set metadata property value in a Schema object instance
 * @param object Schema object instance
 * @param key Meta section keyword
 * @param value A value for the key
 * @return Given object with meta of key and value
 */
+ (NSDictionary<NSString *, id> *)setMetaObject:(NSDictionary<NSString *, id> *)object key:(NSString *)key value:(id)value;

/**
 * Classify an object as a System Object without validation
 */
+ (BOOL)isSysObject:(nullable NSDictionary<NSString *, id> *)object;

/**
 * Return a hash of a Schema object instance
 * @param object Schema object instance
 * @param dapSchema DapSchema
 */
+ (nullable NSString *)hashOfObject:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema;

/**
 * Sets removal action on a Schema Object
 */
+ (NSDictionary<NSString *, id> *)prepareForRemoval:(NSDictionary<NSString *, id> *)object;

+ (nullable NSString *)metaFromObject:(NSDictionary<NSString *, id> *)object byKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
