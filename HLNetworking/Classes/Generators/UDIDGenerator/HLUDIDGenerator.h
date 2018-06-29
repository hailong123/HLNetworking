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

/** 创建 HLUDIDGenerator 实例 */
+ (instancetype)sharedInstance;

/** 获取设备的 UDID */
- (NSString *)UDID;

/** 保存设备的UDID */
- (void)saveUDID:(NSString *)udid;

@end
