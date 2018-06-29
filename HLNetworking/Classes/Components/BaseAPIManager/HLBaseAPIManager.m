//
//  HLBaseAPIManager.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//

#import "HLBaseAPIManager.h"

#import "HLApiProxy.h"
#import "HLAppContext.h"

#define kCALLAPI(REQUEST_METHOD,REQUEST_ID)                                                     \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
    REQUEST_ID = [[HLApiProxy shareInstance] call##REQUEST_METHOD##MethodWithParams:apiParams                    methodName:self.child.requestUrl  baseAPIManager:self success:^(HLURLResponse *response) {                   \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf successedOnCallingAPI:response];                                            \
    } fail:^(HLURLResponse *response) {                                                         \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf failedOnCallingAPI:response errorType:HLAPIManagerErrorTypeDefault];        \
    }];                                                                                         \
    [self.requstIdList addObject:@(REQUEST_ID)];                                                \
}

@interface HLBaseAPIManager ()

@property (nonatomic, strong, readwrite) id fetchRawData;

@property (nonatomic, assign, getter=isLoading, readwrite) BOOL loading;
@property (nonatomic, assign, getter=isNativeDataEmpty, readwrite) BOOL nativeDataEmpty;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, assign, readwrite) HLAPIManagerErrorType errorType;

@property (nonatomic, strong) NSMutableArray *requstIdList;

@end

@implementation HLBaseAPIManager

#pragma mark - Private Method
- (instancetype)init {
    if (self = [super init]) {
        
        _delegate     = nil;
        _validator    = nil;
        _paramsSource = nil;
        
        _fetchRawData = nil;
        _errorMessage = nil;
        _errorType    = HLAPIManagerErrorTypeDefault;

        if ([self conformsToProtocol:@protocol(HLAPIManager)]) {
            self.child = (id <HLAPIManager>)self;
        } else {
            NSException *exception = [[NSException alloc] init];
            @throw exception;
        }
    }
    
    return self;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    
    NSInteger requestId            = 0;
    NSMutableDictionary *apiParams = [NSMutableDictionary dictionary];
    
    if ([self.child respondsToSelector:@selector(reformParams:)]) {
        apiParams = [[self reformParams:@{}] mutableCopy];
        [apiParams addEntriesFromDictionary:params];
    } else {
        apiParams = [params mutableCopy];
    }
    
    if (self.child.requestSerializerType == HLAPIManagerRequestSerializerTypeJSON) {
        [[HLApiProxy shareInstance] setValue:[AFJSONRequestSerializer  serializer] forKeyPath:@"sessionManager.requestSerializer"];
    } else {
        [[HLApiProxy shareInstance] setValue:[AFHTTPRequestSerializer  serializer] forKeyPath:@"sessionManager.requestSerializer"];
    }
    
    if ([self shouldCallAPIWithParams:params]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            if ([self.child shouldLoadFormNative]) {
                [self loadDataFromNative];
            }
            
            //TODO:进行缓存的配置
            
            if ([self isReachable]) {
                self.loading = YES;
                switch (self.child.requestMethod) {
                    case HLAPIManagerRequestTypeGET:
                        kCALLAPI(GET, requestId);
                        break;
                    case HLAPIManagerRequestTypePUT:
                        kCALLAPI(PUT, requestId);
                        break;
                        
                    case HLAPIManagerRequestTypePOST:
                        kCALLAPI(POST, requestId);
                        break;
                    case HLAPIManagerRequestTypeDELETE:
                        kCALLAPI(DELETE, requestId);
                        break;
                }
                
                NSMutableDictionary *params        = [apiParams mutableCopy];
                params[KHLAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                
                return requestId;
            } else {
                [self failedOnCallingAPI:nil errorType:HLAPIManagerErrorTypeNoNetwork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil errorType:HLAPIManagerErrorTypeParamersError];
            return requestId;
        }
    }
    
    return requestId;
}

- (void)loadDataFromNative {
    
    NSString *methodName = self.child.requestUrl;
    NSDictionary *result = [(NSDictionary *)[NSUserDefaults standardUserDefaults] objectForKey:methodName];
    
    if (result) {
        
        self.nativeDataEmpty         = NO;
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            HLURLResponse *response = [[HLURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:nil]];
            
            [strongSelf successedOnCallingAPI:response];
            
        });
    } else {
        self.nativeDataEmpty = YES;
    }
}

- (void)successedOnCallingAPI:(HLURLResponse *)response {
    
    self.loading  = NO;
    self.response = response;
    
    if ([self.child shouldLoadFormNative]) {
        if (response.hasCache == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:response forKey:self.child.requestUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (response.content) {
        self.fetchRawData = [response.content copy];
    }
    
    //删除请求根据 reqeustID
    [self removeRequestWithRequestId:response.requestId];
    
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        //TODO:进行缓存处理
        
        if ([self beforePerformSuccessWithResponse:response]) {
            if ([self.child shouldLoadFormNative]) {
                if (self.response.hasCache == YES) {
                    [self.delegate managerAPIDidSuccess:self];
                }
                if (self.isNativeDataEmpty) {
                    [self.delegate managerAPIDidSuccess:self];
                }
            } else {
                [self.delegate managerAPIDidSuccess:self];
            }
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response errorType:HLAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(HLURLResponse *)response errorType:(HLAPIManagerErrorType)errorType {
    
    self.loading  = NO;
    self.response = response;
    
    self.errorType = errorType;
    //删除请求
    [self removeRequestWithRequestId:response.requestId];
    
    if ([self beforePerformFailWithResponse:response]) {
        [self.delegate managerAPIDidFaild:self];
    }
    
    [self afterPerformFailWithResponse:response];
}

- (void)removeRequestWithRequestId:(NSInteger)requestId {
    
    NSNumber *requestIdToRemoved = nil;
    
    for (NSNumber *storeRequestId in self.requstIdList) {
        if ([storeRequestId integerValue] == requestId) {
            requestIdToRemoved = storeRequestId;
            break;
        }
    }
    
    if (requestIdToRemoved) {
        [self.requstIdList removeObject:requestIdToRemoved];
    }
    
}

#pragma mark - Public Method
- (void)cancelAllReqeusts {
    [[HLApiProxy shareInstance] cancelAllRequest];
    [self.requstIdList removeAllObjects];
}

- (void)cancelRequestWithRequestID:(NSInteger)requestID {
    
    [[HLApiProxy shareInstance] cancelRequestWithRequestID:@(requestID)];
    //删除列表中的请求
    [self removeRequestWithRequestId:requestID];
}

- (id)fetchDataWithReformer:(id<HLAPIManagerDataReformer>)reformer {
    
    id resultData = nil;
    
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchRawData];
    } else {
        resultData = [self.fetchRawData mutableCopy];
    }
    
    return resultData;
}

- (NSInteger)loadData {
    
    NSDictionary *params = [self.paramsSource paramsForApi:self];
    NSInteger requestId  = [self loadDataWithParams:params];
    
    return requestId;
}

- (BOOL)beforePerformSuccessWithResponse:(HLURLResponse *)response {
    
    BOOL result    = YES;
    self.errorType = HLAPIManagerErrorTypeSuccess;
 
    if (self != self.interceptor && ([self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)])) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    
    return result;
}

- (void)afterPerformSuccessWithResponse:(HLURLResponse *)response {
    if (self != self.interceptor && ([self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)])) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(HLURLResponse *)response {

    BOOL result = YES;
    
    if (self != self.interceptor && ([self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)])) {
        [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    
    return result;
}

- (void)afterPerformFailWithResponse:(HLURLResponse *)response {
    if (self != self.interceptor && ([self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)])) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params {
    
    BOOL result = YES;
    
    if (self != self.interceptor && ([self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)])) {
        result = [self.interceptor manager:self shouldCallAPIWithParams:params];
    }
    
    return result;
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && ([self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)])) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark Method For Child
- (void)cleanData {
    self.errorType    = HLAPIManagerErrorTypeDefault;
    self.fetchRawData = nil;
    self.errorMessage = nil;
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP  = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

- (BOOL)shouldCache {
    return NO;
}

- (BOOL)shouldLoadFormNative {
    return NO;
}

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (NSMutableArray *)requstIdList {
    if (!_requstIdList) {
        _requstIdList = [NSMutableArray array];
    }
    
    return _requstIdList;
}

- (BOOL)isReachable {
    BOOL isReachability = [HLAppContext shareInstance].isReachable;
    if (!isReachability) {
        self.errorType = HLAPIManagerErrorTypeNoNetwork;
    }
    
    return isReachability;
}

- (BOOL)isLoading {
    if (self.requstIdList.count == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Delloc

@end
