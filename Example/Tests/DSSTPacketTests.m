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

#import <DSJSONSchemaValidation/NSDictionary+DSJSONDeepMutableCopy.h>
#import <APP/DSJSONSchema+AxeSchema.h>
#import <APP/DSSchemaValidationResult.h>
#import <APP/DSSchemaValidator.h>
#import <APP/DSSchemaObject.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSSTPacketTests : XCTestCase

@property (copy, nonatomic) NSDictionary *dapSchema;
@property (copy, nonatomic) NSDictionary *testData;

@end

@implementation DSSTPacketTests

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

- (NSDictionary *)testData {
    if (!_testData) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"stpacket-test-data"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);
        
        _testData = json;
    }
    return _testData;
}

- (void)testDapContractObject {
    NSMutableDictionary *object = [self.testData[@"dapcontract_object"] ds_deepMutableCopy];
    NSMutableDictionary *dapcontract = object[@"dapcontract"];
    dapcontract[@"dapschema"] = self.dapSchema;
    
    DSSchemaValidationResult *result = [DSSchemaValidator validateDapContract:object];
    XCTAssertTrue(result.valid);
}

//- (void)testDapSpaceValidPacket {
//    // TODO: fix me (same as in Android Axe Schema)
//    NSDictionary *object = self.testData[@"dapspace_valid_packet"];
//    DSSchemaValidationResult *result = [DSSchemaValidator validateSTPacketObject:object dapSchema:self.dapSchema];
//    XCTAssertTrue(result.valid);
//}

- (void)testDapSpaceMissingList {
    NSDictionary *object = self.testData[@"dapspace_missing_list"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateSTPacketObject:object dapSchema:self.dapSchema];
    XCTAssertFalse(result.valid);
}

- (void)testPacketCreationFilterAdditionalFields {
    NSDictionary *object = self.testData[@"packet_creation_filter_additional_fields"];
    NSMutableDictionary *schemaObject = [[DSSchemaObject fromObject:object dapSchema:nil] ds_deepMutableCopy];
    NSDictionary *dapContract = [DSSchemaObject fromObject:schemaObject[@"stpacket"][@"dapcontract"] dapSchema:nil];
    NSMutableDictionary *stPacket = schemaObject[@"stpacket"];
    stPacket[@"dapcontract"] = dapContract;
    
    XCTAssertNil(schemaObject[@"stpacket"][@"unknown1"]);
    XCTAssertNil(schemaObject[@"stpacket"][@"dapcontract"][@"unknown2"]);
}

- (void)testPacketInstanceValidDapContract {
    NSDictionary *object = self.testData[@"packet_instance_valid_dapcontract"];
    DSSchemaValidationResult *result = [self validateAgainstSystemSchema:object];
    XCTAssertTrue(result.valid);
}

- (void)testPacketInstanceInvalidDapObjectsPacket {
    NSDictionary *object = self.testData[@"packet_instance_invalid_dapobjects"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateSTPacketObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testPacketInstanceInvalidMultiplePacket {
    NSDictionary *object = self.testData[@"packet_instance_invalid_multiple_packet"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateSTPacketObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

- (void)testPacketInstanceInvalidEmptyPacket {
    NSDictionary *object = self.testData[@"packet_instance_invalid_empty_packet"];
    DSSchemaValidationResult *result = [DSSchemaValidator validateSTPacketObject:object dapSchema:nil];
    XCTAssertFalse(result.valid);
}

#pragma mark - Private

- (DSSchemaValidationResult *)validateAgainstSystemSchema:(NSDictionary *)object {
    NSError *error = nil;
    __unused DSJSONSchema *schema = [DSJSONSchema axeCustomSchemaWithObject:object
                                                            removeAdditional:NO
                                                                       error:&error];
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

NS_ASSUME_NONNULL_END
