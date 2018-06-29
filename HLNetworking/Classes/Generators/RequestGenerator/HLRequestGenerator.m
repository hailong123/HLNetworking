//
//  HLRequestGenerator.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//

#import "HLRequestGenerator.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#import "HLAppContext.h"
#import "HLBaseAPIManager.h"
#import "HLNetworkingConfigurationManager.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface HLRequestGenerator ()

@end

@implementation HLRequestGenerator

#pragma mark - Private Method

+ (HLRequestGenerator *)shareInstance {
    
    static HLRequestGenerator *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}

- (NSMutableURLRequest *)generateMutableURLReqeustWithMethodName:(NSString *)methodName
                                                      parameters:(NSDictionary *)requestParams
                                                  baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                                                      httpMethod:(NSString *)httpMethod {
    
    NSParameterAssert(methodName);
    NSParameterAssert(httpMethod);
    
    HLNetworkingConfigurationManager *networkConfig = [HLNetworkingConfigurationManager shareConfig];
    
    NSString *urlString = @"";
    
    if (networkConfig.apiVersion.length > 0) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",networkConfig.baseUrl,networkConfig.apiVersion,methodName];
    } else {
        urlString = [NSString stringWithFormat:@"%@/%@",networkConfig.baseUrl,methodName];
    }
    
    
    
    NSMutableURLRequest *request = [[self requestSerializerForRequest:baseAPIManager] requestWithMethod:httpMethod
                                                                                              URLString:urlString
                                                                                             parameters:requestParams
                                                                                                  error:NULL];
    
    [networkConfig.httpHeaderDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    request.requestParams = requestParams;
    
    if ([HLAppContext shareInstance].accessToken) {
        [request setValue:[HLAppContext shareInstance].accessToken
       forHTTPHeaderField:HLAccessTokenName];
    }
    
    return request;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(HLBaseAPIManager *)baseAPIManager {
    
    AFHTTPRequestSerializer *requestSerializer = nil;
    
    if ([baseAPIManager.child requestSerializerType] == HLAPIManagerRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return requestSerializer;
}

#pragma mark - Public Method
- (NSURLRequest *)generateGETRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName
                                       baseAPIManager:(HLBaseAPIManager *)baseAPIManager {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                  baseAPIManager:baseAPIManager
                                                                      httpMethod:@"GET"];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams
                                            methodName:(NSString *)methodName
                                        baseAPIManager:(HLBaseAPIManager *)baseAPIManager {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                  baseAPIManager:baseAPIManager
                                                                      httpMethod:@"POST"];
    return request;
}

- (NSURLRequest *)generatePUTRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName
                                       baseAPIManager:(HLBaseAPIManager *)baseAPIManager {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                  baseAPIManager:baseAPIManager
                                                                      httpMethod:@"PUT"];
    return request;
}

- (NSURLRequest *)generateDELETERequestWithRequestParams:(NSDictionary *)requestParams
                                              methodName:(NSString *)methodName
                                          baseAPIManager:(HLBaseAPIManager *)baseAPIManager {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                  baseAPIManager:baseAPIManager
                                                                      httpMethod:@"DELETE"];
    return request;
}

#pragma mark - Delegate

#pragma mark - Setter And Getter

@end
