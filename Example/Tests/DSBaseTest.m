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

#import "DSBaseTest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSBaseTest

- (NSDictionary *)data {
    if (!_data) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"contactsdap-test-data"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _data = json;
    }
    return _data;
}

@end

NS_ASSUME_NONNULL_END
