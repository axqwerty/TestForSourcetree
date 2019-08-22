//
//  BioRecognitionManager.h
//  ICSB
//
//  Created by xiaojia.xiao on 2019/7/25.
//  Copyright © 2019 Four Direction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    BioRecognitionTypeTouchID    =  0,
    BioRecognitionTypeFaceID     =  1,
    BioRecognitionTypeUnsupport  =  2,
} BioRecognitionType;


typedef enum{
    CurrentBioRecognitionTypeNull     =  0,
    CurrentBioRecognitionTypeFaceID   =  1,
    CurrentBioRecognitionTypeTouchID  =  2,
} CurrentBioRecognitionType;


typedef void(^BoiRecognitionSuccess)(BioRecognitionType type);
typedef void(^BoiRecognitionFailure)(NSError *err);

@interface BioRecognitionManager : NSObject

//return supported bio recognition type of device
+ (BioRecognitionType)getSupportBioRecognitionType;

//return current bio recognition type of device
+ (CurrentBioRecognitionType)getCurrentBioRecognitionType;

//save current bio recognition type of device
+ (void)saveBioRecognitionTypeWithType:(NSString *)type;

//call bio recognition
+ (void)callBioRecognitionWithController:(UIViewController *)currentVC
                                 Message:(NSString *)message
                                 Success:(BoiRecognitionSuccess)success
                                 Failure:(BoiRecognitionFailure)failure;

@end

