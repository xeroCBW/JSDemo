# JSDemo
一个js和oc互相调用的小demo


oc 在调用js的alert时候,会弹框,弹框带有网页的名称的title;这个暂时没有办法解决
![](http://upload-images.jianshu.io/upload_images/874748-b31c08f96ac01b06.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



### oc去掉用html的js

```objc
//OC调用JS，只要利用UIWebView的stringByEvaluatingJavaScriptFromString方法，告诉系统
    [self.webView stringByEvaluatingJavaScriptFromString:@"show();"];

```

### 截取js代码,在oc中执行

```
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
    return YES;
}


```
js代码
```
<script type="text/javascript">
                function show() {
                    alert("oc调用js");
                }
            function showTittle() {
                alert(document.title);
            }
            function aaa() {
                location.href="https://www.baidu.com/";
            }
            function btnClick(){
                location.href="mitchell://call";
            }
            function btnClickTwo(){
                location.href="mitchell://callWithNumber_?10086";
            }
            function btnClickThree(){
                location.href="mitchell://sendMessageWithNumber_WithContent_?10086&love";
            }
            </script>

```
