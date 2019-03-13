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

#import "DSSchemaModelBuilder.h"

#import "DSSchemaStorage.h"
#import "NSEntityDescription+DSSchema.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSSchemaModelBuilder ()

@property (strong, nonatomic) NSMutableArray<NSEntityDescription *> *entities;

@end

@implementation DSSchemaModelBuilder

- (instancetype)init {
    self = [super init];
    if (self) {
        _entities = [NSMutableArray array];
    }
    return self;
}

- (void)addSTHeaderEntity {
    NSEntityDescription *entity = [[NSEntityDescription alloc] initWithName:@"stheader"
                                                            modelDictionary:[self stHeaderObjectModel]];
    [self.entities addObject:entity];
}

- (void)addSTPacketEntity {
    NSEntityDescription *entity = [[NSEntityDescription alloc] initWithName:@"stpacket"
                                                            modelDictionary:[self stPacketObjectModel]];
    [self.entities addObject:entity];
}

- (void)addDAPContractEntity {
    NSEntityDescription *entity = [[NSEntityDescription alloc] initWithName:@"dapcontract"
                                                            modelDictionary:[self dapContractObjectModel]];
    [self.entities addObject:entity];
}

- (void)addDAPObjectEntityWithTypeName:(NSString *)typeName {
    NSEntityDescription *entity = [[NSEntityDescription alloc] initWithName:typeName
                                                            modelDictionary:[self dapObjectObjectModel]];
    [self.entities addObject:entity];
}

- (void)addBlockchainUserEntity {
    NSEntityDescription *entity = [[NSEntityDescription alloc] initWithName:@"blockchainuser"
                                                            modelDictionary:[self blockchainUserObjectModel]];
    [self.entities addObject:entity];
}

- (void)addCustomEntityName:(NSString *)name objectModel:(NSDictionary<NSString *, id> *)objectModel {
    NSEntityDescription *entity = [[NSEntityDescription alloc] initWithName:name
                                                            modelDictionary:objectModel];
    [self.entities addObject:entity];
}

- (NSManagedObjectModel *)buildManagedObjectModel {
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
    model.entities = [[NSArray alloc] initWithArray:self.entities copyItems:YES];
    return model;
}

#pragma mark - Private

- (NSMutableDictionary<NSString *, id> *)baseObjectModel {
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    object[@"pver"] = DSSchemaStorage.system[@"pver"] ?: @1;
    return object;
}

- (NSMutableDictionary<NSString *, id> *)stHeaderObjectModel {
    NSMutableDictionary *object = [self baseObjectModel];
    object[@"feeperbyte"] = @0;      // blockchainuser fee set for this ts
    object[@"buid"] = @"string";     // blockchainuser id, taken from the tx hash of the blockchainuser's first subtx
    object[@"prevstid"] = @"string"; // hash of the previous transition for this blockchainuser (chained)
    object[@"packetid"] = @"string"; // hash of the associated data packet for this transition
    object[@"stsig"] = @"string";    // sig of the blockchainuser & the dapi quorum that validated the transition data
    object[@"nver"] = @1;
    object[@"packetsize"] = @1;
    object[@"id"] = @"string";
    return object;
}

- (NSMutableDictionary<NSString *, id> *)stPacketObjectModel {
    NSMutableDictionary *object = [self baseObjectModel];
    return object;
}

- (NSMutableDictionary<NSString *, id> *)dapContractObjectModel {
    NSMutableDictionary *object = [self baseObjectModel];
    object[@"idx"] = @0;
    object[@"dapname"] = @"string";
    object[@"dapschema"] = @{};
    object[@"packetid"] = @"string";
    object[@"dapver"] = @1;
    object[@"id"] = @"string";
    return object;
}

- (NSMutableDictionary<NSString *, id> *)dapObjectObjectModel {
    NSMutableDictionary *object = [NSMutableDictionary dictionary];
    object[@"objtype"] = @"string";
    object[@"idx"] = @0;
    object[@"rev"] = @0;
    object[@"act"] = @1;
    return object;
}

- (NSMutableDictionary<NSString *, id> *)blockchainUserObjectModel {
    NSMutableDictionary *object = [self baseObjectModel];
    object[@"uname"] = @"string";
    object[@"buid"] = @"string";
    object[@"pubkey"] = @"string";
    object[@"credits"] = @100000;
    return object;
}

@end

NS_ASSUME_NONNULL_END
