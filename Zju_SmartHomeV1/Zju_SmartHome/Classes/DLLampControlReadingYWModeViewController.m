//
//  DLLampControlReadingYWModeViewController
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/1.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControlReadingYWModeViewController.h"
#import "ZQSlider.h"
#import "CYFFurnitureViewController.h"
#import "HttpRequest.h"



#import "DLLampControlSleepYWModeViewController.h"
#import "DLLampControlDinnerYWModeViewController.h"
#import "MBProgressHUD+MJ.h"


@interface DLLampControlReadingYWModeViewController ()
@property (nonatomic, weak) UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UILabel *LDValue; /**< light-dark-value */
@property (weak, nonatomic) IBOutlet UILabel *CWValue; /**< cold-warm-value */
@property (nonatomic, weak) UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *leftFront;
@property (weak, nonatomic) IBOutlet UIButton *rightNext;

//YW控制
@property (weak, nonatomic) IBOutlet UIButton *ywAdjust;
//RGB控制
@property (weak, nonatomic) IBOutlet UIButton *rgbAdjust;
//模式选择
@property (weak, nonatomic) IBOutlet UIButton *modeSelect;
//音乐播放
@property (weak, nonatomic) IBOutlet UIButton *musicOpen;

@property(nonatomic,assign)int tag;
@property(nonatomic,assign)int switchTag;
@end

@implementation DLLampControlReadingYWModeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //   self.tag=1;
  
  NSLog(@"8888 %@",self.logic_id);
  
  
  //    self.leftFront.enabled=NO;
  //    self.rightNext.enabled=NO;
  //    self.rgbAdjust.enabled=NO;
  
  [self.modeSelect setAdjustsImageWhenHighlighted:YES];
  [self.modeSelect addTarget:self action:@selector(modeSelected) forControlEvents:UIControlEventTouchUpInside];
  [self.modeSelect setBackgroundImage:[UIImage imageNamed:@"ct_icon_model_press"] forState:UIControlStateNormal];
  
  [self.rightNext addTarget:self action:@selector(rightGo) forControlEvents:UIControlEventTouchUpInside];
  [self.leftFront addTarget:self action:@selector(leftGo) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *leftButton=[[UIButton alloc]init];
  [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
  leftButton.frame=CGRectMake(0, 0, 25, 25);
  [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
  [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
  self.navigationItem.leftBarButtonItem = leftItem;
  
  
  UIButton *rightButton=[[UIButton alloc]init];
  [rightButton setImage:[UIImage imageNamed:@"ct_icon_switch"] forState:UIControlStateNormal];
  rightButton.frame=CGRectMake(0, 0, 30, 30);
  [rightButton setImageEdgeInsets:UIEdgeInsetsMake(-4, 6, 4, -10)];
  [rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
  self.navigationItem.rightBarButtonItem=rightItem;
  
  
  UILabel *titleView=[[UILabel alloc]init];
  [titleView setText:@"YW灯"];
  titleView.frame=CGRectMake(0, 0, 100, 16);
  titleView.font=[UIFont systemFontOfSize:16];
  [titleView setTextColor:[UIColor whiteColor]];
  titleView.textAlignment=NSTextAlignmentCenter;
  self.navigationItem.titleView=titleView;
  
  
  
  UIImageView *imgView = [[UIImageView alloc]init];
  imgView.tag = 10086;
  UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
  viewColorPickerPositionIndicator.tag = 10087;
  UIButton *btnPlay = [[UIButton alloc] init];
  
  ZQSlider *slider = [[ZQSlider alloc] init];
  slider.backgroundColor = [UIColor clearColor];
  
  slider.minimumValue = 0;
  slider.maximumValue = 100;
  slider.value = 30;
  
  [slider setMaximumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
  [slider setMinimumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
  [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
  [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
  self.LDValue.text = [NSString stringWithFormat:@"%d", (int)slider.value];
  slider.continuous = YES;
  
  self.slider = slider;
  [slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
  
  
  if (fabsf(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
    // 5 & 5s & 5c
    imgView.image = [UIImage imageNamed:@"YWCircle_5"];
    viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
    viewColorPickerPositionIndicator.layer.cornerRadius = 8;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(111, 111, 60, 60);
    slider.frame = CGRectMake(40, 260, 200, 10);
    
  }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
    // 6 & 6s
    imgView.image = [UIImage imageNamed:@"YWCircle_6"];
    viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
    viewColorPickerPositionIndicator.layer.cornerRadius = 10;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(135, 135, 60, 60);
    slider.frame = CGRectMake(50, 310, 225, 10);
    
  }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
    // 6p & 6sp
    imgView.image = [UIImage imageNamed:@"YWCircle_6p"];
    viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
    viewColorPickerPositionIndicator.layer.cornerRadius = 12;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(150, 150, 60, 60);
    slider.frame = CGRectMake(85, 340, 200, 10);
    
  }
  
  imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
  
  
  imgView.userInteractionEnabled = YES;
  _imgView = imgView;
  
  viewColorPickerPositionIndicator.backgroundColor = [UIColor colorWithRed:0.996 green:1.000 blue:0.678 alpha:1.000];
  
  [btnPlay setBackgroundImage:[UIImage imageNamed:@"ct_icon_buttonbreak-off"] forState:UIControlStateNormal];
  
  [self.panelView addSubview:imgView];
  [self.panelView addSubview:viewColorPickerPositionIndicator];
  [self.panelView addSubview:btnPlay];
  [self.panelView addSubview:slider];
}

-(void)sliderValueChanged{
  self.LDValue.text = [NSString stringWithFormat:@"%d", (int)self.slider.value ];
  //在这里把亮暗值   (int)self.slider.value   传给服务器
    int value = (int)self.slider.value;
    if (value % 5 == 0) {
  
  [HttpRequest sendYWBrightnessToServer:self.logic_id brightnessValue:[NSString stringWithFormat:@"%d", (int)self.slider.value ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"YW亮暗返回成功：%@",result);
    
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"YW亮暗返回失败：%@",error);
  }];
    }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

/**
 *  判断点触位置，如果点触位置在颜色区域内的话，才返回点触的控件为UIImageView *imgView
 *  除此之外，点触位置落在小圆内部或者大圆外部，都返回nil
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:point];
  if (pointInRound) {
    hitView = imgView;
  }
  return hitView;
}

/**
 *  判断点触位置是否落在了颜色区域内
 */
- (BOOL)touchPointInsideCircle:(CGPoint)center bigRadius:(CGFloat)bigRadius smallRadius:(CGFloat)smallRadius targetPoint:(CGPoint)point
{
  
  CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                       (point.y - center.y) * (point.y - center.y));
  if (dist >= bigRadius || dist <= smallRadius){
    return NO;
  }else{
    return YES;
  }
}

/**
 *  开始点击的方法
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  UITouch *touch = touches.anyObject;
  
  CGPoint touchLocation = [touch locationInView:self.imgView];
  UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:touchLocation];
  if (pointInRound) {
    
    //    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    //    UITouch *touch = touches.anyObject;
    //
    //    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                           bigRadius:imgView.frame.size.width * 0.48
                         smallRadius:imgView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      /**
       *  以下判断代码真的是丧心病狂，63这个值真是可怜，代码不忍直视，为什么写了很多无意思的数值，只是想让YW灯的冷暖值
       *  从零取到一百，生生的把它凑成了一百
       */
      int cwValue = (int)(touchLocation.y / 2.5) - 2;
      if (fabsf(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }
      if (fabsf(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
        
      }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue += 1;
        }
        
      }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue = (float)(cwValue) / 111 * 100;
        }
      }
      
      self.CWValue.text = [NSString stringWithFormat:@"%d", cwValue];
      //在这里把cwValuevalue值传给服务器
      cwValue = 100 - cwValue;
      [HttpRequest sendYWWarmColdToServer:self.logic_id warmcoldValue:[NSString stringWithFormat:@"%d", cwValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"YW冷暖返回成功：%@",result);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"YW冷暖返回失败：%@",error);
      }];
      
    }
  }
}

/**
 *  手指在屏幕上移动的方法
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = touches.anyObject;
  
  CGPoint touchLocation = [touch locationInView:self.imgView];
  UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:touchLocation];
  if (pointInRound) {
    //    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                           bigRadius:imgView.frame.size.width * 0.48
                         smallRadius:imgView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      
      
      int cwValue = (int)(touchLocation.y / 2.5) - 2;
      if (fabsf(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }
      if (fabsf(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue += 1;
        }
      }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue = (float)(cwValue) / 111 * 100;
        }
      }
      self.CWValue.text = [NSString stringWithFormat:@"%d", cwValue];
      
      
      
      int i, j;
      if ((i = arc4random() % 2)) {
        if ((j = arc4random() % 2)) {
          //在这里把cwValuevalue值传给服务器
          
          cwValue = 100 - cwValue;
          [HttpRequest sendYWWarmColdToServer:self.logic_id warmcoldValue:[NSString stringWithFormat:@"%d", cwValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"YW冷暖返回成功：%@",result);
            
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"YW冷暖返回失败：%@",error);
          }];
          
          
          
        }
      }
    }}
  
  
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  UITouch *touch = touches.anyObject;
  
  CGPoint touchLocation = [touch locationInView:self.imgView];
  UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:touchLocation];
  if (pointInRound) {
    
    //    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    //    UITouch *touch = touches.anyObject;
    //
    //    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                           bigRadius:imgView.frame.size.width * 0.48
                         smallRadius:imgView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      /**
       *  以下判断代码真的是丧心病狂，63这个值真是可怜，代码不忍直视，为什么写了很多无意思的数值，只是想让YW灯的冷暖值
       *  从零取到一百，生生的把它凑成了一百
       */
      int cwValue = (int)(touchLocation.y / 2.5) - 2;
      if (fabsf(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }
      if (fabsf(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
        
      }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue += 1;
        }
        
      }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue = (float)(cwValue) / 111 * 100;
        }
      }
      
      self.CWValue.text = [NSString stringWithFormat:@"%d", cwValue];
      //在这里把cwValuevalue值传给服务器
      cwValue = 100 - cwValue;
      [HttpRequest sendYWWarmColdToServer:self.logic_id warmcoldValue:[NSString stringWithFormat:@"%d", cwValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"YW冷暖返回成功：%@",result);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"YW冷暖返回失败：%@",error);
      }];
      
    }
  }
  
}

//*****************************获取屏幕点触位置的RGB值的方法************************************//
- (UIColor *) getPixelColorAtLocation:(CGPoint)point {
  UIColor* color = nil;
  
  UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
  
  CGImageRef inImage = colorImageView.image.CGImage;
  
  CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
  if (cgctx == NULL) {
    return nil;
  }
  size_t w = CGImageGetWidth(inImage);
  size_t h = CGImageGetHeight(inImage);
  CGRect rect = {{0,0},{w,h}};
  
  CGContextDrawImage(cgctx, rect, inImage);
  
  unsigned char* data = CGBitmapContextGetData (cgctx);
  if (data != NULL) {
    int offset = 4*((w*round(point.y))+round(point.x));
    int alpha =  data[offset];
    int red = data[offset+1];
    int green = data[offset+2];
    int blue = data[offset+3];
    
    color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
  }
  
  CGContextRelease(cgctx);
  
  if (data) { free(data); }
  return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
  
  CGContextRef    context = NULL;
  CGColorSpaceRef colorSpace;
  void *          bitmapData;
  int             bitmapByteCount;
  int             bitmapBytesPerRow;
  
  size_t pixelsWide = CGImageGetWidth(inImage);
  size_t pixelsHigh = CGImageGetHeight(inImage);
  
  bitmapBytesPerRow   = (int)(pixelsWide * 4);
  bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
  
  colorSpace = CGColorSpaceCreateDeviceRGB();
  
  if (colorSpace == NULL)
  {
    fprintf(stderr, "Error allocating color space\n");
    return NULL;
  }
  
  bitmapData = malloc( bitmapByteCount );
  if (bitmapData == NULL)
  {
    fprintf (stderr, "Memory not allocated!");
    CGColorSpaceRelease( colorSpace );
    return NULL;
  }
  context = CGBitmapContextCreate (bitmapData,
                                   pixelsWide,
                                   pixelsHigh,
                                   8,
                                   bitmapBytesPerRow,
                                   colorSpace,
                                   kCGImageAlphaPremultipliedFirst);
  if (context == NULL)
  {
    free (bitmapData);
    fprintf (stderr, "Context not created!");
  }
  CGColorSpaceRelease( colorSpace );
  return context;
}

//****************************************结束
- (void)leftBtnClicked{
  
  for (UIViewController *controller in self.navigationController.viewControllers) {
    
    if ([controller isKindOfClass:[CYFFurnitureViewController class]]) {
      
      [self.navigationController popToViewController:controller animated:YES];
      
    }
    
  }
}


-(void)modeSelected
{
  if(self.tag==0)
  {
    self.leftFront.enabled=NO;
    self.rightNext.enabled=NO;
    self.tag++;
    [self.modeSelect setBackgroundImage:[UIImage imageNamed:@"ct_icon_model_unpress"] forState:UIControlStateNormal];
  }
  else
  {
    self.leftFront.enabled=YES;
    self.rightNext.enabled=YES;
    self.tag--;
    [self.modeSelect setBackgroundImage:[UIImage imageNamed:@"ct_icon_model_press"] forState:UIControlStateNormal];
  }
}

-(void)rightGo
{
  
  DLLampControlSleepYWModeViewController *sleep = [[DLLampControlSleepYWModeViewController alloc] init];
  sleep.logic_id = self.logic_id;
  [self.navigationController pushViewController:sleep animated:true];
  
  
}
-(void)leftGo
{
  
  for (UIViewController *controller in self.navigationController.viewControllers)
  {
    if ([controller isKindOfClass:[DLLampControlDinnerYWModeViewController class]])
    {
      
      DLLampControlDinnerYWModeViewController *vc=[[DLLampControlDinnerYWModeViewController alloc]init];
      vc=(DLLampControlDinnerYWModeViewController *)controller;
      vc.logic_id=self.logic_id;
      [self.navigationController popToViewController:vc animated:YES];
      
    }
    
  }
  
  
  
  
}

//电器开关按钮
-(void)rightBtnClicked
{
  NSLog(@"开关按钮点击事件");
  //说明灯是关着的
  if(self.switchTag==0)
  {
    self.switchTag++;
    
    [HttpRequest sendYWBrightnessToServer:self.logic_id brightnessValue:@"100"
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                    NSLog(@"成功: %@", string);
                                    
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"失败: %@", error);
                                    [MBProgressHUD showError:@"请检查网关"];
                                    
                                  }];
    
  }
  else if (self.switchTag==1)
  {
    self.switchTag--;
    
    [HttpRequest sendYWBrightnessToServer:self.logic_id brightnessValue:@"0"
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                    NSLog(@"成功: %@", string);
                                    
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                    NSLog(@"失败: %@", error);
                                    [MBProgressHUD showError:@"请检查网关"];
                                    
                                    
                                  }];
  }
  
}

@end
