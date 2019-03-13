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

#import "DSSchemaHashUtils.h"

#import "NSData+DSSchemaUtils.h"
#import <TinyCborObjc/NSObject+DSCborEncoding.h>

NS_ASSUME_NONNULL_BEGIN

@implementation DSSchemaHashUtils

+ (nullable NSString *)hashOfObject:(NSObject *)object {
    NSData *cborData = [object ds_cborEncodedObject];
    if (!cborData) {
        return nil;
    }

    NSData *sha256Twice = [[cborData ds_SHA256Digest] ds_SHA256Digest];
    NSData *sha256Reversed = [sha256Twice ds_reverseData];
    NSString *sha256String = [sha256Reversed ds_hexStringFromData];

    return sha256String;
}

@end

NS_ASSUME_NONNULL_END
