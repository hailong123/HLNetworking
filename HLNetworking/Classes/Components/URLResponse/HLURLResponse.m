//
//  HLURLResponse.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//

#import "HLURLResponse.h"

#import "HLRequestGenerator.h"

#import "NSObject+AXNetworkingMethods.h"
#import "NSURLRequest+CTNetworkingMethods.h"

@interface HLURLResponse ()

@property (nonatomic, strong, readwrite) id content;
@property (nonatomic, strong, readwrite) NSURLRequest *reqeust;

@property (nonatomic, assign, readwrite) BOOL hasCache;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@end

@implementation HLURLResponse

#pragma mark - Private Method
- (instancetype)initWithRequestId:(NSNumber *)requestId
                     responseData:(id)responseData
                          request:(NSURLRequest *)request
                            error:(NSError *)error {
    
    if (self = [super init]) {
        
        self.reqeust       = request;
        self.requestId     = [requestId integerValue];
        self.requestParams = request.requestParams;
    
        self.hasCache = NO;
        
        if (responseData) {
            self.content = responseData;
        } else {
            self.content = nil;
        }
    
    }
    
    return self;
}

- (instancetype)initWithRequestId:(NSNumber *)requestId
                     responseData:(id)responseData
                          request:(NSURLRequest *)request {
    
    if (self = [super init]) {
    
        self.reqeust       = request;
        self.requestId     = [requestId integerValue];
        self.requestParams = request.requestParams;
        
        self.hasCache = NO;
        
        if (responseData) {
            self.content = responseData;
        } else {
            self.content = nil;
        }
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    
    if (self = [super init]) {
        
        self.reqeust       = nil;
        self.requestId     = 0;
        
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

@end
