//
//  HLURLResponse.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//

/*
 用途:此文件用于接收响应结果的数据
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLURLResponse : NSObject

/** 接口所返回的数据 只读属性 */
@property (nonatomic, strong, readonly) id content;

/** 是否使用缓存 默认为NO 只读属性 */
@property (nonatomic, assign, readonly) BOOL hasCache;

/** 存储请求 */
@property (nonatomic, strong, readonly) NSURLRequest *reqeust;

/** 存储请求的ID */
@property (nonatomic, assign, readonly) NSInteger requestId;

/** 响应请求的请求参数 */
@property (nonatomic, copy) NSDictionary *requestParams;

/**
 描述:生成请求响应对象
 @params  requestId    请求的ID
          responseData 接口返回数据
          request      请求
 @return  响应对象
 */
- (instancetype)initWithRequestId:(NSNumber *)requestId
                     responseData:(id)responseData
                          request:(NSURLRequest *)request;

/**
 描述:生成请求响应对象
 @params  requestId    请求的ID
          responseData 接口返回数据
          request      请求
          error        错误信息
 @return  响应对象
 */
- (instancetype)initWithRequestId:(NSNumber *)requestId
                     responseData:(id)responseData
                          request:(NSURLRequest *)request
                            error:(NSError *)error;


//此方法调用时 cache 默认为YES 以上方法调用时cache默认为NO
- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
