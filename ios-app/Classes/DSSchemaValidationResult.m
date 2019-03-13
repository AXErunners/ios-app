//
//  Created by Andrew Podkovyrin
//
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

#import "DSSchemaValidationResult.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const DSValidationResultErrorDomain = @"DSValidationResultErrorDomain";

@implementation DSSchemaValidationResult

- (instancetype)initAsValid {
    self = [super init];
    if (self) {
        _valid = YES;
    }
    return self;
}

- (instancetype)initWithErrorCode:(DSValidationResultErrorCode)errorCode
                          objType:(nullable NSString *)objType
                         propName:(nullable NSString *)propName
                       schemaName:(nullable NSString *)schemaName {
    NSError *error = [self.class errorByCode:errorCode propName:propName];
    return [self initWithError:error objType:objType propName:propName schemaName:schemaName];
}

- (instancetype)initWithError:(NSError *)error
                      objType:(nullable NSString *)objType
                     propName:(nullable NSString *)propName
                   schemaName:(nullable NSString *)schemaName {
    self = [super init];
    if (self) {
        _error = error;
        _objType = [objType copy];
        _propName = [propName copy];
        _schemaName = [schemaName copy];
    }
    return self;
}


/**
 Create error class

 @param errorCode An error code value
 @param propName Used only for the `DSValidationResultErrorCodeInvalidID` code
 @return An instance of error
 */
+ (NSError *)errorByCode:(DSValidationResultErrorCode)errorCode propName:(nullable NSString *)propName {
    NSString *localizedDescription = nil;
    switch (errorCode) {
        case DSValidationResultErrorCodeUnknown: {
            localizedDescription = NSLocalizedString(@"Unknown error", nil);
            break;
        }
        //        case DSValidationResultErrorCodeJSONSchema: {
        //            localizedDescription = NSLocalizedString(@"JSON Schema Error", nil);
        //            break;
        //        }
        case DSValidationResultErrorCodeMissingDAPSchema: {
            localizedDescription = NSLocalizedString(@"Missing DAP Schema", nil);
            break;
        }
        case DSValidationResultErrorCodeDAPObjectMissingObjType: {
            localizedDescription = NSLocalizedString(@"Missing objtype property", nil);
            break;
        }
        case DSValidationResultErrorCodeDAPObjectUnknownObjType: {
            localizedDescription = NSLocalizedString(@"Missing objtype keyword in dap object instance", nil);
            break;
        }
        case DSValidationResultErrorCodeDAPObjectMissingSubschema: {
            localizedDescription = NSLocalizedString(@"Missing subcschema", nil);
            break;
        }
        //        case DSValidationResultErrorCodeDAPObjectMissingProperty: {
        //            localizedDescription = NSLocalizedString(@"Missing property", nil);
        //            break;
        //        }
        //        case DSValidationResultErrorCodeDAPObjectInvalidType: {
        //            localizedDescription = NSLocalizedString(@"Invalid type", nil);
        //            break;
        //        }
        case DSValidationResultErrorCodeInvalidID: {
            localizedDescription = [NSString stringWithFormat:NSLocalizedString(@"DAP Schema must have a valid %@ property", nil), propName];
            break;
        }
        case DSValidationResultErrorCodeInvalidSchemaTitle: {
            localizedDescription = NSLocalizedString(@"Schema must have a valid title", nil);
            break;
        }
        case DSValidationResultErrorCodeInvalidDAPSubschemaCount: {
            localizedDescription = NSLocalizedString(@"Invalid DAP Subschema count", nil);
            break;
        }
        case DSValidationResultErrorCodeInvalidDAPSubschemaName: {
            localizedDescription = NSLocalizedString(@"Invalid DAP Subschema name", nil);
            break;
        }
        case DSValidationResultErrorCodeReservedDAPSubschemaName: {
            localizedDescription = NSLocalizedString(@"Reserved DAP Subschema name", nil);
            break;
        }
        case DSValidationResultErrorCodeDAPSubschemaInheritance: {
            localizedDescription = NSLocalizedString(@"DAP Subschema Inheritance", nil);
            break;
        }
        case DSValidationResultErrorCodeMissingTitle: {
            localizedDescription = NSLocalizedString(@"Missing DAP Schema title", nil);
            break;
        }
    }

    NSError *error = [NSError errorWithDomain:DSValidationResultErrorDomain
                                         code:errorCode
                                     userInfo:localizedDescription ? @{NSLocalizedDescriptionKey : localizedDescription} : nil];

    return error;
}

@end

NS_ASSUME_NONNULL_END
