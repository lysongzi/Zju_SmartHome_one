//
//  DLLampControlDinnerModeViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/11/28.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControlDinnerModeViewController.h"
#import "AFNetworking.h"
#import "ZQSlider.h"
#import "HttpRequest.h"
#import "MBProgressHUD+MJ.h"
#import "CYFFurnitureViewController.h"
#import "DLLampControlGuestModeViewController.h"
#import "DLLampControlReadingModeViewController.h"
#import "AppDelegate.h"

#import "HttpRequest.h"

@interface DLLampControlDinnerModeViewController ()
@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UILabel *rValue;
@property (weak, nonatomic) IBOutlet UILabel *gValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;

@property (weak, nonatomic) IBOutlet UIView *colorPreview;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, assign) CGPoint *touchPoint;
@property (nonatomic, weak) UISlider *slider;

//向左调模式
@property (weak, nonatomic) IBOutlet UIButton *leftFront;
//向右调模式
@property (weak, nonatomic) IBOutlet UIButton *rightNext;
//YW
@property (weak, nonatomic) IBOutlet UIButton *ywAdjust;
//RGB
@property (weak, nonatomic) IBOutlet UIButton *rgbAdjust;
//模式选择
@property (weak, nonatomic) IBOutlet UIButton *modeSelect;
@property(nonatomic,assign)int tag;
@property(nonatomic,assign)int switchTag;
@end

@implementation DLLampControlDinnerModeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    
    NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",96]];
    NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",8]];
    
    NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",213]];
    
    [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  NSLog(@"失败: %@", error);
                                  [MBProgressHUD showError:@"请检查网关"];
                                  
                              }];
    

  
  //self.tag=1;
    self.switchTag=1;
  [self.modeSelect addTarget:self action:@selector(modeSelected) forControlEvents:UIControlEventTouchUpInside];
  [self.modeSelect setBackgroundImage:[UIImage imageNamed:@"ct_icon_model_press"] forState:UIControlStateNormal];
  
  [self.leftFront addTarget:self action:@selector(leftGo) forControlEvents:UIControlEventTouchUpInside];
  [self.rightNext addTarget:self action:@selector(rightGo) forControlEvents:UIControlEventTouchUpInside];
  
  
  UIButton *leftButton=[[UIButton alloc]init];
  [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
  leftButton.frame=CGRectMake(0, 0, 25, 25);
  [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
  [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
  self.navigationItem.leftBarButtonItem = leftItem;
  
  UILabel *titleView=[[UILabel alloc]init];
  [titleView setText:@"RGB灯"];
  titleView.frame=CGRectMake(0, 0, 100, 16);
  titleView.font=[UIFont systemFontOfSize:16];
  [titleView setTextColor:[UIColor whiteColor]];
  titleView.textAlignment=NSTextAlignmentCenter;
  self.navigationItem.titleView=titleView;
  
  UIButton *rightButton=[[UIButton alloc]init];
  [rightButton setImage:[UIImage imageNamed:@"ct_icon_switch"] forState:UIControlStateNormal];
  rightButton.frame=CGRectMake(0, 0, 30, 30);
  [rightButton setImageEdgeInsets:UIEdgeInsetsMake(-4, 6, 4, -10)];
  [rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
  self.navigationItem.rightBarButtonItem=rightItem;
  
  
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
  
  [slider setMaximumTrackImage:[UIImage imageNamed:@"blackblue"] forState:UIControlStateNormal];
  [slider setMinimumTrackImage:[UIImage imageNamed:@"blackblue"] forState:UIControlStateNormal];
  [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
  [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
  
  slider.continuous = YES;
  
  self.slider = slider;
  [slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
  
  if (fabsf(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
    // 5 & 5s & 5c
    imgView.image = [UIImage imageNamed:@"circle_5"];
    viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
    viewColorPickerPositionIndicator.layer.cornerRadius = 8;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(111, 111, 60, 60);
    slider.frame = CGRectMake(40, 260, 200, 10);
    
  }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
    // 6 & 6s
    imgView.image = [UIImage imageNamed:@"circle_6"];
    viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
    viewColorPickerPositionIndicator.layer.cornerRadius = 10;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(135, 135, 60, 60);
    slider.frame = CGRectMake(50, 310, 225, 10);
    
  }else if (fabsf(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
    // 6p & 6sp
    imgView.image = [UIImage imageNamed:@"circle_6p"];
    viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
    viewColorPickerPositionIndicator.layer.cornerRadius = 12;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(150, 150, 60, 60);
    slider.frame = CGRectMake(85, 340, 200, 10);
    
  }
  
  imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
  
  
  imgView.userInteractionEnabled = YES;
  _imgView = imgView;
  
  viewColorPickerPositionIndicator.backgroundColor = [UIColor colorWithRed:0.678 green:0.169 blue:0.710 alpha:1.000];
  
  [btnPlay setBackgroundImage:[UIImage imageNamed:@"ct_icon_buttonbreak-off"] forState:UIControlStateNormal];
  
  [self.panelView addSubview:imgView];
  [self.panelView addSubview:viewColorPickerPositionIndicator];
  [self.panelView addSubview:btnPlay];
  [self.panelView addSubview:slider];
}

-(void)sliderValueChanged
{
  NSLog(@"%f", self.slider.value);
    int value = (int)self.slider.value;
    if (value % 5 == 0) {
  [HttpRequest sendRGBBrightnessToServer:self.logic_id brightnessValue:[NSString stringWithFormat:@"%f", self.slider.value]
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
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      //在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
      
      [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
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
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    //!!!:ATTENTION
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      // NSLog(@"哈哈哈哈哈%@ %@ %@",r,g,b);
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      
      int i, j, k;
      if ((i = arc4random() % 2)) {
        if ((j = arc4random() % 2)) {
          if ((k = arc4random() % 2)) {
            ////在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
            
            [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
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
      }
    }
  }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  NSLog(@"滑动结束");
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
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      //在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
      
      [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
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

//向右切换模式
-(void)rightGo
{
  DLLampControlReadingModeViewController *vc=[[DLLampControlReadingModeViewController alloc]init];
  vc.logic_id=self.logic_id;
  [self.navigationController pushViewController:vc animated:YES];
}
//向左切换模式
-(void)leftGo
{
  for (UIViewController *controller in self.navigationController.viewControllers)
  {
    if ([controller isKindOfClass:[DLLampControlGuestModeViewController class]])
    {
      
      DLLampControlGuestModeViewController *vc=[[DLLampControlGuestModeViewController alloc]init];
      vc=(DLLampControlGuestModeViewController *)controller;
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
    
    [HttpRequest sendRGBBrightnessToServer:self.logic_id brightnessValue:@"100"
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
    
    [HttpRequest sendRGBBrightnessToServer:self.logic_id brightnessValue:@"0"
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
