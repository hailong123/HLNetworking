//
//  HLAppContext.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//

#import "HLAppContext.h"
#import "AFNetworkReachabilityManager.h"

@interface HLAppContext ()

//Token管理
@property (nonatomic, copy, readwrite) NSString *accessToken;
@property (nonatomic, copy, readwrite) NSString *refreshToken;

@property (nonatomic, assign, readwrite) NSTimeInterval lastRefreshTime;

//APP
@property (nonatomic, copy, readwrite) NSString *sessionID;

@end

@implementation HLAppContext

@synthesize userID   = _userID;
@synthesize userInfo = _userInfo;

+ (instancetype)shareInstance {
    static HLAppContext *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HLAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    
    return _instance;
}

#pragma mark - Private Method

- (void)updateAccessToken:(NSString *)accessToken refreshToken:(NSString *)refreshToken {
    
    self.accessToken     = accessToken;
    self.refreshToken    = refreshToken;
    self.lastRefreshTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:@"refreshToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cleanUserInfo {
    
    self.userID      = nil;
    self.userInfo    = nil;
    self.accessToken = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refreshToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - Setter And Getter
//设备的信息
- (NSString *)type {
    return @"ios";
}

- (NSString *)model {
    return [[UIDevice currentDevice] name];
}

- (NSString *)os {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString *)rom {
    return [[UIDevice currentDevice] model];
}

- (NSString *)imei {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)imsi {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)deviceName {
    return [[UIDevice currentDevice] name];
}

- (NSString *)ppi {
    NSString *ppi = @"";
    if ([self.deviceName isEqualToString:@"iPod1,1"] ||
        [self.deviceName isEqualToString:@"iPod2,1"] ||
        [self.deviceName isEqualToString:@"iPod3,1"] ||
        [self.deviceName isEqualToString:@"iPhone1,1"] ||
        [self.deviceName isEqualToString:@"iPhone1,2"] ||
        [self.deviceName isEqualToString:@"iPhone2,1"]) {
        
        ppi = @"163";
    } else if ([self.deviceName isEqualToString:@"iPod4,1"] ||
               [self.deviceName isEqualToString:@"iPhone3,1"] ||
               [self.deviceName isEqualToString:@"iPhone3,3"] ||
               [self.deviceName isEqualToString:@"iPhone4,1"]) {
        
        ppi = @"326";
    } else if ([self.deviceName isEqualToString:@"iPhone5,1"] ||
               [self.deviceName isEqualToString:@"iPhone5,2"] ||
               [self.deviceName isEqualToString:@"iPhone5,3"] ||
               [self.deviceName isEqualToString:@"iPhone5,4"] ||
               [self.deviceName isEqualToString:@"iPhone6,1"] ||
               [self.deviceName isEqualToString:@"iPhone6,2"]) {
        
        ppi = @"326";
    } else if ([self.deviceName isEqualToString:@"iPhone7,1"]) {
        ppi = @"401";
    } else if ([self.deviceName isEqualToString:@"iPhone7,2"]) {
        ppi = @"326";
    } else if ([self.deviceName isEqualToString:@"iPad1,1"] ||
               [self.deviceName isEqualToString:@"iPad2,1"]) {
        ppi = @"132";
    } else if ([self.deviceName isEqualToString:@"iPad3,1"] ||
             [self.deviceName isEqualToString:@"iPad3,4"] ||
             [self.deviceName isEqualToString:@"iPad4,1"] ||
             [self.deviceName isEqualToString:@"iPad4,2"]) {
        ppi = @"264";
    } else if ([self.deviceName isEqualToString:@"iPad2,5"]) {
        ppi = @"163";
    } else if ([self.deviceName isEqualToString:@"iPad4,4"] ||
               [self.deviceName isEqualToString:@"iPad4,5"]) {
        ppi = @"326";
    } else {
        ppi = @"264";
    }
    
    return ppi;
}

- (CGSize)resolution {
    
    CGSize resolution = CGSizeZero;
    
    if ([self.deviceName isEqualToString:@"iPod1,1"] ||
        [self.deviceName isEqualToString:@"iPod2,1"] ||
        [self.deviceName isEqualToString:@"iPod3,1"] ||
        [self.deviceName isEqualToString:@"iPhone1,1"] ||
        [self.deviceName isEqualToString:@"iPhone1,2"] ||
        [self.deviceName isEqualToString:@"iPhone2,1"]) {
        
        resolution = CGSizeMake(320, 480);
    } else if ([self.deviceName isEqualToString:@"iPod4,1"] ||
             [self.deviceName isEqualToString:@"iPhone3,1"] ||
             [self.deviceName isEqualToString:@"iPhone3,3"] ||
             [self.deviceName isEqualToString:@"iPhone4,1"]) {
        
        resolution = CGSizeMake(640, 960);
    } else if ([self.deviceName isEqualToString:@"iPhone5,1"] ||
             [self.deviceName isEqualToString:@"iPhone5,2"] ||
             [self.deviceName isEqualToString:@"iPhone5,3"] ||
             [self.deviceName isEqualToString:@"iPhone5,4"] ||
             [self.deviceName isEqualToString:@"iPhone6,1"] ||
             [self.deviceName isEqualToString:@"iPhone6,2"]) {
        
        resolution = CGSizeMake(640, 1136);
    } else if ([self.deviceName isEqualToString:@"iPhone7,1"]) {
        resolution = CGSizeMake(1080, 1920);
    } else if ([self.deviceName isEqualToString:@"iPhone7,2"]) {
        resolution = CGSizeMake(750, 1334);
    } else if ([self.deviceName isEqualToString:@"iPad1,1"] ||
             [self.deviceName isEqualToString:@"iPad2,1"]) {
        resolution = CGSizeMake(768, 1024);
    } else if ([self.deviceName isEqualToString:@"iPad3,1"] ||
             [self.deviceName isEqualToString:@"iPad3,4"] ||
             [self.deviceName isEqualToString:@"iPad4,1"] ||
             [self.deviceName isEqualToString:@"iPad4,2"]) {
        resolution = CGSizeMake(1536, 2048);
    } else if ([self.deviceName isEqualToString:@"iPad2,5"]) {
        resolution = CGSizeMake(768, 1024);
    } else if ([self.deviceName isEqualToString:@"iPad4,4"] ||
             [self.deviceName isEqualToString:@"iPad4,5"]) {
        resolution = CGSizeMake(1536, 2048);
    } else {
        resolution = CGSizeMake(640, 960);
    }
    
    return resolution;
}

//运行环境相关
- (BOOL)isReachable {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

//用户token相关
- (NSString *)accessToken {
    
    if (!_accessToken) {
        _accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    }
    
    return _accessToken;
}

- (NSString *)refreshToken {
    
    if (!_refreshToken) {
        _refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshToken"];
    }
    
    return _refreshToken;
}

//用户信息
- (void)setUserID:(NSString *)userID {
    
    _userID = userID;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)userID {
    
    if (!_userID) {
        _userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    }
    
    return _userID;
}

- (void)setUserInfo:(NSDictionary *)userInfo {
    
    _userInfo = userInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject:_userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)userInfo {
    
    if (!_userInfo) {
        _userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    }
    
    return _userInfo;
}

- (BOOL)isLoginIn {
    BOOL result = (self.userID.length != 0);
    return result;
}

//App信息
- (NSString *)appVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

- (void)appStarted {
    self.sessionID = [[NSUUID UUID].UUIDString copy];
    //TODO:开始定位
}

- (void)appEnded {
    //TODO:结束定位
}

//推送相关
- (NSData *)deviceTokenData {
    
    if (!_deviceTokenData) {
        _deviceTokenData = [NSData data];
    }
    
    return _deviceTokenData;
}

- (NSString *)deviceToken {
    
    if (!_deviceToken) {
        _deviceToken = @"";
    }
    
    return _deviceToken;
}

//地理位置相关
- (CGFloat)latitude {
    //TODO:经度
    return 0.0f;
}

- (CGFloat)longitude {
    //TODO:纬度
    return 0.0f;
}

@end
