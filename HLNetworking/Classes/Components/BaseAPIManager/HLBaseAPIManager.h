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
/**
    请求成功失败的回调 将接口对应的数据返回
 */
- (void)managerAPIDidFaild:(HLBaseAPIManager *)baseAPIManager;
- (void)managerAPIDidSuccess:(HLBaseAPIManager *)baseAPIManager;

@end

@protocol HLAPIManagerDataReformer<NSObject>
@optional
/**
    此方法用于处理接口返回数据的中间层协议, 遵守此协议可为上层提供上层所需的数据
    @params manager 当前请求类
            data    接口后台返回的数据
    @return         返回根据上层所需要所组装的数据
 */
- (id)manager:(HLBaseAPIManager *)manager reformData:(NSDictionary *)data;

@end

@protocol HLAPIManagerValidator<NSObject>

@required
/**
    对参数以及回调的验证
    @return 返回验证后是否通过 默认为YES
 */
- (BOOL)manager:(HLBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

/**
 是否对回调进行触发
 @return 返回验证后是否通过 默认为YES
 */
- (BOOL)manager:(HLBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

@end

/**
    请求接口的控制器, 必须遵守此协议,用于提供接口所需数据
 */
@protocol HLAPIManagerParamSource <NSObject>

@required
/**
    提供参数的回调
    @return 返回接口所需参数字典
 */
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
    HLAPIManagerRequestSerializerTypeJSON,
    HLAPIManagerRequestSerializerTypeHTTP
};

//***** HLAManager ******//
//派生类必须符合这些协议
@protocol HLAPIManager <NSObject>

@required
//请求方法地址
- (NSString *)requestUrl;
//请求方法 POST GET ....
- (HLAPIManagerRequestType)requestMethod;
//请求序列化格式 JSON  HTTP
- (HLAPIManagerRequestSerializerType)requestSerializerType;

@optional
- (void)cleanData;
- (BOOL)shouldCache;
- (BOOL)shouldLoadFormNative;
- (NSDictionary *)reformParams:(NSDictionary *)paramsDic;

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
/*
    数据验证代理
    设置此代理,可以在进行对发起请求前对参数进行验证 和 接收到回调之后对服务端返回的数据进行验证
 */
@property (nonatomic, weak) id <HLAPIManagerValidator> validator;

/*
    方法拦截代理
    设置次代理,可对请求的以下步骤进行监听
 
    **请求成功前**
    **请求成功后**
 
    **请求失败前**
    **请求失败后**
 
    **将要调用API**
    **调用API之后**
 
 */
@property (nonatomic, weak) id <HLAPIManagerInterceptor> interceptor;

/*
    接口入参代理
 */
@property (nonatomic, weak) id <HLAPIManagerParamSource> paramsSource;

/*
    请求回调代理
 */
@property (nonatomic, weak) id <HLBaseAPIManagerCallBackDelegate> delegate;

@property (nonatomic, weak) NSObject <HLAPIManager> *child;

@property (nonatomic, strong) HLURLResponse *response;
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, assign, readonly) HLAPIManagerErrorType errorType;

@property (nonatomic, assign, getter=isLoading, readonly)   BOOL loading;
@property (nonatomic, assign, getter=isReachable, readonly) BOOL reachable;

@property (nonatomic, copy) AFConstructingBlock constructingBodyBlock;

- (id)fetchDataWithReformer:(id<HLAPIManagerDataReformer>)reformer;

- (NSInteger)loadData;

- (void)cancelAllReqeusts;
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

- (void)cleanData;
- (BOOL)shouldCache;

@end
