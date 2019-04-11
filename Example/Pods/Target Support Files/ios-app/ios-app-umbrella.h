#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AxePlatformProtocol.h"
#import "appSerializableObject.h"
#import "appTypes.h"
#import "DPBaseObject.h"
#import "DPContract.h"
#import "DPContractFacade.h"
#import "DPContractFactory+CreateContract.h"
#import "DPContractFactory.h"
#import "DPContractFactoryProtocol.h"
#import "DPDocument.h"
#import "DPDocumentFacade.h"
#import "DPDocumentFactory.h"
#import "DPDocumentFactoryProtocol.h"
#import "DPBase58DataEncoder.h"
#import "DPEntropyProvider.h"
#import "DPErrors.h"
#import "DPMerkleRootOperation.h"
#import "DPSTPacket+HashCalculations.h"
#import "DPSTPacket.h"
#import "DPSTPacketFacade.h"
#import "DPSTPacketFactory.h"
#import "DPSTPacketFactoryProtocol.h"
#import "DPSTPacketHeader.h"
#import "DPSTPacketHeaderFacade.h"
#import "DPSTPacketHeaderFactory.h"
#import "DPSTPacketHeaderFactoryProtocol.h"
#import "DPSerializeUtils.h"
#import "NSBundle+app.h"
#import "NSData+DPSchemaUtils.h"

FOUNDATION_EXPORT double APPVersionNumber;
FOUNDATION_EXPORT const unsigned char APPVersionString[];

