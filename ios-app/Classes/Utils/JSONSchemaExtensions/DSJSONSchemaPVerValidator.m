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

#import "DSJSONSchemaPVerValidator.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSJSONSchemaPVerValidator

static NSString *const kSchemaKeywordPVer = @"pver";

- (instancetype)initWithValue:(NSNumber *)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@"{ pver value: %@ }", self.value];
}

+ (NSSet<NSString *> *)assignedKeywords {
    return [NSSet setWithObject:kSchemaKeywordPVer];
}

+ (nullable instancetype)validatorWithDictionary:(NSDictionary<NSString *, id> *)schemaDictionary schemaFactory:(__unused DSJSONSchemaFactory *)schemaFactory error:(NSError *__autoreleasing *)error {
    id constObject = schemaDictionary[kSchemaKeywordPVer];
    if (constObject) {
        return [[self alloc] initWithValue:constObject];
    }

    if (error != NULL) {
        *error = [NSError vv_JSONSchemaErrorWithCode:DSJSONSchemaErrorCodeInvalidSchemaFormat failingObject:schemaDictionary];
    }
    return nil;
}

- (nullable NSArray<DSJSONSchema *> *)subschemas {
    return nil;
}

- (BOOL)validateInstance:(id)instance inContext:(DSJSONSchemaValidationContext *)context error:(NSError *__autoreleasing *)error {
    // TODO: pver validation is disabled for now
    return YES;
}

@end

NS_ASSUME_NONNULL_END
