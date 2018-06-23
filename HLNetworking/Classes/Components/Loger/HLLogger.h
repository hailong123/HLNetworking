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
#import "HLLoggerConfiguration.h"

@interface HLLogger : NSObject

@property (nonatomic, copy, readonly) HLLoggerConfiguration *configParams;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NSString *)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                    responseData:(id)responseData
                         request:(NSURLRequest *)request
                           error:(NSError *)error;

+ (void)logDebugInfoWithCacheResponse:(HLURLResponse *)response
                           methodName:(NSString *)methodName;

+ (instancetype)shareInstance;

@end
