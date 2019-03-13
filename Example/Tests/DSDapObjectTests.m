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

#import <APP/DSSchemaValidationResult.h>
#import <APP/DSSchemaValidator.h>

@interface DSDapObjectTests : XCTestCase

@property (copy, nonatomic) NSDictionary *dapObjects;
@property (copy, nonatomic) NSDictionary *dapSchema;

@end

@implementation DSDapObjectTests

- (NSDictionary *)dapObjects {
    if (!_dapObjects) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"dapobjects"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _dapObjects = json;
    }
    return _dapObjects;
}

- (NSDictionary *)dapSchema {
    if (!_dapSchema) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"somedap"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _dapSchema = json;
    }
    return _dapSchema;
}

- (void)testValidDapObjects_validDapObject1 {
    NSDictionary *dapObject = self.dapObjects[@"valid_dapobject_1"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
    XCTAssertTrue(result.valid);
}

- (void)testValidDapObjects_validDapObject2 {
    NSDictionary *dapObject = self.dapObjects[@"valid_dapobject_2"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
    XCTAssertTrue(result.valid);
}

- (void)testProperties_additionalProperties {
    NSDictionary *dapObject = self.dapObjects[@"additional_properties"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
    XCTAssertTrue(result.valid);
}

//- (void)testProperties_missingInheritedProperties {
//    // TODO: fix me (same as in Android Axe Schema)
//    NSDictionary *dapObject = self.dapObjects[@"missing_inherited_properties"];
//    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
//    XCTAssertFalse(result.valid);
//}

//- (void)testProperties_missingLocalProperties {
//    // TODO: fix me (same as in Android Axe Schema)
//    NSDictionary *dapObject = self.dapObjects[@"missing_local_properties"];
//    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
//    XCTAssertFalse(result.valid);
//}

- (void)testDapObjectType_missingObjectType {
    NSDictionary *dapObject = self.dapObjects[@"missing_object_type"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeDAPObjectMissingObjType);
}

- (void)testDapObjectType_unknownObjectType {
    NSDictionary *dapObject = self.dapObjects[@"unknown_object_type"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeDAPObjectUnknownObjType);
}

//- (void)testDapObjectType_mismatchedObjectType {
//    // TODO: fix me (same as in Android Axe Schema)
//    NSDictionary *dapObject = self.dapObjects[@"mismatched_object_type"];
//    DSSchemaValidationResult *result = [DSSchemaValidator validateDapObject:dapObject dapSchema:self.dapSchema];
//    XCTAssertFalse(result.valid);
//}

@end
