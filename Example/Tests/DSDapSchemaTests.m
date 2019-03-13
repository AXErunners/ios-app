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

#import <APP/DSSchemaCompile.h>
#import <APP/DSSchemaValidationResult.h>

static NSString *const DAP_SCHEMA_ID_URI = @"http://axe.org/schemas/dapschema";
static NSString *const DAP_OBJECT_BASE_REF = @"http://axe.org/schemas/sys#/definitions/dapobjectbase";

@interface DSDapSchemaTests : XCTestCase

@end

@implementation DSDapSchemaTests

- (void)testInvalidSchema_missingMetaSchema {
    NSDictionary *dapSchema = @{};
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidID);
}

- (void)testInvalidSchema_missingSchemaTitle {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidSchemaTitle);
}

- (void)testInvalidSchema_shortSchemaTitle {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"ab",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidSchemaTitle);
}

- (void)testInvalidSchema_longSchemaTitle {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdefghijklmnopqrstuvwxy",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidSchemaTitle);
}

- (void)testInvalidSubschemaName_noSubSchemas {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidDAPSubschemaCount);
}

- (void)testInvalidSubschemaName_exceedSubSchemasCount {
    NSMutableDictionary *dapSchema = [@{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
    } mutableCopy];
    for (NSUInteger i = 0; i < 1001; i++) {
        dapSchema[[NSString stringWithFormat:@"subschema%ld", i]] = @{};
    }
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidDAPSubschemaCount);
}

- (void)testInvalidSubschemaName_reservedParamsKeyword {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"axe" : @"1",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeReservedDAPSubschemaName);
}

- (void)testInvalidSubschemaName_reservedSysObjectKeyword {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"subtx" : @"1",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeReservedDAPSubschemaName);
}

- (void)testInvalidSubschemaName_reservedSysSchemaKeyword {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"dapobjectbase" : @"1",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeReservedDAPSubschemaName);
}

- (void)testInvalidSubschemaName_disallowedCharacters {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"#" : @"1",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidDAPSubschemaName);
}

- (void)testInvalidSubschemaName_nameBelowMinLength {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"ab" : @"1",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidDAPSubschemaName);
}

- (void)testInvalidSubschemaName_nameAboveMaxLength {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"abcdefghijklmnopqrstuvwxy" : @"1",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeInvalidDAPSubschemaName);
}

- (void)testInvalidSubSchemaContents_missingSubSchemaInheritance {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"someobject" : @"1",
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeDAPSubschemaInheritance);
}

- (void)testInvalidSubSchemaContents_missingAllOf {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"someobject" : @{},
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeDAPSubschemaInheritance);
}

- (void)testInvalidSubSchemaContents_invalidType {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"someobject" : @{
            @"allOf" : DAP_OBJECT_BASE_REF,
        },
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeDAPSubschemaInheritance);
}

- (void)testInvalidSubSchemaContents_missingRef {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"someobject" : @{
            @"allOf" : @[ @{} ],
        },
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeDAPSubschemaInheritance);
}

- (void)testInvalidSubSchemaContents_unknownRef {
    NSDictionary *dapSchema = @{
        @"$id" : DAP_SCHEMA_ID_URI,
        @"title" : @"abcdef",
        @"someobject" : @{
            @"allOf" : @[
                @{
                   @"$ref" : @"unknown",
                },
            ],
        },
    };
    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:dapSchema];
    XCTAssertEqual(result.error.code, DSValidationResultErrorCodeDAPSubschemaInheritance);
}

@end
