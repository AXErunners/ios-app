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

#import <APP/DSSchemaObject.h>

@interface DSSchemaObjectTests : XCTestCase

@property (copy, nonatomic) NSDictionary *dapObject;
@property (copy, nonatomic) NSDictionary *sysObject;

@end

@implementation DSSchemaObjectTests

- (void)setUp {
    self.dapObject = @{ @"someprop": @1 };
    self.sysObject = @{ @"subtx": self.dapObject };
}

- (void)testMetaDataCreate {
    NSDictionary *metaObject = [DSSchemaObject setMetaObject:self.dapObject key:@"somekey" value:@1];
    NSNumber *value = metaObject[@"meta"][@"somekey"];
    XCTAssertEqualObjects(value, @1);
}

- (void)testMetaDataAppend {
    NSDictionary *metaObject = [DSSchemaObject setMetaObject:self.dapObject key:@"somekey" value:@1];
    metaObject = [DSSchemaObject setMetaObject:metaObject key:@"somekey2" value:@2];
    NSNumber *value1 = metaObject[@"meta"][@"somekey"];
    NSNumber *value2 = metaObject[@"meta"][@"somekey2"];
    XCTAssertEqualObjects(value1, @1);
    XCTAssertEqualObjects(value2, @2);
}

- (void)testObjectClassificationSystem {
    BOOL isSystem = [DSSchemaObject isSysObject:self.sysObject];
    XCTAssertTrue(isSystem);
}

- (void)testObjectClassificationSystemInvalid {
    BOOL isSystem = [DSSchemaObject isSysObject:self.dapObject];
    XCTAssertFalse(isSystem);
}

- (void)testObjectClassificationSystemEmpty {
    BOOL isSystem = [DSSchemaObject isSysObject:@{}];
    XCTAssertFalse(isSystem);
}

- (void)testObjectClassificationSystemNil {
    BOOL isSystem = [DSSchemaObject isSysObject:nil];
    XCTAssertFalse(isSystem);
}

- (void)testObjectManipulationPrepareForRemoval {
    NSDictionary *dapObject = @{ DS_REV: @0 };
    NSDictionary *resultObject = [DSSchemaObject prepareForRemoval:dapObject];
    NSNumber *act = resultObject[DS_ACT];
    NSNumber *rev = resultObject[DS_REV];
    XCTAssertEqualObjects(act, @(DS_REMOVE_OBJECT_ACTION));
    XCTAssertEqualObjects(rev, @1);
}

@end
