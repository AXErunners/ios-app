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

#import <XCTest/XCTest.h>

#import <APP/DSSchemaFees.h>

@interface DSSchemaFeesTests : XCTestCase

@property (readonly, assign, nonatomic) double medianTxSizeBytes;
@property (readonly, assign, nonatomic) double medianTxFee;
@property (readonly, assign, nonatomic) double feePerByte;

@property (readonly, assign, nonatomic) double accuracy;

@end

@implementation DSSchemaFeesTests

- (double)medianTxSizeBytes {
    return 250.0;
}

- (double)medianTxFee {
    return 0.0006;
}

- (double)feePerByte {
    return self.medianTxFee / self.medianTxSizeBytes;
}

- (double)accuracy {
    return 0.00000000000000000001;
}

- (void)testSTHeaderFee {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:1000];
    XCTAssertEqualWithAccuracy(fees.headerFee,
                               0.0005279999999999999,
                               self.accuracy);
}

- (void)testSTPacketFeeTest1k {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:1000];
    XCTAssertEqualWithAccuracy(fees.packetFee,
                               0.0,
                               self.accuracy);
}

- (void)testSTPacketFeeTest5k {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:5000];
    XCTAssertEqualWithAccuracy(fees.packetFee,
                               0.0,
                               self.accuracy);
}

- (void)testSTPacketFeeTest10k {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:10000];
    XCTAssertEqualWithAccuracy(fees.packetFee,
                               0.0005279999999999999,
                               self.accuracy);
}

- (void)testSTPacketFeeTest50k {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:50000];
    XCTAssertEqualWithAccuracy(fees.packetFee,
                               0.08500799999999999,
                               self.accuracy);
}

- (void)testSTPacketFeeTest100k {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:100000];
    XCTAssertEqualWithAccuracy(fees.packetFee,
                               0.6816479999999999,
                               self.accuracy);
}

- (void)testSTPacketFeeTest500k {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:500000];
    XCTAssertEqualWithAccuracy(fees.packetFee,
                               85.22711999999999,
                               self.accuracy);
}

- (void)testSTPacketFeeTest1m {
    DSSchemaFees *fees = [DSSchemaFees feePerByte:self.feePerByte packetSize:1000000];
    XCTAssertEqualWithAccuracy(fees.packetFee,
                               681.8180159999998,
                               self.accuracy);
}

@end
