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
#import "HLNetworkConfig.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface HLRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation HLRequestGenerator

+ (HLRequestGenerator *)shareInstance {
    
    static HLRequestGenerator *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}

- (NSURLRequest *)generateGETRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                      httpMethod:@"GET"
                                                                    needHttpBody:NO];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams
                                            methodName:(NSString *)methodName {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                      httpMethod:@"POST"
                                                                    needHttpBody:YES];
    return request;
}

- (NSURLRequest *)generatePUTRequestWithRequestParams:(NSDictionary *)requestParams
                                           methodName:(NSString *)methodName {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                      httpMethod:@"PUT"
                                                                    needHttpBody:YES];
    return request;
}

- (NSURLRequest *)generateDELETERequestWithRequestParams:(NSDictionary *)requestParams
                                              methodName:(NSString *)methodName {
    
    NSMutableURLRequest *request = [self generateMutableURLReqeustWithMethodName:methodName
                                                                      parameters:requestParams
                                                                      httpMethod:@"DELETE"
                                                                    needHttpBody:YES];
    return request;
}

- (NSMutableURLRequest *)generateMutableURLReqeustWithMethodName:(NSString *)methodName
                                                      parameters:(NSDictionary *)requestParams
                                                      httpMethod:(NSString *)httpMethod
                                                    needHttpBody:(BOOL)needBody {
    
    NSParameterAssert(methodName);
    
    HLNetworkConfig *networkConfig = [HLNetworkConfig shareConfig];
    
    NSString *urlString = @"";
    
    if (networkConfig.apiVersion.length > 0) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",networkConfig.baseUrl,networkConfig.apiVersion,methodName];
    } else {
        urlString = [NSString stringWithFormat:@"%@/%@",networkConfig.baseUrl,methodName];
    }
    
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:methodName
                                                                       URLString:urlString
                                                                      parameters:requestParams
                                                                           error:NULL];
    
    [networkConfig.commonHeaderFiledDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    if (needBody) {
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    }
    
    request.HTTPMethod    = httpMethod;
    request.requestParams = requestParams;
    
    if ([HLAppContext shareInstance].accessToken) {
        [request setValue:[HLAppContext shareInstance].accessToken
       forHTTPHeaderField:HLAccessTokenName];
    }

    return request;
}

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.cachePolicy      = NSURLRequestUseProtocolCachePolicy;
        _httpRequestSerializer.timeoutInterval  = kHLNetworkingTimeoutSeconds;
    }
    
    return _httpRequestSerializer;
}

@end
