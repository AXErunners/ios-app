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

#import <APP/DSJSONSchema+AxeSchema.h>
#import <APP/DSSchemaValidationResult.h>

/**
 *  Here we test JSON schema draft compatibility with Axe schema patterns
 *  using a simplified inline Axe System schema and later with a single extended DAP schema
 *
 *  Current JSON schema spec is draft #7:
 *  http://json-schema.org/draft-07/schema#
 *
 *  NOTES:
 *
 *  - additionalProperties keyword is used for System and Dap Schema root properties but not for subschemas
 *    this means objects can have additional properties and still validate, therefore the pattern is to ignore
 *    additional properties not specified in the schema in consensus code
 *
 *  - ...we use $ref and definitions section for schema inheritance
 */

@interface DSJsonSchemaTests : XCTestCase

@property (copy, nonatomic) NSDictionary *dapSchemaData;
@property (strong, nonatomic) DSJSONSchema *dapSchema;
@property (copy, nonatomic) NSDictionary *simplifiedSystemSchemaData;
@property (strong, nonatomic) DSJSONSchema *simplifiedSystemSchema;
@property (copy, nonatomic) NSDictionary *data;

@end

@implementation DSJsonSchemaTests

- (NSDictionary *)dapSchemaData {
    if (!_dapSchemaData) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"simplified-dap-schema"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _dapSchemaData = json;
    }
    return _dapSchemaData;
}

- (DSJSONSchema *)dapSchema {
    if (!_dapSchema) {
        NSError *error = nil;
        _dapSchema = [DSJSONSchema axeCustomSchemaWithObject:self.dapSchemaData
                                             removeAdditional:NO
                                                        error:&error];
        NSAssert(!error, @"Invalid schema");
    }
    return _dapSchema;
}

- (NSDictionary *)simplifiedSystemSchemaData {
    if (!_simplifiedSystemSchemaData) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"simplified-system-schema"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);

        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);

        _simplifiedSystemSchemaData = json;
    }
    return _simplifiedSystemSchemaData;
}

- (DSJSONSchema *)simplifiedSystemSchema {
    if (!_simplifiedSystemSchema) {
        NSError *error = nil;
        _simplifiedSystemSchema = [DSJSONSchema axeCustomSchemaWithObject:self.simplifiedSystemSchemaData
                                                          removeAdditional:NO
                                                                     error:&error];
        NSAssert(!error, @"Invalid schema");
    }
    return _simplifiedSystemSchema;
}

- (NSDictionary *)data {
    if (!_data) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"jsonschema-test-data"
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

- (void)testSystemSchemaValidInheritedSysObject {
    NSDictionary *object = self.data[@"valid_inherited_sys_object"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

- (void)testSystemSchemaMissingRequiredField {
    NSDictionary *object = self.data[@"missing_required_field"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaMissingRequiredFieldInSuper {
    NSDictionary *object = self.data[@"missing_required_field_in_super"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaMissingRequiredFieldInBase {
    NSDictionary *object = self.data[@"missing_required_field_in_base"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaNoValidSchema {
    NSDictionary *object = self.data[@"no_valid_schema"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaPreventAdditionalPropertiesInMainSysSchema {
    NSDictionary *object = self.data[@"additional_properties_in_main_schema"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaAllowAdditionalPropertiesInSysSubschemas {
    NSDictionary *object = self.data[@"additional_properties_is_sys_subschema"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

- (void)testSystemSchemaContainersValidContainer {
    NSDictionary *object = self.data[@"valid_container"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

- (void)testSystemSchemaContainersMissingList {
    NSDictionary *object = self.data[@"missing_list"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersNullList {
    NSDictionary *object = self.data[@"null_list"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersEmptyList {
    NSDictionary *object = self.data[@"empty_list"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersIncorrectItemType {
    NSDictionary *object = self.data[@"incorrect_item_type"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersMissingArrayItemRequiredField {
    NSDictionary *object = self.data[@"missing_array_item_required_field"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersMissingArrayItemRequiredBaseField {
    NSDictionary *object = self.data[@"missing_array_item_required_base_field"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersPreventMultipleSubschemaTypeDefinitions {
    NSDictionary *object = self.data[@"prevent_multiple_subschematype_definitions"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testSystemSchemaContainersPreventDuplicateItems {
    NSDictionary *object = self.data[@"prevent_duplicate_items"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

//- (void)testDapContractSchemaValidDapContractObject {
//    // TODO: fix me (same as in Android Axe Schema)
//    NSDictionary *object = self.data[@"valid_dapcontract_object"];
//    DSSchemaValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
//    XCTAssertTrue(result.valid);
//}

- (void)testDapContractSchemaMissingRequiredField {
    NSDictionary *object = self.data[@"dapobject_missing_required_field"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaMissingRequiredFieldInSuper {
    NSDictionary *object = self.data[@"dapobject_missing_required_field_in_super1"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaMissingRequiredFieldInBase {
    NSDictionary *object = self.data[@"dapobject_missing_required_field_in_base"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testDapContractSchemaPreventAdditionalPropertiesInMainDapContractSchema {
    NSDictionary *object = self.data[@"prevent_additional_properties_in_main_dapcontract_schema"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

//- (void)testDapContractSchemaAllowAdditionalPropertiesInDapContractSubSchemas {
//    // TODO: fix me (same as in Android Axe Schema)
//    NSDictionary *object = self.data[@"allow_additional_properties_in_dapcontract_subschemas"];
//    DSSchemaValidationResult *result = [self validateObject:object dapSchema:self.dapSchema];
//    XCTAssertTrue(result.valid);
//}

//- (void)testDapContractObjectContainerValid {
//    NSDictionary *object = self.data[@"dapcontract_object_container"];
//    DSSchemaValidationResult *result1 = [self validateObject:object dapSchema:nil];
//    XCTAssertTrue(result1.valid);
//
//    // TODO: fix me (same as in Android Axe Schema)
//    DSSchemaValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
//    XCTAssertTrue(result2.valid);
//}

- (void)testDapContractObjectContainerMissingList {
    NSDictionary *object = self.data[@"dapcontract_missing_list"];
    DSJSONSchema *schema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    NSError *error = nil;
    [schema validateObject:object withError:&error];
    XCTAssertNotNil(error);
}

- (void)testDapContractObjectContainerEmptyList {
    NSDictionary *object = self.data[@"dapcontract_empty_list"];
    DSJSONSchema *schema = [DSJSONSchema systemSchemaRemoveAdditional:NO];
    NSError *error = nil;
    [schema validateObject:object withError:&error];
    XCTAssertNotNil(error);
}

- (void)testDapContractObjectContainerIncorrectItemType {
    NSDictionary *object = self.data[@"dapcontract_incorrect_item_type"];
    DSSchemaValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    DSSchemaValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

- (void)testDapContractObjectContainerMissingArrayItemRequiredField {
    NSDictionary *object = self.data[@"dapcontract_missing_array_item_required_field"];
    DSSchemaValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    DSSchemaValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

- (void)testDapContractObjectContainerMissingArrayItemRequiredBaseField {
    NSDictionary *object = self.data[@"dapcontract_missing_array_item_required_base_field"];
    DSSchemaValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertFalse(result1.valid);
    
    DSSchemaValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

//- (void)testDapContractObjectContainerPreventMultipleSubSchemaTypeDefinitions {
//    NSDictionary *object = self.data[@"dapcontract_prevent_multiple_subschematype_definitions"];
//    DSSchemaValidationResult *result1 = [self validateObject:object dapSchema:nil];
//    XCTAssertTrue(result1.valid);
//
//    // TODO: fix me (same as in Android Axe Schema)
//    DSSchemaValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
//    XCTAssertTrue(result2.valid);
//
//    DSSchemaValidationResult *result3 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:1];
//    XCTAssertFalse(result3.valid);
//}

- (void)testDapContractObjectContainerPreventAdditionalItemTypes {
    NSDictionary *object = self.data[@"dapcontract_prevent_additional_item_types"];
    DSSchemaValidationResult *result1 = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result1.valid);
    
    DSSchemaValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
    XCTAssertFalse(result2.valid);
}

//- (void)testDapContractObjectContainerPreventDuplicateItems {
//    NSDictionary *object = self.data[@"dapcontract_prevent_duplicate_items"];
//    DSSchemaValidationResult *result1 = [self validateObject:object dapSchema:nil];
//    XCTAssertFalse(result1.valid);
//    
//    // TODO: fix me (same as in Android Axe Schema)
//    DSSchemaValidationResult *result2 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:0];
//    XCTAssertTrue(result2.valid);
//    
//    // TODO: fix me (same as in Android Axe Schema)
//    DSSchemaValidationResult *result3 = [self validateDapObjectAgainstDapSchema:object dapObjectIndex:1];
//    XCTAssertTrue(result3.valid);
//}

- (void)testSysmodContainerValid {
    NSDictionary *object = self.data[@"sysmod_container_valid"];
    DSSchemaValidationResult *result = [self validateObject:object dapSchema:nil];
    XCTAssertTrue(result.valid);
}

#pragma mark - Private

- (DSSchemaValidationResult *)validateObject:(NSDictionary *)object dapSchema:(nullable DSJSONSchema *)dapSchema {
    DSJSONSchema *schema = dapSchema ?: self.simplifiedSystemSchema;

    NSError *error = nil;
    [schema validateObject:object withError:&error];

    if (error) {
        return [[DSSchemaValidationResult alloc] initWithError:error objType:nil propName:nil schemaName:nil];
    }
    else {
        return [[DSSchemaValidationResult alloc] initAsValid];
    }
}

- (DSSchemaValidationResult *)validateDapObjectAgainstDapSchema:(NSDictionary *)object dapObjectIndex:(NSUInteger)dapObjectIndex {
    NSDictionary *dapObjectContainer = object[@"dapobjectcontainer"];
    NSParameterAssert(dapObjectContainer);
    NSArray *dapObjects = dapObjectContainer[@"dapobjects"];
    NSParameterAssert(dapObjects);
    NSDictionary *dapObject = dapObjects[dapObjectIndex];
    NSParameterAssert(dapObject);

    NSError *error = nil;
    [self.dapSchema validateObject:dapObject withError:&error];

    if (error) {
        return [[DSSchemaValidationResult alloc] initWithError:error
                                                 objType:nil
                                                propName:nil
                                              schemaName:nil];
    }
    else {
        return [[DSSchemaValidationResult alloc] initAsValid];
    }
}

@end
