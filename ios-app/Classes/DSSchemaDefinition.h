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

@interface DSSchemaDefinition : NSObject

+ (nullable NSDictionary<NSString *, id> *)getDAPSubSchema:(NSDictionary<NSString *, id> *)object dapSchema:(NSDictionary<NSString *, id> *)dapSchema;

/**
 Get schema relations

 @param dapSchema DAP Schema
 */
+ (NSDictionary<NSString *, NSArray<NSString *> *> *)getSchemaRelations:(NSDictionary<NSString *, id> *)dapSchema;

/**
 Get sub schema relations

 @param dapSchema DAP Schema
 @param subSchemaKey Sub schema key
 @return An array of relations
 */
+ (NSArray<NSString *> *)getSubSchemaRelations:(NSDictionary<NSString *, id> *)dapSchema subSchemaKey:(NSString *)subSchemaKey;

@end

NS_ASSUME_NONNULL_END
