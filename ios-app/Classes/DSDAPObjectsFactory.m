//
//  DSDAPObjectsFactory.m
//  DSJSONSchemaValidation
//
//  Created by Andrew Podkovyrin on 14/03/2019.
//

#import "DSDAPObjectsFactory.h"

#import "DSSchemaObject.h"
#import "DSSchemaStorage.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *PVER = @"pver";

@implementation DSDAPObjectsFactory

+ (NSMutableDictionary<NSString *, id> *)createSTPacketInstance {
    NSMutableDictionary<NSString *, id> *object = [self createBaseInstanceWithKeyword:DS_STPACKET];
    
    return object;
}

+ (NSMutableDictionary<NSString *, id> *)createDAPObjectForTypeName:(NSString *)typeName {
    NSParameterAssert(typeName);

    NSMutableDictionary<NSString *, id> *object = [NSMutableDictionary dictionary];
    object[DS_OBJTYPE] = typeName;
    object[@"idx"] = @0;
    object[DS_REV] = @0;
    object[DS_ACT] = @(DS_CREATE_OBJECT_ACTION);
    
    return object;
}

#pragma mark - Private

+ (NSMutableDictionary<NSString *, id> *)createBaseInstanceWithKeyword:(NSString *)keyword {
    NSParameterAssert(keyword);

    NSDictionary<NSString *, id> *schema = DSSchemaStorage.system;
    NSMutableDictionary<NSString *, id> *object = [NSMutableDictionary dictionary];
    object[keyword] = @{
        PVER : schema[PVER],
    };
    
    return object;
}

@end

NS_ASSUME_NONNULL_END
