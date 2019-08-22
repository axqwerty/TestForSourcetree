//
//  ViewController.m
//  TestForFaceID
//
//  Created by xiaojia.xiao on 2019/8/19.
//  Copyright © 2019 xiaojia.xiao. All rights reserved.
//

#import "ViewController.h"
#import "BioRecognitionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)anableFaceID:(id)sender {
    
    //调用生物识别进行验证
    NSString *message;
    BioRecognitionType type = [BioRecognitionManager getSupportBioRecognitionType];
    if (type == BioRecognitionTypeFaceID) {
        message = @"Enable_Face_ID";
    }else if (type == BioRecognitionTypeTouchID){
        message = @"Enable_Touch_ID";
    }else{
        message = @"";
    }
    
    
    [BioRecognitionManager callBioRecognitionWithController:self Message:message           Success:^(BioRecognitionType type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (type == BioRecognitionTypeFaceID) {
                [BioRecognitionManager saveBioRecognitionTypeWithType:@"FaceID"];
            }else if(type == BioRecognitionTypeTouchID){
                [BioRecognitionManager saveBioRecognitionTypeWithType:@"TouchID"];
            }else{
                
            }
        });
    } Failure:^(NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断开关状态(这里要弹框说明3次：5次：指纹识别不支持)
            if (err.code == -1) {
                //超过3次
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Three_Times_Fail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            if (err.code == -8) {
                //超过5次
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Lock" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
//            CurrentBioRecognitionType type = [BioRecognitionManager getCurrentBioRecognitionType];
//            if (type == CurrentBioRecognitionTypeNull) {
//                [self.bioRecognitionSwitch setOn:NO animated:YES];
//            }else{
//                [self.bioRecognitionSwitch setOn:YES animated:YES];
//            }
        });
    }];
    
}


@end
