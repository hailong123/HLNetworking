//
//  HLBaseAPIManager.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//
/*
 用途:请求的基类
 */

#import <Foundation/Foundation.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#import "HLURLResponse.h"

@class HLBaseAPIManager;

//在调用成功之后的params字典里, 可以使用这个key来获取到requestID
static NSString * const KHLAPIBaseManagerRequestID = @"KHLAPIBaseManagerRequestID";

@protocol HLBaseAPIManagerCallBackDelegate <NSObject>

@required
//请求成功失败的回调
- (void)managerAPIDidFaild:(HLBaseAPIManager *)baseAPIManager;
- (void)managerAPIDidSuccess:(HLBaseAPIManager *)baseAPIManager;

@end

@protocol HLAPIManagerDataReformer<NSObject>
@optional
//可以通过此方法进行数据的转换
- (id)manager:(HLBaseAPIManager *)manager reformData:(NSDictionary *)data;

@end

@protocol HLAPIManagerValidator<NSObject>

@required
//进行参数以及回调的验证
- (BOOL)manager:(HLBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
- (BOOL)manager:(HLBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

@end

@protocol HLAPIManagerParamSource <NSObject>

@required
//提供参数的回调
- (NSDictionary *)paramsForApi:(HLBaseAPIManager *)manager;

@end

//此处的枚举 列举了不同网络的状态
typedef NS_ENUM(NSUInteger, HLAPIManagerErrorType) {
    HLAPIManagerErrorTypeDefault, //默认的状态
    HLAPIManagerErrorTypeSuccess, //请求成功
    HLAPIManagerErrorTypeTimeout, //请求超时
    HLAPIManagerErrorTypeNoContent,     //API返回成功,但是数据错误
    HLAPIManagerErrorTypeNoNetwork,    //无网络状态
    HLAPIManagerErrorTypeParamersError //参数错误
};

//请求的方法
typedef NS_ENUM(NSUInteger, HLAPIManagerRequestType) {
    HLAPIManagerRequestTypePUT,
    HLAPIManagerRequestTypeGET,
    HLAPIManagerRequestTypePOST,
    HLAPIManagerRequestTypeDELETE
};

//序列化格式
typedef NS_ENUM(NSUInteger, HLAPIManagerRequestSerializerType) {
    CTAPIManagerRequestSerializerTypeJSON,
    CTAPIManagerRequestSerializerTypeHTTP
};

//***** HLAManager ******//
//派生类必须符合这些协议
@protocol HLAPIManager <NSObject>

@required
- (NSString *)requestUrl;
- (HLAPIManagerRequestType)requestMethod;
- (HLAPIManagerRequestSerializerType)requestSerializerType;

@optional
- (void)cleanData;
- (BOOL)shouldCache;
- (BOOL)shouldLoadFormNative;
- (NSDictionary *)reformParams:(NSDictionary *)paramsDic;
- (NSDictionary *)loadDataWithParams:(NSDictionary *)paramsDic;

@end

//上传图片的回调
@protocol AFMultipartFormData;

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

//****** HLAPIManagerInterceptor ******//
//将方法的回调剥离出来

@protocol HLAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(HLBaseAPIManager *)manager beforePerformSuccessWithResponse:(HLURLResponse *)response;
- (void)manager:(HLBaseAPIManager *)manager afterPerformSuccessWithResponse:(HLURLResponse *)response;

- (BOOL)manager:(HLBaseAPIManager *)manager beforePerformFailWithResponse:(HLURLResponse *)response;
- (void)manager:(HLBaseAPIManager *)manager afterPerformFailWithResponse:(HLURLResponse *)response;

- (BOOL)manager:(HLBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(HLBaseAPIManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end

@interface HLBaseAPIManager : NSObject

@property (nonatomic, weak) id <HLAPIManagerValidator> validator;
@property (nonatomic, weak) id <HLAPIManagerInterceptor> interceptor;
@property (nonatomic, weak) id <HLAPIManagerParamSource> paramsSource;
@property (nonatomic, weak) id <HLBaseAPIManagerCallBackDelegate> delegate;

@property (nonatomic, weak) NSObject <HLAPIManager> *child;

@property (nonatomic, strong) HLURLResponse *response;
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, assign, readonly) HLAPIManagerErrorType errorType;

@property (nonatomic, assign, getter=isLoading, readonly)   BOOL loading;
@property (nonatomic, assign, getter=isReachable, readonly) BOOL reachable;

@property (nonatomic, copy) AFConstructingBlock constructingBodyBlock;

@property (nonatomic, assign) NSInteger nextPageNumber;
@property (nonatomic, assign) NSInteger totalPropertyNumber;

- (id)fetchDataWithReformer:(id<HLAPIManagerDataReformer>)reformer;

- (NSInteger)loadData;
- (void)loadNextPage;
- (void)loadPrecedPage;

- (void)cancelAllReqeusts;
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

- (void)cleanData;
- (BOOL)shouldCache;
- (NSDictionary *)reformParams:(NSDictionary *)params;

@end
