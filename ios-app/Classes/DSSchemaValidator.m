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

#import "DSSchemaValidator.h"

#import <DSJSONSchemaValidation/NSDictionary+DSJSONDeepMutableCopy.h>

#import "DSSchemaJSONSchemaUtils.h"
#import "DSSchemaObject.h"
#import "DSSchemaValidationResult.h"
#import "DSSchemaDefinition.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const OBJTYPE = @"objtype";

@implementation DSSchemaValidator

+ (DSSchemaValidationResult *)validateSubTx:(NSDictionary<NSString *, id> *)object {
    return [self validateSysObject:object subSchemaName:@"subtx"];
}

+ (DSSchemaValidationResult *)validateBlockchainUser:(NSDictionary<NSString *, id> *)object {
    return [self validateSysObject:object subSchemaName:@"blockchainuser"];
}

+ (DSSchemaValidationResult *)validateSTHeader:(NSDictionary<NSString *, id> *)object {
    return [self validateSysObject:object subSchemaName:@"stheader"];
}

+ (DSSchemaValidationResult *)validateSTPacketObject:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema {
    // deep extract a schema object from the object
    NSMutableDictionary<NSString *, id> *outerObject = [[DSSchemaObject fromObject:object dapSchema:nil] ds_deepMutableCopy];

    // if this is a dapobjects packet...
    NSDictionary<NSString *, id> *objSTPacket = object[DS_STPACKET];
    NSArray *objDapObjects = objSTPacket[DS_DAPOBJECTS];

    if (objDapObjects) {
        if (!dapSchema) {
            return [[DSSchemaValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeMissingDAPSchema
                                                               objType:nil
                                                              propName:nil
                                                            schemaName:nil];
        }

        // temporarily remove the inner dapobjects,
        // so we can validate the containing packet using the System Schema, and the
        // contained Dap objects using the dapSchema.
        NSMutableDictionary<NSString *, id> *mutableSTPacket = outerObject[DS_STPACKET];
        NSAssert([mutableSTPacket isKindOfClass:NSMutableDictionary.class], @"stpacket is absent or ds_deepMutableCopy failed to make a deep mutable copy");
        mutableSTPacket[DS_DAPOBJECTS] = @[ @{} ];

        // validate the empty packet as a sys object...
        DSSchemaValidationResult *outerValid = [self validateSysObject:outerObject subSchemaName:DS_STPACKET];

        if (!outerValid.valid) {
            return outerValid;
        }

        //...then validate the contents as dabobjects
        return [self validateSTPacketObjects:objDapObjects dapSchema:dapSchema];
    }

    // not a dapobjects packet so validate as a sysobject
    return [self validateSysObject:object subSchemaName:DS_STPACKET];
}

+ (DSSchemaValidationResult *)validateSTPacketObjects:(NSArray *)dapObjects dapSchema:(NSDictionary<NSString *, id> *)dapSchema {
    for (NSDictionary<NSString *, id> *dapObject in dapObjects) {
        DSSchemaValidationResult *result = [self validateDapObject:dapObject dapSchema:dapSchema];
        if (!result.valid) {
            return result;
        }
    }

    return [[DSSchemaValidationResult alloc] initAsValid];
}

+ (DSSchemaValidationResult *)validateDapContract:(NSDictionary<NSString *, id> *)object {
    return [self validateSysObject:object subSchemaName:@"dapcontract"];
}

+ (DSSchemaValidationResult *)validateDapObject:(NSDictionary<NSString *, id> *)dapObject dapSchema:(NSDictionary<NSString *, id> *)dapSchema {
    id objType = dapObject[OBJTYPE];
    if (!objType || ![objType isKindOfClass:NSString.class]) {
        return [[DSSchemaValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeDAPObjectMissingObjType
                                                           objType:@"objtype"
                                                          propName:nil
                                                        schemaName:dapSchema[@"title"]];
    }

    NSDictionary<NSString *, id> *subSchema = [DSSchemaDefinition getDAPSubSchema:dapObject dapSchema:dapSchema];
    if (!subSchema) {
        return [[DSSchemaValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeDAPObjectUnknownObjType
                                                           objType:@"objtype"
                                                          propName:nil
                                                        schemaName:dapSchema[@"title"]];
    }

    return [self validateCoreObject:dapObject dapSchema:dapSchema];
}

+ (BOOL)validateBlockchainUsername:(NSString *)username {
    if (!username) {
        return NO;
    }

    if (username.length < 3 && username.length > 24) {
        return NO;
    }

    // TODO: case sensetive?
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"[^a-z0-9._]" options:kNilOptions error:NULL];
    NSParameterAssert(regexp);
    NSRange fullRange = NSMakeRange(0, username.length);
    BOOL invalid = [regexp numberOfMatchesInString:username options:kNilOptions range:fullRange] != 0;

    return !invalid;
}

#pragma mark - Private

/**
 * Validates both System and Dap objects
 * @param object Schema object instance
 * @param dapSchema Dap Schema definition (optional)
 * @return Validation result
 */
+ (DSSchemaValidationResult *)validateCoreObject:(nullable NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema {
    if (!object) {
        return [[DSSchemaValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeUnknown
                                                           objType:nil
                                                          propName:nil
                                                        schemaName:nil];
    }

    NSDictionary<NSString *, id> *validatedObject = [DSSchemaObject fromObject:object dapSchema:dapSchema];
    return [DSSchemaJSONSchemaUtils validateSchemaObject:validatedObject dapSchema:dapSchema];
}

/**
 * Validates a System Schema object instance
 * @param sysObject System Schema object instance
 * @param subSchemaName Subschema keyword
 * @returns Validation result
 */
+ (DSSchemaValidationResult *)validateSysObject:(NSDictionary<NSString *, id> *)sysObject subSchemaName:(nullable NSString *)subSchemaName {
    if (subSchemaName) {
        if (!sysObject[subSchemaName]) {
            return [[DSSchemaValidationResult alloc] initWithErrorCode:DSValidationResultErrorCodeDAPObjectMissingSubschema
                                                               objType:nil
                                                              propName:nil
                                                            schemaName:nil];
        }
    }

    return [self validateCoreObject:sysObject dapSchema:nil];
}

@end

NS_ASSUME_NONNULL_END
