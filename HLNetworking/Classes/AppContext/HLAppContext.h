//
//  HLAppContext.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
    用途: 此文件包含 App相关的所有信息,外部想要获取相关信息,可通过此类进行获取
*/

#import <Foundation/Foundation.h>

#import "HLNetworkingConfiguration.h"

@interface HLAppContext : NSObject

//凡是未声明 readonly 属性的都需要在初始化的时候由外部给提供

//设备的信息
@property (nonatomic, copy, readonly) NSString *os;
@property (nonatomic, copy, readonly) NSString *rom;
@property (nonatomic, copy, readonly) NSString *ppi;
@property (nonatomic, copy, readonly) NSString *imei;
@property (nonatomic, copy, readonly) NSString *imsi;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *model;
@property (nonatomic, copy, readonly) NSString *deviceName;

@property (nonatomic, assign, readonly) CGSize resolution;

//运行环境相关
@property (nonatomic, assign, readonly) BOOL isReachable;

//用户token相关
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, assign, readonly) NSTimeInterval lastRefreshTime;

//用户信息
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, assign, readonly, getter=isLoginIn) BOOL loginIn;

//App信息
@property (nonatomic, copy, readonly) NSString *sessionID;
@property (nonatomic, copy, readonly) NSString *appVersion;

//推送相关
@property (nonatomic, strong) NSData *deviceTokenData;
@property (nonatomic, copy) NSString *deviceToken;

//地理位置相关
@property (nonatomic, assign, readonly) CGFloat latitude;
@property (nonatomic, assign, readonly) CGFloat longitude;

+ (instancetype)shareInstance;

- (void)cleanUserInfo;
- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken;

- (void)appEnded;
- (void)appStarted;

@end
