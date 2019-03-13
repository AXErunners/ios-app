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

#import "DSSchemaJSONSchemaUtils.h"

#import "DSJSONSchema+AxeSchema.h"
#import "DSSchemaStorage.h"
#import "DSSchemaValidationResult.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSSchemaJSONSchemaUtils

+ (DSSchemaValidationResult *)validateSchemaObject:(NSDictionary<NSString *, id> *)object dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema {
    DSJSONSchema *schema = nil;
    if (dapSchema) {
        schema = [DSJSONSchema axeCustomSchemaWithObject:dapSchema removeAdditional:NO error:NULL];
    }
    else {
        schema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    }

    NSError *error = nil;
    BOOL valid = [schema validateObject:object withError:&error];
    if (valid) {
        return [[DSSchemaValidationResult alloc] initAsValid];
    }

    NSString *objType = nil;
    if (dapSchema) {
        objType = object[@"objtype"] ?: @"";
    }
    else {
        objType = object.allKeys.firstObject;
    }

    return [[DSSchemaValidationResult alloc] initWithError:error objType:objType propName:nil schemaName:schema.title];
}

+ (DSSchemaValidationResult *)validateDapSchemaDef:(NSDictionary<NSString *, id> *)dapSchema {
    NSError *error = nil;
    __unused DSJSONSchema *schema = [DSJSONSchema axeCustomSchemaWithObject:dapSchema removeAdditional:NO error:&error];
    if (error) {
        return [[DSSchemaValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }

    return [[DSSchemaValidationResult alloc] initAsValid];
}

+ (DSSchemaValidationResult *)validateDapSubschemaDef:(NSDictionary<NSString *, id> *)dapSubschema {
    NSDictionary<NSString *, id> *systemSchemaObject = [DSSchemaStorage system];
    NSDictionary<NSString *, id> *dapMetaSchemaObject = systemSchemaObject[@"definitions"][@"dapmetaschema"];
    NSParameterAssert(dapMetaSchemaObject);
    DSJSONSchema *dapMetaSchema = [DSJSONSchema axeCustomSchemaWithObject:dapMetaSchemaObject removeAdditional:NO error:NULL];

    NSError *error = nil;
    BOOL valid = [dapMetaSchema validateObject:dapSubschema withError:&error];
    if (!valid) {
        return [[DSSchemaValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }

    DSJSONSchema *systemSchema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    valid = [systemSchema validateObject:dapSubschema withError:&error];
    if (!valid) {
        return [[DSSchemaValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }

    return [[DSSchemaValidationResult alloc] initAsValid];
}

+ (DSSchemaValidationResult *)validateSchemaDef:(NSDictionary<NSString *, id> *)schemaObject {
    DSJSONSchema *systemSchema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    NSError *error = nil;
    BOOL valid = [systemSchema validateObject:schemaObject withError:&error];
    if (!valid) {
        return [[DSSchemaValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }

    return [[DSSchemaValidationResult alloc] initAsValid];
}

+ (NSDictionary<NSString *, id> *)extractSchemaObject:(NSMutableDictionary<NSString *, id> *)mutableObject dapSchema:(nullable NSDictionary<NSString *, id> *)dapSchema {
    DSJSONSchema *schema = nil;
    if (dapSchema) {
        schema = [DSJSONSchema axeCustomSchemaWithObject:dapSchema removeAdditional:YES error:NULL];
    }
    else {
        schema = [DSJSONSchema systemSchemaRemoveAdditional:YES];
    }

    NSError *error = nil;
    [schema validateObject:mutableObject withError:&error];

    if (error) {
        // TODO: Check expected type of added errors
        mutableObject[@"errors"] = error;
    }

    return [mutableObject copy];
}

@end

NS_ASSUME_NONNULL_END
