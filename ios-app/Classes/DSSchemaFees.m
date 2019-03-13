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

#import "DSSchemaFees.h"

NS_ASSUME_NONNULL_BEGIN

@implementation DSSchemaFees

+ (instancetype)feePerByte:(double)feePerByte packetSize:(NSInteger)packetSize {
    return [[self alloc] initWithFeePerByte:feePerByte packetSize:packetSize];
}

- (instancetype)initWithFeePerByte:(double)feePerByte packetSize:(NSInteger)packetSize {
    self = [super init];
    if (self) {
        const double stHeaderSizeBytes = 220.0;
        const double curveParam = 8.8;
        const double curveThreshold = 1.0;
        const double curveMag = 5.0;

        double core = pow((double)packetSize, 3.0) / pow((curveParam * pow(10.0, curveMag)), 2.0);
        double multi = ceil(MAX(curveThreshold, core));

        _headerFee = feePerByte * stHeaderSizeBytes;
        _packetFee = (multi * _headerFee) - _headerFee;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
