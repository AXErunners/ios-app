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

#import "NSAttributeDescription+DSSchema.h"

#import <DSJSONSchemaValidation/NSNumber+DSJSONNumberTypes.h>

NS_ASSUME_NONNULL_BEGIN

@implementation NSAttributeDescription (DSSchema)

- (instancetype)initWithName:(NSString *)name value:(id)value {
    NSParameterAssert(name);
    NSParameterAssert(value);

    self = [self init];
    if (self) {
        self.name = name;
        if ([value isKindOfClass:NSString.class]) {
            self.attributeType = NSStringAttributeType;
        }
        else if ([value isKindOfClass:NSNumber.class]) {
            NSNumber *number = (NSNumber *)value;
            if ([number ds_isFloat]) {
                self.attributeType = NSDoubleAttributeType;
            }
            else if ([number ds_isInteger]) {
                self.attributeType = NSInteger64AttributeType;
            }
            else if ([number ds_isBoolean]) {
                self.attributeType = NSBooleanAttributeType;
            }
        }
        else if ([value isKindOfClass:NSDictionary.class] || [value isKindOfClass:NSArray.class]) {
            self.attributeType = NSTransformableAttributeType;
        }
        else {
            NSAssert(NO, @"Unknown value type");
        }
        self.optional = YES;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
