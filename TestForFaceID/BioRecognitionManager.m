//
//  BioRecognitionManager.m
//  ICSB
//
//  Created by xiaojia.xiao on 2019/7/25.
//  Copyright © 2019 Four Direction. All rights reserved.
//

#import "BioRecognitionManager.h"
//#import "SettingManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation BioRecognitionManager

+ (BioRecognitionType)getSupportBioRecognitionType{
    
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LAContext *laContext = [[LAContext alloc]init];
    NSError *error = nil;
    BOOL isSupport = [laContext canEvaluatePolicy:(deviceType) error:&error];
    
    if (error.code == -8) {
        //if system lock,return YES
        isSupport = YES;
    }
    
    if (isSupport) {
        if (@available(iOS 11.0, *)) {
            return (laContext.biometryType == LABiometryTypeFaceID) ? BioRecognitionTypeFaceID : BioRecognitionTypeTouchID;
        } else {
            // Fallback on earlier versions
            return BioRecognitionTypeTouchID;
        }
    }else{
        return BioRecognitionTypeUnsupport;
    }
}

+ (CurrentBioRecognitionType)getCurrentBioRecognitionType{
    NSString *type = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentBioRecognitionType"];
    if ([type isEqualToString:@"FaceID"]) {
        return CurrentBioRecognitionTypeFaceID;
    }else if ([type isEqualToString:@"TouchID"]){
        return CurrentBioRecognitionTypeTouchID;
    }else{
        return CurrentBioRecognitionTypeNull;
    }
}

+ (void)saveBioRecognitionTypeWithType:(NSString *)type{
    
    [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"CurrentBioRecognitionType"];

}

+ (void)callBioRecognitionWithController:(UIViewController *)currentVC Message:(NSString *)message                                             Success:(BoiRecognitionSuccess)success                                            Failure:(BoiRecognitionFailure)failure{
    
    if (![currentVC isKindOfClass:[UIViewController class]]) {
        return;
    }
    NSString *defultMessage = IS_IPHONE_X ? @"面容 ID 短时间内失败多次，需要验证手机密码" : @"请把你的手指放到Home键上";
    NSString *remindMessage;
    
    if (message!=nil) {
        remindMessage = message;
    }else{
        remindMessage =defultMessage;
    }
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LAContext *laContext = [[LAContext alloc]init];
    laContext.localizedFallbackTitle = @"";
    NSError *error = nil;
    BOOL isSupport = [laContext canEvaluatePolicy:(deviceType) error:&error];
    if (isSupport) {
        [laContext evaluatePolicy:deviceType localizedReason:remindMessage reply:^(BOOL callSuccess, NSError * _Nullable err) {
            if (callSuccess) {
                if (@available(iOS 11.0, *)) {
                    (laContext.biometryType == LABiometryTypeFaceID) ? success(BioRecognitionTypeFaceID): success(BioRecognitionTypeTouchID);
                } else {
                    // Fallback on earlier versions
                     success(BioRecognitionTypeTouchID);
                }
            }else{
                failure(err);
            }
        }];
    }else{
        NSLog(@"error - %@",error);
        failure(error);
    }
}

@end
