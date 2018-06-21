//
//  HLURLResponse.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//

#import "HLURLResponse.h"

#import "HLUDIDGenerator.h"
#import "HLRequestGenerator.h"

#import "NSObject+AXNetworkingMethods.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface HLURLResponse ()

@property (nonatomic, assign, readwrite) HLURLResponseStatus status;

@property (nonatomic, copy, readwrite) id content;

@property (nonatomic, assign, readwrite) BOOL hasCache;

@property (nonatomic, copy, readwrite) NSString *contentStr;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, copy, readwrite) NSURLRequest *reqeust;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@end

@implementation HLURLResponse

#pragma mark - Private Method
- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                 error:(NSError *)error {
    if (self = [super init]) {
        
        self.reqeust       = request;
        self.requestId     = [requestId integerValue];
        self.contentStr    = [responseString CT_defaultValue:@""];
        self.responseData  = responseData;
        self.requestParams = request.requestParams;
    
        self.hasCache = NO;
        
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&error];
        } else {
            self.content = nil;
        }
        
        self.status = [self responseStatusWithError:error];
    }
    
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                status:(HLURLResponseStatus)status {
    if (self = [super init]) {
        
        self.status        = status;
        self.reqeust       = request;
        self.requestId     = [requestId integerValue];
        self.contentStr    = [responseString CT_defaultValue:@""];
        self.responseData  = responseData;
        self.requestParams = request.requestParams;
        
        self.hasCache = NO;
        
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers
                                                             error:NULL];
        } else {
            self.content = nil;
        }
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    
    if (self = [super init]) {
        
        self.status        = [self responseStatusWithError:nil];
        self.reqeust       = nil;
        self.requestId     = 0;
        self.contentStr    = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.responseData  = [data copy];
        
        self.hasCache = YES;
        
        if (data) {
            self.content = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:NULL];
        } else {
            self.content = nil;
        }
    }
    
    return self;
}

- (HLURLResponseStatus)responseStatusWithError:(NSError *)error {
    if (error) {
        
        HLURLResponseStatus status = HLURLResponseStatusErrorNoNetwork;
        
        //除了请求超时以外, 其他的都是无网络状态
        if (error.code == NSURLErrorTimedOut) {
            status = HLURLResponseStatusErrorTimeout;
        }
        
        return status;
    }
    
    return HLURLResponseStatusSuccess;
}

@end
