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

#import "DSSchemaHash.h"

#import "DSSchemaHashUtils.h"
#import "DSSchemaObject.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSSchemaHash

+ (nullable NSString *)subTx:(NSDictionary<NSString *, id> *)object {
    NSDictionary<NSString *, id> *validatedObject = [DSSchemaObject fromObject:object dapSchema:nil];
    NSString *hash = [DSSchemaHashUtils hashOfObject:validatedObject];
    return hash;
}

+ (nullable NSString *)blockchainUser:(NSDictionary<NSString *, id> *)object {
    NSDictionary<NSString *, id> *validatedObject = [DSSchemaObject fromObject:object dapSchema:nil];
    NSString *hash = [DSSchemaHashUtils hashOfObject:validatedObject];
    return hash;
}

+ (nullable NSString *)stHeader:(NSDictionary<NSString *, id> *)object {
    NSString *hash = [DSSchemaHashUtils hashOfObject:object];
    return hash;
}

+ (nullable NSString *)stPacket:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema {
    id stpacket = object[@"stpacket"];
    NSString *hash = [DSSchemaHashUtils hashOfObject:stpacket];

    /*
     
    // This code copied from Android Axe Schema Library
 
    // TODO: Different from JS Lib, however, js lib seems to be hashing string chars instead of properties: needs verification.
    val stPacket = obj.getJSONObject(STPACKET)
    return if (stPacket.has(DAPOBJECTS)) {
        val dapObjects = stPacket.getJSONArray(DAPOBJECTS)
        for (i in 0..dapObjects.length()) {
            val dapObject = Object.fromObject(dapObjects.getJSONObject(i), dapSchema)
            if (dapObject != null) {
                objList.add(dapObject)
            }
        }
        HashUtils.toHash(objList)
    } else {
        HashUtils.toHash(obj)
    }
     
     */

    return hash;
}

+ (nullable NSString *)dapContract:(NSDictionary<NSString *, id> *)object {
    NSDictionary<NSString *, id> *validatedObject = [DSSchemaObject fromObject:object dapSchema:nil];
    NSString *hash = [DSSchemaHashUtils hashOfObject:validatedObject];
    return hash;
}

+ (nullable NSString *)dapSchema:(NSDictionary<NSString *, id> *)object {
    NSDictionary<NSString *, id> *validatedObject = [DSSchemaObject fromObject:object dapSchema:nil];
    NSString *hash = [DSSchemaHashUtils hashOfObject:validatedObject];
    return hash;
}

+ (nullable NSString *)dapObject:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema {
    NSDictionary<NSString *, id> *validatedObject = [DSSchemaObject fromObject:object dapSchema:dapSchema];
    NSString *hash = [DSSchemaHashUtils hashOfObject:validatedObject];
    return hash;
}

@end

NS_ASSUME_NONNULL_END
