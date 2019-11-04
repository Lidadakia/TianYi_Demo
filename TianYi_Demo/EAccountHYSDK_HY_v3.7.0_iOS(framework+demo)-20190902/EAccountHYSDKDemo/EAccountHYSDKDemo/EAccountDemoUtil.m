//
//  EAccountDemoUtil.m
//  EAccountHYSDKDemo
//
//  Created by Reticence Lee on 2019/4/29.
//  Copyright © 2019 21CN. All rights reserved.
//

#import "EAccountDemoUtil.h"

@implementation EAccountDemoUtil


+ (void)showAlert:(NSString*)title message:(NSString*)message viewController:(UIViewController *)viewController
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        //IOS 9.0废弃的功能。
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //IOS 8.0开始支持的功能。
        
        UIAlertController * view = [UIAlertController alertControllerWithTitle:title  message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [view addAction:cancelAction];
        
        //弹出提示框；
        [viewController presentViewController:view animated:true completion:nil];
    }
#else
    {
        //IOS 8.0开始支持的功能。
        
        UIAlertController * view = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [view addAction:cancelAction];
        
        //弹出提示框；
        [viewController presentViewController:view animated:true completion:nil];
    }
#endif
}

+ (void)showResultDic:(NSDictionary *)result viewController:(UIViewController *)viewController{
    NSString *strShow = @"";
    NSArray * sortKey = [self sortKey:result];
    for (id key in sortKey)
    {
        id value = result[key];
        NSString *valueStr = @"";
        if ([value isKindOfClass:[NSNumber class]])
        {
            valueStr = [NSString stringWithFormat:@"%ld", (long)[value integerValue]];
        }
        
        if ([value isKindOfClass:[NSString class]])
        {
            valueStr = value;
        }
        
        if ([key isEqualToString:@"nickName"])
        {
            valueStr = [self parseHtml:valueStr];
        }
        
        strShow = [strShow stringByAppendingFormat:@"%@=%@;\n", key, valueStr];
    }
    [self showAlert:@"提示" message:strShow viewController:viewController];
    //    [self showModalDialog:@"提示" withContent:strShow viewController:viewController];
}

+ (NSArray*)sortKey:(NSDictionary*)dictionary
{
    NSArray *keys = dictionary.allKeys;
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return sortedArray;
}

/**
 * @description 解析html，进行特殊字符转义
 * @param html 字符串
 * @return 返回字字符串
 */
+ (NSString *) parseHtml:(NSString*)html
{
    NSString * string = html;
    
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;"   withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;"   withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    string = [string stringByReplacingOccurrencesOfString:@"&#34;"  withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&#39;"  withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&#38;"  withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&#60;"  withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&#62;"  withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&#160;" withString:@" "];
    
    return string;
}

@end
