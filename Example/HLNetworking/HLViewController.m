//
//  ViewController.m
//  HLDemo
//
//  Created by SeaDragon on 2018/6/21.
//  Copyright © 2018年 SeaDragon. All rights reserved.
//

#import "HLViewController.h"

#import "HLHomeRequest.h"

@interface HLViewController ()
<
    HLAPIManagerInterceptor,
    HLAPIManagerParamSource,
    HLBaseAPIManagerCallBackDelegate
>

@property (nonatomic, strong) HLHomeRequest *homeRequest;

@end

@implementation HLViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createUI];
    
}

#pragma mark - Private Method

- (void)createUI {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(100, 200, 200, 200);
    [btn setTitle:@"发送请求" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

- (void)clickBtn:(UIButton *)btn {
    [self.homeRequest loadData];
}

#pragma mark - Public Method

#pragma mark - Delegate

#pragma mark HLAPIManagerParamSource
- (NSDictionary *)paramsForApi:(HLBaseAPIManager *)manager {
    return @{@"1":@1};
}

#pragma mark HLAPIManagerInterceptor
/*
- (BOOL)manager:(HLBaseAPIManager *)manager beforePerformSuccessWithResponse:(HLURLResponse *)response {
    return YES;
}

- (void)manager:(HLBaseAPIManager *)manager afterPerformSuccessWithResponse:(HLURLResponse *)response {
    
}

- (BOOL)manager:(HLBaseAPIManager *)manager beforePerformFailWithResponse:(HLURLResponse *)response {
    return YES;
}

- (void)manager:(HLBaseAPIManager *)manager afterPerformFailWithResponse:(HLURLResponse *)response {
    
}

- (BOOL)manager:(HLBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params {
    return YES;
}

- (void)manager:(HLBaseAPIManager *)manager afterCallingAPIWithParams:(NSDictionary *)params {
    
}
*/

#pragma mark <HLBaseAPIManagerCallBackDelegate>
- (void)managerAPIDidSuccess:(HLBaseAPIManager *)baseAPIManager {
    //TODO:这里进行 reformer
}

- (void)managerAPIDidFaild:(HLBaseAPIManager *)baseAPIManager {
    
}

#pragma mark - Setter And Getter

- (HLHomeRequest *)homeRequest {
    if (!_homeRequest) {
        _homeRequest = [[HLHomeRequest alloc] init];
        _homeRequest.delegate     = self;
        _homeRequest.paramsSource = self;
//        _homeRequest.interceptor  = self;
    }
    
    return _homeRequest;
}

#pragma mark - Delloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
