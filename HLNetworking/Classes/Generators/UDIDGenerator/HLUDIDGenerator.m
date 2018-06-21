//
//  HLUDIDGenerator.m
//  HLNetworking
//
//  Created by SeaDragon on 2018/6/2.
//

#import "HLUDIDGenerator.h"

#import "HLNetworkingConfiguration.h"

@implementation HLUDIDGenerator

+ (instancetype)sharedInstance {
   
    static HLUDIDGenerator *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}


- (NSString *)UDID {
    
    NSData *udidData = [self searchKeychainCopyMatching:HLUDIDName];
    NSString *udid   = nil;
    
    if (udidData != nil) {
        NSString *temp = [[NSString alloc] initWithData:udidData encoding:NSUTF8StringEncoding];
        udid           = [NSString stringWithFormat:@"%@", temp];
    }
    
    if (udid.length == 0) {
        udid = [self readPasteBoradforIdentifier:HLUDIDName];
    }
    
    return udid;
}

- (void)saveUDID:(NSString *)udid {
    
    BOOL saveOk      = NO;
    NSData *udidData = [self searchKeychainCopyMatching:HLUDIDName];
    
    if (udidData == nil) {
        saveOk = [self createKeychainValue:udid forIdentifier:HLUDIDName];
    } else {
        saveOk = [self updateKeychainValue:udid forIdentifier:HLUDIDName];
    }
    
    if (!saveOk) {
        [self createPasteBoradValue:udid forIdentifier:HLUDIDName];
    }
}

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:HLKeychainServiceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDataRef result = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary,
                        (CFTypeRef *)&result);
    
    return (__bridge NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    NSData *passwordData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (BOOL)updateKeychainValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [value dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary,
                                    (__bridge CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (void)deleteKeychainValue:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
}

- (void)createPasteBoradValue:(NSString *)value forIdentifier:(NSString *)identifier {
    
    UIPasteboard *pb   = [UIPasteboard pasteboardWithName:HLKeychainServiceName create:YES];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:value forKey:identifier];
    NSData *dictData   = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [pb setData:dictData forPasteboardType:HLPasteboardType];
}

- (NSString *)readPasteBoradforIdentifier:(NSString *)identifier {
    
    UIPasteboard *pb   = [UIPasteboard pasteboardWithName:HLKeychainServiceName create:YES];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[pb dataForPasteboardType:HLPasteboardType]];
    return [dict objectForKey:identifier];
}

@end
