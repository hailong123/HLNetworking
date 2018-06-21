//
//  HLNetworkingConfiguration.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
    此文件是全局的配置文件,修改此文件可全局修改网络模块的相关配置
 */

#ifndef HLNetworkingConfiguration_h
#define HLNetworkingConfiguration_h

typedef NS_ENUM (NSInteger, HLAppType) {
    HLAppType_Demo
};

typedef NS_ENUM (NSUInteger, HLURLResponseStatus) {
    HLURLResponseStatusSuccess,       //此状态只表示接收到了服务端的响应,
    HLURLResponseStatusErrorTimeout,  //连接超时
    HLURLResponseStatusErrorNoNetwork //无网络
};

static NSString *HLUDIDName            = @"xxxx";
static NSString *HLPasteboardType      = @"xxxx";
static NSString *HLAccessTokenName     = @"xxxx";
static NSString *HLKeychainServiceName = @"xxxxx";

static NSTimeInterval kHLNetworkingTimeoutSeconds = 60;

#endif /* HLNetworkingConfiguration_h */
