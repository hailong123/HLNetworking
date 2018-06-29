//
//  HLNetworkingConfigurationManager.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
    外部可使用此类,进行网络相关的信息配置
 */

extern NSString * const kNotificationNameErrorCodeNumber;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLNetworkingConfigurationManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

/**
    创建 HLNetworkingConfigurationManager 实例
 */

+ (HLNetworkingConfigurationManager *)shareConfig;

/** 用于设置网络的域名/基地址 默认为nil */
@property (nonatomic, copy) NSString *baseUrl;

/** 用于设置网络的cdn地址 默认为nil */
@property (nonatomic, copy) NSString *cdnsUrl;

/** 用户设置后台接口版本号 */
@property (nonatomic, copy) NSString *apiVersion;

/** 设置请求的 请求包头 默认为nil */
@property (nonatomic, copy) NSDictionary *httpHeaderDictionary;

/** 用于设置请求的超时时间 默认为60s */
@property (nonatomic, assign) NSTimeInterval timeoutSeconds;

@end

NS_ASSUME_NONNULL_END
