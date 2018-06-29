//
//  HLLogger.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//
/*
 用途:打印日志
 */

#import <Foundation/Foundation.h>

#import "HLURLResponse.h"

@interface HLLogger : NSObject

/** 实例化 HLLogger 实例 */
+ (instancetype)shareInstance;

/**
 描述:用于输出日志
 @param request       打印的当前request
        apiName       请求名称
        requestParams 请求参数
        httpMethod    请求方法
 
 */
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NSString *)httpMethod;

/**
 描述:用于输出响应日志
 @param response        打印的当前响应
        responseData    响应数据
        request         当前请求
        error           错误信息
 */
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                    responseData:(id)responseData
                         request:(NSURLRequest *)request
                           error:(NSError *)error;

/**
 描述:用于输出缓存数据
 @params response   接口响应数据
         methodName 请求方法
 */
+ (void)logDebugInfoWithCacheResponse:(HLURLResponse *)response
                           methodName:(NSString *)methodName;

@end
