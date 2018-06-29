//
//  HLNetworkingConfigurationManager.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//

#import "HLNetworkingConfigurationManager.h"

NSString * const kNotificationNameErrorCodeNumber = @"kNotificationNameErrorCodeNumber";

@implementation HLNetworkingConfigurationManager

+ (HLNetworkingConfigurationManager *)shareConfig {
    static HLNetworkingConfigurationManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.baseUrl     = @"";
        self.cdnsUrl     = @"";
        self.apiVersion  = @"";
        self.accessToken = @"";
        
        self.timeoutSeconds       = 60.0f;
        self.httpHeaderDictionary = @{};
    }
    
    return self;
}

@end
