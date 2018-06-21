//
//  HLNetworkConfig.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//

#import "HLNetworkConfig.h"

@implementation HLNetworkConfig

+ (HLNetworkConfig *)shareConfig {
    static HLNetworkConfig *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.baseUrl    = @"";
        self.cdnsUrl    = @"";
        self.apiVersion = @"";
        
        self.commonHeaderFiledDic = @{};
    }
    
    return self;
}

@end
