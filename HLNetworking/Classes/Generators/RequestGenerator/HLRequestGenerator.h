//
//  HLRequestGenerator.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
 用途:用于生成请求方法
 */

#import <Foundation/Foundation.h>

@interface HLRequestGenerator : NSObject

+ (HLRequestGenerator *)shareInstance;

- (NSURLRequest *)generateGETRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName;

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams
                                            methodName:(NSString *)methodName;

- (NSURLRequest *)generatePUTRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName;

- (NSURLRequest *)generateDELETERequestWithRequestParams:(NSDictionary *)requestParams
                                              methodName:(NSString *)methodName;

@end
