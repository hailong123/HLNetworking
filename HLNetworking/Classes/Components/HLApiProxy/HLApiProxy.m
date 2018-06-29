//
//  HLApiProxy.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//

#import "HLApiProxy.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#import "HLLogger.h"
#import "HLApiProxy.h"
#import "HLBaseAPIManager.h"
#import "HLRequestGenerator.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface HLApiProxy ()

@property (nonatomic, strong) NSNumber *recordeRequestId;
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

//AFNetworking
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation HLApiProxy

#pragma mark - Private Method
+ (instancetype)shareInstance {
    
    static HLApiProxy *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[HLApiProxy alloc] init];
    });
    
    return _instance;
}


//此方法, 用于替换第三方网络请求库
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request
                         success:(HLCallBack)success
                            fail:(HLCallBack)fail {

#ifdef DEBUG
    NSLog(@"\n==================================\n\nRequest Start: \n\n %@\n\n==================================", request.URL);
#endif
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                         uploadProgress:nil
                                       downloadProgress:nil
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          
                                          NSNumber *requestID = @([dataTask taskIdentifier]);
                                          [self.dispatchTable removeObjectForKey:requestID];
                                          
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          
                                          if (error) {
                                              [HLLogger logDebugInfoWithResponse:httpResponse
                                                                  responseData:responseObject
                                                                         request:request
                                                                           error:error];
                                              
                                              HLURLResponse *response = [[HLURLResponse alloc] initWithRequestId:requestID responseData:responseObject request:request error:error];
                                              
                                              fail?fail(response):nil;
                                              
                                          } else {
                                              
                                              [HLLogger logDebugInfoWithResponse:httpResponse responseData:responseObject request:request error:error];
                             
                                              HLURLResponse *response = [[HLURLResponse alloc] initWithRequestId:requestID responseData:responseObject request:request];
                                              
                                              success?success(response):nil;
                                          }
    }];
    
    NSNumber *requestID           = @([dataTask taskIdentifier]);
    self.dispatchTable[requestID] = dataTask;
    
    [dataTask resume];
    
    return requestID;
}

#pragma mark - Public Method
- (NSInteger)callGETMethodWithParams:(NSDictionary *)params
                          methodName:(NSString *)methodName
                      baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                             success:(HLCallBack)success
                                fail:(HLCallBack)fail {
    
    NSURLRequest *request = [[HLRequestGenerator alloc] generateGETRequestWithRequestParams:params
                                                                                 methodName:methodName
                                                                             baseAPIManager:baseAPIManager];
    
    NSNumber *requestID   = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestID integerValue];
}

- (NSInteger)callPOSTMethodWithParams:(NSDictionary *)params
                           methodName:(NSString *)methodName
                       baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                              success:(HLCallBack)success
                                 fail:(HLCallBack)fail {
    
    NSURLRequest *request = [[HLRequestGenerator alloc] generatePOSTRequestWithRequestParams:params
                                                                                 methodName:methodName
                                                                              baseAPIManager:baseAPIManager];
    
    NSNumber *requestID   = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestID integerValue];
}

- (NSInteger)callPUTMethodWithParams:(NSDictionary *)params
                          methodName:(NSString *)methodName
                      baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                             success:(HLCallBack)success
                                fail:(HLCallBack)fail {
    
    NSURLRequest *request = [[HLRequestGenerator alloc] generatePUTRequestWithRequestParams:params
                                                                                 methodName:methodName
                                                                             baseAPIManager:baseAPIManager];
    
    NSNumber *requestID   = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestID integerValue];
}

- (NSInteger)callDELETEMethodWithParams:(NSDictionary *)params
                             methodName:(NSString *)methodName
                         baseAPIManager:(HLBaseAPIManager *)baseAPIManager
                                success:(HLCallBack)success
                                   fail:(HLCallBack)fail {
    
    NSURLRequest *request = [[HLRequestGenerator alloc] generateDELETERequestWithRequestParams:params
                                                                                    methodName:methodName
                                                                                baseAPIManager:baseAPIManager];
    
    NSNumber *requestID   = [self callApiWithRequest:request success:success fail:fail];
    
    return [requestID integerValue];
}

#pragma mark CancelRequest
- (void)cancelRequestWithRequestID:(NSNumber *)requestId {
    
    NSURLSessionDataTask *dataTask = self.dispatchTable[requestId];
    [dataTask cancel];
    [self.dispatchTable removeObjectForKey:requestId];
}

- (void)cancelAllRequest {
    
    [self.dispatchTable enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *dataTask = self.dispatchTable[key];
        [dataTask cancel];
    }];
    
    [self.dispatchTable removeAllObjects];
}

#pragma mark - Setter And Getter
- (NSMutableDictionary *)dispatchTable {
    if (!_dispatchTable) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.securityPolicy.validatesDomainName        = NO;
        _sessionManager.securityPolicy.allowInvalidCertificates   = YES;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                     @"application/json",
                                                                     @"text/plain",
                                                                     @"text/javascript",
                                                                     @"text/json",
                                                                     @"text/html",
                                                                     @"text/css", nil];
    }
    
    return _sessionManager;
}

@end
