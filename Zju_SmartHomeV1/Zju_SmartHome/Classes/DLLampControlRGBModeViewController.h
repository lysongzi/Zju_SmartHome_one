//
//  DLLampControlRGBModeViewController.h
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/2.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLLampControlRGBModeViewController : UIViewController
@property(nonatomic,copy)NSString *logic_id;

@property (weak, nonatomic) IBOutlet UIButton *leftFront;
@property (weak, nonatomic) IBOutlet UIButton *rightNext;
@property (weak, nonatomic) IBOutlet UIButton *modeSelect;
@property (weak, nonatomic) IBOutlet UIButton *rgbAdjust;
@end
