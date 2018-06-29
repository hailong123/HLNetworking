//
//  HLRequestGenerator.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
    生成请求实例
 */

#import <Foundation/Foundation.h>

@class HLBaseAPIManager;

NS_ASSUME_NONNULL_BEGIN

@interface HLRequestGenerator : NSObject

/**
    描述:生成 GET 方法的URLRequest
    @param requestParams 生成请求的参数
    @param methodName    请求的方法
    @return 返回 NSURLRequest 类型实例
 */
- (NSURLRequest *)generateGETRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName
                                       baseAPIManager:(HLBaseAPIManager *)baseAPIManager;

/**
 描述:生成 POST 方法的URLRequest
 @param requestParams 生成请求的参数
 @param methodName    请求的方法
 @return 返回 NSURLRequest 类型实例
 */
- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams
                                            methodName:(NSString *)methodName
                                        baseAPIManager:(HLBaseAPIManager *)baseAPIManager;

/**
 描述:生成 PUT 方法的URLRequest
 @param requestParams 生成请求的参数
 @param methodName    请求的方法
 @return 返回 NSURLRequest 类型实例
 */
- (NSURLRequest *)generatePUTRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName
                                       baseAPIManager:(HLBaseAPIManager *)baseAPIManager;

/**
 描述:生成 DELETE 方法的URLRequest
 @param requestParams 生成请求的参数
 @param methodName    请求的方法
 @return 返回 NSURLRequest 类型实例
 */
- (NSURLRequest *)generateDELETERequestWithRequestParams:(NSDictionary *)requestParams
                                              methodName:(NSString *)methodName
                                          baseAPIManager:(HLBaseAPIManager *)baseAPIManager;

@end

NS_ASSUME_NONNULL_END
