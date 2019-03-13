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

#import <DSJSONSchemaValidation/NSDictionary+DSJSONDeepMutableCopy.h>

#import <APP/DSSchemaValidationResult.h>
#import <APP/DSSchemaCompile.h>
#import <APP/DSSchemaValidator.h>

@interface DSDapContractTests : DSBaseTest

@property (copy, nonatomic) NSDictionary *dapContract;

@end

@implementation DSDapContractTests

- (NSDictionary *)dapContract {
    if (!_dapContract) {
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"dapcontract"
                                                              withExtension:@"json"
                                                               subdirectory:nil];
        NSParameterAssert(url);
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSParameterAssert(data);
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)kNilOptions error:NULL];
        NSParameterAssert(json);
        
        _dapContract = json;
    }
    return _dapContract;
}

//- (void)testDapContractSchemaValid {
//    // TODO: fix me (same as in Android Axe Schema)
//    DSSchemaValidationResult *result = [DSSchemaCompile compileDAPSchema:self.data];
//    XCTAssertTrue(result.valid);
//}

- (void)testDapContractContainerValid {
    NSMutableDictionary *dapContract = [self.dapContract ds_deepMutableCopy];
    NSMutableDictionary *dapContractObject = dapContract[@"dapcontract"];
    dapContractObject[@"dapschema"] = self.data;
    
    DSSchemaValidationResult *result = [DSSchemaValidator validateDapContract:dapContract];
    XCTAssertTrue(result.valid);
}

@end
