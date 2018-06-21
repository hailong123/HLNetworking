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

#import "HLNetworkingConfiguration.h"

@interface HLURLResponse : NSObject

@property (nonatomic, assign, readonly) HLURLResponseStatus status;

@property (nonatomic, copy, readonly) id content;

@property (nonatomic, assign, readonly) BOOL hasCache;

@property (nonatomic, copy, readonly) NSString *contentStr;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy, readonly) NSURLRequest *reqeust;
@property (nonatomic, assign, readonly) NSInteger requestId;

@property (nonatomic, copy) NSDictionary *requestParams;

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                status:(HLURLResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                error:(NSError *)error;


//此方法调用时 cache 默认为YES 以上方法调用时cache默认为NO
- (instancetype)initWithData:(NSData *)data;

@end
