//
//  HLNetworkConfig.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
    用途:此文件用于配置网络的相关信息配置
 */

#import <Foundation/Foundation.h>

@interface HLNetworkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

+ (HLNetworkConfig *)shareConfig;

@property (nonatomic, copy) NSString *baseUrl;    //基地址
@property (nonatomic, copy) NSString *cdnsUrl;    //cdn基地址
@property (nonatomic, copy) NSString *apiVersion; //后台版本号

@property (nonatomic, copy) NSDictionary *commonHeaderFiledDic;// HTTP header

@end
