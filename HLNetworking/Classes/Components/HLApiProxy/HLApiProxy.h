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

typedef void(^HLCallBack)(HLURLResponse *response);

@interface HLApiProxy : NSObject

+ (instancetype)shareInstance;

- (NSInteger)callGETMethodWithParams:(NSDictionary *)params
                          methodName:(NSString *)methodName
                             success:(HLCallBack)success
                                fail:(HLCallBack)fail;

- (NSInteger)callPOSTMethodWithParams:(NSDictionary *)params
                           methodName:(NSString *)methodName
                              success:(HLCallBack)success
                                 fail:(HLCallBack)fail;

- (NSInteger)callPUTMethodWithParams:(NSDictionary *)params
                          methodName:(NSString *)methodName
                             success:(HLCallBack)success
                                fail:(HLCallBack)fail;

- (NSInteger)callDELETEMethodWithParams:(NSDictionary *)params
                             methodName:(NSString *)methodName
                                success:(HLCallBack)success
                                   fail:(HLCallBack)fail;

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request
                         success:(HLCallBack)success
                            fail:(HLCallBack)fail;


- (void)cancelAllRequest;
- (void)cancelRequestWithRequestID:(NSNumber *)requestId;

@end
