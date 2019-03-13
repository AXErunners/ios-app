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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const DSValidationResultErrorDomain;

typedef NS_ENUM(NSUInteger, DSValidationResultErrorCode) {
    DSValidationResultErrorCodeUnknown = 0,
    //    DSValidationResultErrorCodeJSONSchema = 100,
    DSValidationResultErrorCodeMissingDAPSchema = 150,
    DSValidationResultErrorCodeDAPObjectMissingObjType = 200,
    DSValidationResultErrorCodeDAPObjectUnknownObjType = 201,
    DSValidationResultErrorCodeDAPObjectMissingSubschema = 300,
    //    DSValidationResultErrorCodeDAPObjectMissingProperty = 400,
    //    DSValidationResultErrorCodeDAPObjectInvalidType = 401,
    DSValidationResultErrorCodeInvalidID = 500,
    DSValidationResultErrorCodeInvalidSchemaTitle = 501,
    DSValidationResultErrorCodeInvalidDAPSubschemaCount = 510,
    DSValidationResultErrorCodeInvalidDAPSubschemaName = 511,
    DSValidationResultErrorCodeReservedDAPSubschemaName = 512,
    DSValidationResultErrorCodeDAPSubschemaInheritance = 530,
    DSValidationResultErrorCodeMissingTitle = 600,
};

@interface DSSchemaValidationResult : NSObject

@property (readonly, assign, nonatomic) BOOL valid;
@property (nullable, readonly, strong, nonatomic) NSError *error;
@property (nullable, readonly, copy, nonatomic) NSString *objType;
@property (nullable, readonly, copy, nonatomic) NSString *propName;
@property (nullable, readonly, copy, nonatomic) NSString *schemaName;

- (instancetype)initAsValid;

- (instancetype)initWithErrorCode:(DSValidationResultErrorCode)errorCode
                          objType:(nullable NSString *)objType
                         propName:(nullable NSString *)propName
                       schemaName:(nullable NSString *)schemaName;

- (instancetype)initWithError:(NSError *)error
                      objType:(nullable NSString *)objType
                     propName:(nullable NSString *)propName
                   schemaName:(nullable NSString *)schemaName;

@end

NS_ASSUME_NONNULL_END
