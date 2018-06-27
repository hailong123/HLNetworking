//
//  HLNetworkingConfigurationManager.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
    用途:此文件用于配置网络的相关信息配置
 */

extern NSString * const kNotificationNameErrorCodeNumber;

#import <Foundation/Foundation.h>

@interface HLNetworkingConfigurationManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

+ (HLNetworkingConfigurationManager *)shareConfig;

@property (nonatomic, copy) NSString *baseUrl;    //基地址
@property (nonatomic, copy) NSString *cdnsUrl;    //cdn基地址
@property (nonatomic, copy) NSString *apiVersion; //后台版本号

@property (nonatomic, copy) NSDictionary *commonHeaderFiledDic;// HTTP header

/**
 * 请求配置相关
 */

//Default Value 60s
@property (nonatomic, assign) NSTimeInterval timeoutSeconds;
@property (nonatomic, assign) NSInteger errorCodeNumber;

@property (nonatomic, copy) NSString *errorCodeStr;

@end
