//
//  HLHomeRequest.m
//  HLDemo
//
//  Created by SeaDragon on 2018/6/21.
//  Copyright © 2018年 SeaDragon. All rights reserved.
//

#import "HLHomeRequest.h"

@interface HLHomeRequest ()
<
    HLAPIManager,
    HLAPIManagerValidator,
    HLAPIManagerInterceptor
>

@end

@implementation HLHomeRequest

- (instancetype)init {
    if (self = [super init]) {
        self.validator    = self;
    }
    
    return self;
}


#pragma mark HLAPIManagerValidator
- (BOOL)manager:(HLBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}

- (BOOL)manager:(HLBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}


- (NSString *)requestUrl {
    return @"phone_login";
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    return @{@"pageSize":@10};
}

- (HLAPIManagerRequestType)requestMethod {
    return HLAPIManagerRequestTypePOST;
}

- (HLAPIManagerRequestSerializerType)requestSerializerType {
    return CTAPIManagerRequestSerializerTypeJSON;
}

@end
