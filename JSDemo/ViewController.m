//
//  ViewController.m
//  JSDemo
//
//  Created by chenbowen on 2017/7/11.
//  Copyright © 2017年 chenbowen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL*url = [[NSBundle mainBundle] URLForResource:@"test.html" withExtension:nil];
    NSURLRequest*request = [NSURLRequest requestWithURL:url];
    self.webView.delegate =self;
    [self.webView loadRequest:request];

}



//每次请求都会调用
//利用该方法作为JS和OC之间的桥梁
//JS跳转网页
//在OC代理方法中通过判断自定义协议头，决定是否是JS调用OC方法
//在OC代理方法中通过截取字符串，获取JS想调用的OC方法名称
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
        NSLog(@"%@",request.URL);
   ///JS调用OC 无参数
        NSString*schem = @"mitchell://";
        NSString*urlStr = request.URL.absoluteString;
        if ([urlStr hasPrefix:schem]) {
            NSLog(@"调用OC方法");
            //1、从URL汇总获取方法名称
            //Mitchell：//call
            NSString*methodName = [urlStr substringFromIndex:schem.length];
            NSLog(@"%@",methodName);
            //2、调用方法
            SEL sel = NSSelectorFromString(methodName);
            //下面这一行代码是用于指定忽略警告信息
            //忽略警告信息的作用开始
    #pragma clang diagnostic push
            //忽略的警告信息
    #pragma clang diagnostic ignored"-Warc-performSelector-leaks"
            [self performSelector:sel withObject:nil];
            //忽略警告信息的作用结束
    #pragma clang diagnostic pop
    
            return NO;
        }
    //1个参数
    //    NSString*schem = @"mitchell://";
    //    NSString*urlStr = request.URL.absoluteString;
    //    if ([urlStr hasPrefix:schem]) {
    //        NSLog(@"调用OC方法");
    //        //1、从URL汇总获取方法名称
    //        NSString*subPath = [urlStr substringFromIndex:schem.length];
    //        //注意：如果制定的用于切割字符串不存在，就会返回整个字符串
    //        NSArray*subPaths = [subPath componentsSeparatedByString:@"?"];
    //        //2、获取方法名称
    //        NSString*methodName = [subPaths firstObject];
    //        methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    //        NSLog(@"%@",methodName);
    //        //3、调用方法
    //        SEL sel = NSSelectorFromString(methodName);
    //        NSString*params = nil;
    //        if (subPaths.count ==2) {
    //            params = [subPaths lastObject];
    //        }
    //        [self performSelector:sel withObject:params];
    //        return NO;
    //    }
    //2个参数
    //    NSString*schem = @"mitchell://";
    //    NSString*urlStr = request.URL.absoluteString;
    //    if ([urlStr hasPrefix:schem]) {
    //        NSLog(@"调用OC方法");
    //        //1、从URL汇总获取方法名称
    //        NSString*subPath = [urlStr substringFromIndex:schem.length];
    //        //注意：如果制定的用于切割字符串不存在，就会返回整个字符串
    //        //sendMessageWithNumber_WithContent_?10086&love
    //        NSArray*subPaths = [subPath componentsSeparatedByString:@"?"];
    //        //2、获取方法名称
    //        NSString*methodName = [subPaths firstObject];
    //        methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    //        //3、调用方法
    //        SEL sel = NSSelectorFromString(methodName);
    //        NSString*param = nil;
    //        if (subPaths.count ==2) {
    //            param = [subPaths lastObject];
    //            //3、截取参数
    //            NSArray*params = [param componentsSeparatedByString:@"&"];
    //            [self performSelector:sel withObject:[params firstObject] withObject:[params lastObject]];
    //            return NO;
    //        }
    //        [self performSelector:sel withObject:param];
    //        return NO;
    //    }
    //多个参数，这里使用了用NSInvocation封装的一个类
//    NSString*schem = @"mitchell://";
//    NSString*urlStr = request.URL.absoluteString;
//    if ([urlStr hasPrefix:schem]) {
//        NSLog(@"调用OC方法");
//        //1、从URL汇总获取方法名称
//        NSString*subPath = [urlStr substringFromIndex:schem.length];
//        //注意：如果制定的用于切割字符串不存在，就会返回整个字符串
//        //sendMessageWithNumber_WithContent_?10086&love
//        NSArray*subPaths = [subPath componentsSeparatedByString:@"?"];
//        //2、获取方法名称
//        NSString*methodName = [subPaths firstObject];
//        methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
//        //3、调用方法
//        SEL sel = NSSelectorFromString(methodName);
//        NSArray *params = nil;
//        if (subPaths.count ==2) {
//            //3、截取参数
//            params = [[subPaths lastObject] componentsSeparatedByString:@"&"];
//            [self performSelector:sel withObjects:params];
//            return NO;
//        }
//        [self performSelector:sel withObjects:params];
//        return NO;
//    }
    return YES;
}

- (void)call{
    
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"js调用oc" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"yes" style:0 handler:nil];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}


/*
 oc调用js
 */
- (IBAction)oc2js:(id)sender {
    
    //OC调用JS，只要利用UIWebView的stringByEvaluatingJavaScriptFromString方法，告诉系统
    [self.webView stringByEvaluatingJavaScriptFromString:@"show();"];
    

}

@end
