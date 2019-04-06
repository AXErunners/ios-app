//
//  DSDAPObjectsFactory.h
//  DSJSONSchemaValidation
//
//  Created by Andrew Podkovyrin on 14/03/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSDAPObjectsFactory : NSObject

+ (NSMutableDictionary<NSString *, id> *)createSTPacketInstance;
+ (NSMutableDictionary<NSString *, id> *)createDAPObjectForTypeName:(NSString *)typeName;

@end

NS_ASSUME_NONNULL_END
