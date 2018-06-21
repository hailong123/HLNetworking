//
//  HLLoggerConfiguration.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//

#import "HLLoggerConfiguration.h"

@implementation HLLoggerConfiguration

- (void)configWithAppType:(HLAppType)appType {
    switch (appType) {
        case HLAppType_Demo:
        {
            self.appKey = @"";
        }
            break;
            
        default:
            break;
    }
}

@end
