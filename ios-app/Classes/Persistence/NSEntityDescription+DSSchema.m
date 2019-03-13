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

#import "NSEntityDescription+DSSchema.h"

#import "NSAttributeDescription+DSSchema.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSEntityDescription (DSSchema)

- (instancetype)initWithName:(NSString *)name modelDictionary:(NSDictionary<NSString *, id> *)modelDicitonary {
    NSParameterAssert(name);
    NSParameterAssert(modelDicitonary);

    self = [self init];
    if (self) {
        self.name = name;
        self.managedObjectClassName = name;

        NSMutableArray<NSAttributeDescription *> *properties = [NSMutableArray array];
        for (NSString *key in modelDicitonary) {
            id value = modelDicitonary[key];
            NSAttributeDescription *attributeDescription = [[NSAttributeDescription alloc] initWithName:key value:value];
            [properties addObject:attributeDescription];
        }
        self.properties = properties;
    }
    return self;
}


@end

NS_ASSUME_NONNULL_END
