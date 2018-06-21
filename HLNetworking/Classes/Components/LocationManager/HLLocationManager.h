//
//  HLLocationManager.h
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//
/*
 用途:地理位置管理类
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, HLLocationManagerLocationServiceStatus) {
    HLLocationManagerLocationServiceStatusOk,             //定位功能正常
    HLLocationManagerLocationServiceStatusDefault,        //默认状态
    HLLocationManagerLocationServiceStatusNoNetwork,      //没有网络
    HLLocationManagerLocationServiceStatusUnAvailable,    //定位功能关闭
    HLLocationManagerLocationServiceStatusUnknowError,    //未知错误
    HLLocationManagerLocationServiceStatusNotDetermied,   //用户没有做出是否允许应用使用定位功能
    HLLocationManagerLocationServiceStatusNoAuthorization //定位已打开,但是用户没有允许定位
};

typedef NS_ENUM(NSUInteger, HLLocationManagerLocationResult) {
    HLLocationManagerLocationResultFail,        //定位失败
    HLLocationManagerLocationResultSuccess,     //定位成功
    HLLocationManagerLocationResultDefault,     //默认状态
    HLLocationManagerLocationResultTimeout,     //定位超时
    HLLocationManagerLocationResultLocating,    //定位中...
    HLLocationManagerLocationResultNoNetwork,   //无网络
    HLLocationManagerLocationResultNoConnect,   //API没有返回或者返回参数错误
    HLLocationManagerLocationResultParamsError  //调用参数错误
};

@interface HLLocationManager : NSObject

@property (nonatomic, assign, readonly) HLLocationManagerLocationResult locationResult;
@property (nonatomic, assign, readonly) HLLocationManagerLocationServiceStatus locationStatus;

@property (nonatomic, copy, readonly) CLLocation *currentLocation;

+ (instancetype)shareInstance;

- (void)stopLocation;
- (void)startLocation;
- (void)restartLocation;

@end
