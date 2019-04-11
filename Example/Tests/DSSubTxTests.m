//
//  Created by Andrew Podkovyrin
//  Copyright © 2018 Axe Core Group. All rights reserved.
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

#import <axe_schema_ios/DSSchemaHash.h>
#import <axe_schema_ios/DSSchemaValidator.h>
#import <axe_schema_ios/DSSchemaValidationResult.h>

@interface DSSubTxTests : DSBaseTest

@end

@implementation DSSubTxTests

- (void)testValidateSubTxHash {
    // TODO: fix me (same as in Android Axe Schema)
    NSDictionary *aliceSubTx = self.data[@"alice_subtx_1"];
    XCTAssertNotNil(aliceSubTx);
    
    NSString *aliceId = aliceSubTx[@"subtx"][@"meta"][@"id"];
    XCTAssertNotNil(aliceId);
    
    NSString *calculatedAliceId = [DSSchemaHash subTx:aliceSubTx];
    
    XCTAssertEqualObjects(aliceId, calculatedAliceId);
}

- (void)testValidateSubTxHashFake {
    NSDictionary *aliceSubTx = self.data[@"alice_subtx_1"];
    XCTAssertNotNil(aliceSubTx);
    
    NSString *aliceId = @"e2b72d50f1e12ac0a849d3ed53b470d9d70d3bd5dd8c5037d565e6b763b36d4e"; //aliceSubTx[@"subtx"][@"meta"][@"id"];
    XCTAssertNotNil(aliceId);
    
    NSString *calculatedAliceId = [DSSchemaHash subTx:aliceSubTx];
    
    XCTAssertEqualObjects(aliceId, calculatedAliceId);
}

- (void)testSubTxRawValidSubTx {
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"valid_subtx"
                                                          withExtension:@"json"
                                                           subdirectory:nil];
    NSParameterAssert(url);
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSParameterAssert(data);
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
    NSParameterAssert(json);

    DSSchemaValidationResult *result = [DSSchemaValidator validateSubTx:json];
    
    XCTAssertTrue(result.valid);
}

@end
