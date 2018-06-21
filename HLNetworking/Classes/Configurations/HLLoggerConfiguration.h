//
//  HLLoggerConfiguration.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
    用途:用来配置APP打印
 */

#import <Foundation/Foundation.h>

#import "HLAppContext.h"

@interface HLLoggerConfiguration : NSObject

/** 渠道ID */
@property (nonatomic, copy) NSString *channleID;

/** app标志 */
@property (nonatomic, copy) NSString *appKey;

/** app名称 */
@property (nonatomic, copy) NSString *logAppName;

/** 服务名称 */
@property (nonatomic, copy) NSString *serviceType;

/** 记录log用到的webapp名称 */
@property (nonatomic, copy) NSString *sendLogMethod;

/** 记录action用到的webapp名称 */
@property (nonatomic, copy) NSString *sendActionMethod;

/** 发送log时使用的Key */
@property (nonatomic, copy) NSString *sendLogKey;

/** 发送action时使用的key */
@property (nonatomic, copy) NSString *sendActionKey;

//配置
- (void)configWithAppType:(HLAppType)appType;

@end
