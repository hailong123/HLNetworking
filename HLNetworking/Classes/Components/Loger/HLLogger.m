//
//  HLLogger.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/11.
//

#import "HLLogger.h"

#import "HLApiProxy.h"
#import "HLAppContext.h"
#import "HLNetworkConfig.h"

#import "NSArray+AXNetworkingMethods.h"
#import "NSObject+AXNetworkingMethods.h"
#import "NSMutableString+AXNetworkingMethods.h"

@interface HLLogger ()

@property (nonatomic, copy, readwrite) HLLoggerConfiguration *configParams;

@end

@implementation HLLogger

+ (instancetype)shareInstance {
    
    static HLLogger *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.configParams = [[HLLoggerConfiguration alloc] init];
    }
    
    return self;
}

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NSString *)httpMethod {

#ifdef DEBUG
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", [apiName CT_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method:\t\t\t%@\n", [httpMethod CT_defaultValue:@"N/A"]];
    [logString appendFormat:@"Version:\t\t%@\n", [[HLNetworkConfig shareConfig].apiVersion CT_defaultValue:@"N/A"]];
    [logString appendFormat:@"Params:\n%@",requestParams];
    
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    NSLog(@"%@", logString);
    
#endif
    
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                  responseString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error {
    
#ifdef DEBUG
    
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendURLRequest:request];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    
    NSLog(@"%@", logString);
    
#endif
    
}

+ (void)logDebugInfoWithCacheResponse:(HLURLResponse *)response
                           methodName:(NSString *)methodName {
    
#ifdef DEBUG
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", [methodName CT_defaultValue:@"N/A"]];
    [logString appendFormat:@"Version:\t\t%@\n", [[HLNetworkConfig shareConfig].apiVersion CT_defaultValue:@"N/A"]];
    [logString appendFormat:@"Method Name:\t%@\n", methodName];
    [logString appendFormat:@"Params:\n%@\n\n", response.requestParams];
    [logString appendFormat:@"Content:\n\t%@\n\n", response.contentStr];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    NSLog(@"%@", logString);
    
#endif
    
}

@end
