//
//  HLUDIDGenerator.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//
/*
 用途:获取设备的UDID
 */

#import <Foundation/Foundation.h>

@interface HLUDIDGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSString *)UDID;
- (void)saveUDID:(NSString *)udid;

@end
