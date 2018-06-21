//
//  HLLocationManager.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//

#import "HLLocationManager.h"

@interface HLLocationManager ()
<
    CLLocationManagerDelegate
>

@property (nonatomic, assign, readwrite) HLLocationManagerLocationResult locationResult;
@property (nonatomic, assign, readwrite) HLLocationManagerLocationServiceStatus locationStatus;

@property (nonatomic, copy, readwrite) CLLocation *currentLocation;

@property (nonatomic, copy) CLLocationManager *locationManager;

@end

@implementation HLLocationManager

#pragma mark - Private Method
+ (instancetype)shareInstance {
    static HLLocationManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HLLocationManager alloc] init];
    });
    
    return _instance;
}

- (void)failedLocationWithResultType:(HLLocationManagerLocationResult)result
                          statusType:(HLLocationManagerLocationServiceStatus)status {
    self.locationResult = result;
    self.locationStatus = status;
}

- (BOOL)checkLocationStatus {
    
    BOOL status = NO;
    
    BOOL locationServerEnable = [self locationServerEnable];
    
    HLLocationManagerLocationServiceStatus locationServerStatus = [self locationServerStatus];

    if ((locationServerStatus == HLLocationManagerLocationServiceStatusOk) && locationServerEnable) {
        status = YES;
    } else if (locationServerStatus == HLLocationManagerLocationServiceStatusNotDetermied) {
        status = YES;
    } else {
        status = NO;
    }
    
    if (locationServerEnable && status) {
        status = YES;
    } else {
        status = NO;
    }
    
    if (!status) {
        //TODO:进行判断
        self.locationResult = HLLocationManagerLocationResultFail;
        self.locationStatus = locationServerStatus;
    }
    
    return status;
}

- (BOOL)locationServerEnable {
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationStatus = HLLocationManagerLocationServiceStatusOk;
        return YES;
    }
    
    self.locationStatus = HLLocationManagerLocationServiceStatusUnknowError;
    return NO;
}

- (HLLocationManagerLocationServiceStatus)locationServerStatus {
    
    self.locationStatus = HLLocationManagerLocationServiceStatusUnknowError;
    
    BOOL serverEnable = [CLLocationManager locationServicesEnabled];
    
    if (serverEnable) {
        CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
        switch (authorizationStatus) {
            case kCLAuthorizationStatusNotDetermined:
                self.locationStatus = HLLocationManagerLocationServiceStatusNotDetermied;
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                self.locationStatus = HLLocationManagerLocationServiceStatusOk;
                break;
            case kCLAuthorizationStatusDenied:
                self.locationStatus = HLLocationManagerLocationServiceStatusNoAuthorization;
                break;
            default:
                break;
        }
    } else {
        self.locationStatus = HLLocationManagerLocationServiceStatusUnAvailable;
    }
    
    return self.locationStatus;
}

#pragma mark - Public Method
- (void)startLocation {
    if ([self checkLocationStatus]) {
        self.locationStatus = HLLocationManagerLocationResultLocating;
        [self.locationManager startUpdatingLocation];
    } else {
        [self failedLocationWithResultType:HLLocationManagerLocationResultFail
                                statusType:self.locationStatus];
    }
}

- (void)stopLocation {
    if ([self checkLocationStatus]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)restartLocation {
    [self stopLocation];
    [self startLocation];
}

#pragma mark - Delegate

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentLocation = [manager.location copy];
    
#ifdef DEBUG
    NSLog(@"定位信息>>>>>>%@",manager.location);
#endif
    
    [self stopLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //用户没有打开权限,不认为是定位失败
    if (self.locationResult == HLLocationManagerLocationServiceStatusNotDetermied) {
        return;
    }
    
    //正在定位中,不认为是定位失败
    if (self.locationStatus == HLLocationManagerLocationResultLocating) {
        return;
    }
    
    //TODO:定位失败
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationStatus = HLLocationManagerLocationServiceStatusOk;
        [self restartLocation];
    } else {
        if (self.locationStatus != HLLocationManagerLocationServiceStatusNotDetermied) {
            [self failedLocationWithResultType:HLLocationManagerLocationResultDefault
                                    statusType:HLLocationManagerLocationServiceStatusNoAuthorization];
        } else {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - Setter And Getter
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager                 = [[CLLocationManager alloc] init];
        _locationManager.delegate        = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return _locationManager;
}

#pragma mark - Delloc

@end
