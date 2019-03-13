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

#import <APP/DSSchemaModelBuilder.h>
#import <APP/DSSchemaPersistenceStack.h>
#import <APP/NSEntityDescription+DSSchema.h>

@interface DSSchemaPersistenceTests : XCTestCase

@end

@implementation DSSchemaPersistenceTests

- (void)testSimpleObject {
    NSString *entityName = @"Test";

    NSDictionary<NSString *, id> *objectModel = @{
        @"objtype" : @"someObject1",
        @"idx" : @1,
        @"rev" : @1,
        @"act" : @1,
        @"dapobjectid1" : @1.0,
        @"someAdditionalProp" : @NO,
        @"dictdata" : @{@1 : @"1"},
        @"arrdata" : @[ @1, @2 ],
    };

    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
    NSEntityDescription *inputEntity = [[NSEntityDescription alloc] initWithName:entityName modelDictionary:objectModel];
    model.entities = @[ inputEntity ];

    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Core Data stack initialized correctly"];
    DSSchemaPersistenceStack *stack = [[DSSchemaPersistenceStack alloc] initWithManagedObjectModel:model fileName:@"1"];
    [stack loadStack:^(DSSchemaPersistenceStack *_Nonnull stack) {
        [expectation fulfill];
    }];

    [self waitForExpectations:@[ expectation ] timeout:10.0];

    NSManagedObjectContext *context = stack.persistentContainer.viewContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    XCTAssertNotNil(entity);

    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    [managedObject setValuesForKeysWithDictionary:objectModel];

    NSError *error = nil;
    BOOL result = [context save:&error];
    XCTAssertNil(error);
    XCTAssertTrue(result);

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSManagedObject *fetchedObject = [context executeFetchRequest:fetchRequest error:&error].firstObject;
    XCTAssertNil(error);
    XCTAssertNotNil(fetchedObject);

    NSString *objtype = [fetchedObject valueForKey:@"objtype"];
    XCTAssertEqualObjects(objtype, @"someObject1");

    NSDictionary *dictdata = [fetchedObject valueForKey:@"dictdata"];
    XCTAssertNotNil(dictdata);
}

- (void)testManagedObjectModelBuilder {
    DSSchemaModelBuilder *builder = [[DSSchemaModelBuilder alloc] init];

    NSManagedObjectModel *model = [builder buildManagedObjectModel];
    XCTAssertTrue(model.entities.count == 0);

    [builder addSTHeaderEntity];
    model = [builder buildManagedObjectModel];
    XCTAssertNotNil(model.entitiesByName[@"stheader"]);

    [builder addSTPacketEntity];
    model = [builder buildManagedObjectModel];
    XCTAssertNotNil(model.entitiesByName[@"stpacket"]);

    [builder addDAPContractEntity];
    model = [builder buildManagedObjectModel];
    XCTAssertNotNil(model.entitiesByName[@"dapcontract"]);

    [builder addDAPObjectEntityWithTypeName:@"testdapobject"];
    model = [builder buildManagedObjectModel];
    XCTAssertNotNil(model.entitiesByName[@"testdapobject"]);

    [builder addBlockchainUserEntity];
    model = [builder buildManagedObjectModel];
    XCTAssertNotNil(model.entitiesByName[@"blockchainuser"]);
    
    [builder addCustomEntityName:@"custom" objectModel:@{@"name": @[]}];
    model = [builder buildManagedObjectModel];
    XCTAssertNotNil(model.entitiesByName[@"custom"]);

    XCTAssertTrue(model.entities.count == 6);
}

@end
