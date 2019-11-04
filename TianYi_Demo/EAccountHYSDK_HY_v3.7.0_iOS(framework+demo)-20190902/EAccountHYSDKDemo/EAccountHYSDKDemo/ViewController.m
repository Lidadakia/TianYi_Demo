//
//  ViewController.m
//  EAccountHYSDKDemo
//
//  Created by Reticence Lee on 2019/4/28.
//  Copyright © 2019 21CN. All rights reserved.
//

#import "ViewController.h"
#import "EAccountOpenPageSDK.h"
#import "EAccountDemoUtil.h"

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define KphotoScale (iPhone5 ? (0.852f) : (1.0f))

#define kAppKey                  @""    //请在开放平台申请
#define kAppSecret               @""    //请在开放平台申请


@interface ViewController ()

@property (nonatomic,strong) UIButton *hyBtn;
@property (nonatomic,strong) UIButton *hyInterfaceBtn;


@end

@implementation ViewController

//======================================对接说明=======================================//

/**
 * SDK对接步骤：
 * 1.导入天翼账号SDK的framework和bundle
 * 2.按接入文档对工程进行相应配置
 * 3.调用预登录接口
 * 4.打开登录界面（无动态配置）
 *      a.若无自定义页面样式的需求，可使用天翼账号提供的样例，仅需在样例基础上修改App Logo和App Name即可使用。
 *      b.若有自定义页面样式的需求，可参照天翼账号提供的样例，在xib文件上修改即可。
          注意: 1.xib原有控件修改时，tag需按照规定填写，tag规定请参照下方的说明
               2.新增控件若是按钮（仅支持新增3个按钮），其tag也需按照规定填写，按钮按下操作会在openAtuhVC方法的clickHandler中回调，返回tag值。
               3.xib文件可从提供的EAccountOpenPageResource.bundle中获取，（可在新的工程）修改完编译后，需将编译后得到的同名nib文件放到该bundle中，替换原先的nib文件。
 *      （样例包括登录界面、对话框和隐私协议界面的xib文件，以及相应的资源文件，详见本Demo中EAccountOpenPageResource.bundle资源文件。）
 *
 * 5.打开登录界面（支持态配置）
 *      a.3.6.2增加一个接口，支持通过配置项动态修改xib/nib文件的控件属性
 *      b.详细情况请认真阅读EAccountOpenPageConfig类头文件里面的“SDK3.6.2版本注意事项”
 
 * 6.关闭登录界面
 *
 */

/*--------------------------------------登录界面说明--------------------------------------*/

/** 登录界面控件tag值规定
 
注意：3.6.2新增的tag值请查看EAccountOpenPageConfig类头文件里面的说明。

1.左上角导航返回按钮 -------- 21001

2.脱敏号码标签 ------------- 21002

3.小logo图片 -------------- 21003

4.服务提供标签 ------------- 21004

5.登录按钮 ---------------- 21005
5.1 登录按钮loading ---- 210051

6.其他登录方式按钮 ---------- 21006

7.协议勾选框按钮 ----------- 21007

8.服务与隐私协议标签 -------- 21008
 注意：“登录即同意服务与隐私协议” 这12个字不允许改变（字体样式可以修改），后面的“与xxxx协议” 和 “并授权……”可由合作方自由修改，增加或删减。

9.合作方协议 上的按钮 ---- 21009
 注：合作方若增加自己的隐私协议（可参考样例中的“与xxxx协议”），其上方放置了一个按钮，按钮的回调也在openAtuhVC方法的clickHandler中，返回tag值。

10.弹框view --------------------------- 21100
10.1 登录即同意《服务与隐私协议》按钮 ------ 21101
10.2 左边（返回）按钮 ------------------- 21102
10.3 右边（确认登录）按钮 ---------------- 21103
10.4 弹框背景图 ------------------------ 21104

11.额外增加的按钮1 --------- 21301

12.额外增加的按钮2 --------- 21302
 
13.额外增加的按钮3 --------- 21303
*/

/*--------------------------------------隐私协议界面说明--------------------------------------*/

/** 隐私协议界面控件tag值规定

左上角返回按钮 ----------------- 21201

页面进度条 -------------------- 21203

*/


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"天翼账号行业版Demo";
    self.edgesForExtendedLayout = UIRectEdgeNone;//不被导航栏挡住
    self.view.backgroundColor = [UIColor whiteColor];
    [EAccountOpenPageSDK initWithAppId:kAppKey appSecret:kAppSecret];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageV setImage:[UIImage imageNamed:@"homeBG"]];
    [self.view addSubview:imageV];
    UIImageView *imageLOGO = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-154)/2, 40, 154, 105)];
    [imageLOGO setImage:[UIImage imageNamed:@"homeLOGO"]];
    [self.view addSubview:imageLOGO];
    
    UIImageView *imageServer = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-130)/2, kScreenHeight-100, 130, 12)];
    [imageServer setImage:[UIImage imageNamed:@"server"]];
    [self.view addSubview:imageServer];
    
    [self.view addSubview:self.hyInterfaceBtn];
    [self.view addSubview:self.hyBtn];
}

- (UIButton *)hyBtn {
    if (!_hyBtn) {
        _hyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _hyBtn.frame = CGRectMake(25, CGRectGetMaxY(self.hyInterfaceBtn.frame)+15, kScreenWidth-50, KphotoScale*50);
        //背景色
        UIImage *normalGradientBgImage = [self ImageFromGradientColors:@[(id)[self rgbColor:@"023BAD" andAlpha:1.0].CGColor, (id)[self rgbColor:@"266EFF" andAlpha:1.0].CGColor] Frame:CGRectMake(0, 0, _hyBtn.frame.size.width, _hyBtn.frame.size.height)];
        
        [_hyBtn setBackgroundImage:normalGradientBgImage forState:UIControlStateNormal];
        [_hyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_hyBtn setTitle:@"打开登录界面" forState:UIControlStateNormal];
        [_hyBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_hyBtn setClipsToBounds:YES];
        [_hyBtn.layer setCornerRadius:4];
        [_hyBtn addTarget:self action:@selector(hyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hyBtn;
}

- (void)hyBtnClick {
    
    EAccountOpenPageConfig *config = [[EAccountOpenPageConfig alloc] init];
//    config.logoOffsetY = 300;
    config.EAStartIndex = 5;
    config.EAEndIndex = 17;
    config.PANameColor = [UIColor redColor];
    config.pWebNavText = @"合作方协议";
    //3.6.2新增动态配置接口
    dispatch_async(dispatch_get_main_queue(), ^{

        [EAccountOpenPageSDK openAtuhVC:config clickHandler:^(NSString * _Nonnull senderTag) {
            NSLog(@"%@",senderTag);
        } completion:^(NSDictionary * _Nonnull resultDic) {
            NSLog(@"----resultDic22222-%@-----",resultDic);
            [EAccountOpenPageSDK closeOpenAuthVC];
            [EAccountDemoUtil showResultDic:resultDic viewController:self];
        } failure:^(NSError * _Nonnull error) {
            [EAccountOpenPageSDK closeOpenAuthVC];
            [EAccountDemoUtil showResultDic:error.userInfo viewController:self];
        }];

    });
    
    //3.6.1旧接口
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [EAccountOpenPageSDK openAtuhVC:^(NSString * _Nonnull senderTag) {
//            NSLog(@"----senderTag-%@-----",senderTag);
//        } completion:^(NSDictionary * _Nonnull resultDic) {
//            NSLog(@"----resultDic22222-%@-----",resultDic);
//            [EAccountOpenPageSDK closeOpenAuthVC];
//            [EAccountDemoUtil showResultDic:resultDic viewController:self];
//        } failure:^(NSError * _Nonnull error) {
//            [EAccountOpenPageSDK closeOpenAuthVC];
//            [EAccountDemoUtil showResultDic:error.userInfo viewController:self];
//        }];
//    });
    
}
- (UIButton *)hyInterfaceBtn {
    if (!_hyInterfaceBtn) {
        _hyInterfaceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _hyInterfaceBtn.frame = CGRectMake(25, 180, kScreenWidth-50, KphotoScale*50);
        //背景色
        UIImage *normalGradientBgImage = [self ImageFromGradientColors:@[(id)[self rgbColor:@"023BAD" andAlpha:1.0].CGColor, (id)[self rgbColor:@"266EFF" andAlpha:1.0].CGColor] Frame:CGRectMake(0, 0, _hyInterfaceBtn.frame.size.width, _hyInterfaceBtn.frame.size.height)];
        
        [_hyInterfaceBtn setBackgroundImage:normalGradientBgImage forState:UIControlStateNormal];
        [_hyInterfaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_hyInterfaceBtn setTitle:@"调用预登录接口" forState:UIControlStateNormal];
        [_hyInterfaceBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_hyInterfaceBtn setClipsToBounds:YES];
        [_hyInterfaceBtn.layer setCornerRadius:4];
        [_hyInterfaceBtn addTarget:self action:@selector(hyInterfaceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hyInterfaceBtn;
}

- (void)hyInterfaceBtnClick {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [EAccountOpenPageSDK requestPreLogin:6  completion:^(NSDictionary * _Nonnull resultDic){
            NSLog(@"resultDic----->>>>%@",resultDic);
            [EAccountDemoUtil showResultDic:resultDic viewController:self];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error---->>>%@",error);
            [EAccountDemoUtil showResultDic:error.userInfo viewController:self];
        }];
    });
    
}


- (UIImage*) ImageFromGradientColors:(NSArray*)colors Frame:(CGRect)frame{
    UIGraphicsBeginImageContextWithOptions(frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace((CGColorRef)[colors lastObject]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colors, NULL);
    CGPoint start;
    CGPoint end;
    
    start = CGPointMake(0.0, 0.0);
    end = CGPointMake(frame.size.width, 0.0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
-(UIColor *)rgbColor:(NSString *)color andAlpha:(CGFloat)alpha
{
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [color substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [color substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [color substringWithRange:range];
    unsigned int Red = 0, Green = 0, Blue = 0;
    [[NSScanner scannerWithString:rString] scanHexInt:&Red];
    [[NSScanner scannerWithString:gString] scanHexInt:&Green];
    [[NSScanner scannerWithString:bString] scanHexInt:&Blue];
    //    sscanf(color, "%2x%2x%2x", &Red, &Green, &Blue);
    return [UIColor colorWithRed:Red/255.0 green:Green/255.0 blue:Blue/255.0 alpha:alpha];
}


@end
