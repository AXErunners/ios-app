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

@class NSManagedObjectModel;

@interface DSSchemaModelBuilder : NSObject

/**
 * Add STHeader entity to the resulting model
 */
- (void)addSTHeaderEntity;

/**
 * Add STPacket entity to the resulting model
 */
- (void)addSTPacketEntity;

/**
 * Add DAPContract entity to the resulting model
 */
- (void)addDAPContractEntity;

/**
 * Add custom DAPObject entity to the resulting model with the given typeName
 * @param typeName `objtype` of the DAPObject
 */
- (void)addDAPObjectEntityWithTypeName:(NSString *)typeName;

/**
 * Add BlockchainUser entity to the resulting model
 */
- (void)addBlockchainUserEntity;

/**
 * Add custom entity to the resulting model with the given name and object model
 * @param name The name of the entity
 * @param objectModel Dictionary repsenting entity object model (keys are attribute names, values used to exctract type information)
 */
- (void)addCustomEntityName:(NSString *)name objectModel:(NSDictionary<NSString *, id> *)objectModel;

/**
 * Creates new instance of managed object model with current builder's configuration
 * @return Managed object model
 */
- (NSManagedObjectModel *)buildManagedObjectModel;

@end

NS_ASSUME_NONNULL_END
