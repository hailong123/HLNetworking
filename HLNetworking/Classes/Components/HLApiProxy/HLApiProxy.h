//
//  HLApiProxy.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//
/*
 用途:此类用于进行方法调用
 */

#import <Foundation/Foundation.h>

#import "HLURLResponse.h"

@class HLBaseAPIManager;

NS_ASSUME_NONNULL_BEGIN

/** 此回调用于返回请求接口后的数据 */
typedef void(^HLCallBack)(HLURLResponse *response);

@interface HLApiProxy : NSObject

/** 实例化 HLApiProxy 类实例 */
+ (instancetype)shareInstance;

/**
 描述:生成GET请求方法
 @params  params     请求所需的餐宿
          methodName 请求方法
          baseAPIManager 基类的请求
          success        成功请求回调,实现此回调可获取到接口返回数据
          fail           失败请求回调,实现此回调可获取到接口返回数据
 @return 返回 requestID
 */
- (NSInteger)callGETMethodWithParams:(NSDictionary *)params
                          methodName:(NSString *)methodName
                      baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                             success:(HLCallBack)success
                                fail:(HLCallBack)fail;

/**
 描述:生成POST请求方法
 @params  params     请求所需的餐宿
          methodName 请求方法
          baseAPIManager 基类的请求
          success        成功请求回调,实现此回调可获取到接口返回数据
          fail           失败请求回调,实现此回调可获取到接口返回数据
@return 返回 requestID
 */
- (NSInteger)callPOSTMethodWithParams:(NSDictionary *)params
                           methodName:(NSString *)methodName
                       baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                              success:(HLCallBack)success
                                 fail:(HLCallBack)fail;

/**
 描述:生成PUT请求方法
 @params  params     请求所需的餐宿
          methodName 请求方法
          baseAPIManager 基类的请求
          success        成功请求回调,实现此回调可获取到接口返回数据
          fail           失败请求回调,实现此回调可获取到接口返回数据
 @return 返回 requestID
 */
- (NSInteger)callPUTMethodWithParams:(NSDictionary *)params
                          methodName:(NSString *)methodName
                      baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                             success:(HLCallBack)success
                                fail:(HLCallBack)fail;

/**
 描述:生成DELETE请求方法
 @params  params     请求所需的餐宿
          methodName 请求方法
          baseAPIManager 基类的请求
          success        成功请求回调,实现此回调可获取到接口返回数据
          fail           失败请求回调,实现此回调可获取到接口返回数据
 @return 返回 requestID
 */
- (NSInteger)callDELETEMethodWithParams:(NSDictionary *)params
                             methodName:(NSString *)methodName
                         baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                                success:(HLCallBack)success
                                   fail:(HLCallBack)fail;

/** 清除所有发起的请求 */
- (void)cancelAllRequest;

/** 清除指定请求 */
- (void)cancelRequestWithRequestID:(NSNumber *)requestId;

@end

NS_ASSUME_NONNULL_END
