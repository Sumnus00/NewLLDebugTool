NewLLDebugTool
===========

源工程是<https://github.com/HDB-Li/LLDebugTool>，感谢作者开源。

[![Version](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.2.2-blue.svg)](https://img.shields.io/badge/pod-v1.2.2-blue.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)

## 介绍

[Click here for an English introduction](https://github.com/didiaodanding/NewLLDebugTool)

NewLLDebugTool是在开源工程[LLDebugTool](https://github.com/HDB-Li/LLDebugTool])上的二次开发 . NewLLDebugTool改变和优化了LLDebug的内存计算和Log的实现方式。同时，NewLLdebugTool增加了更多的实用更能，比如拦截私有网络，支持弱网和随身版monkey功能。



## 安装

[CocoaPods](http://cocoapods.org) 是集成`NewLLDebugTool`的首选方式。

#### Objective - C

> 1. 添加 `pod 'NewLLDebugTool' , '~> 1.3.0'` 到你的Podfile里。如果只想在Debug模式下使用，则添加`pod 'NewLLDebugTool' , '~> 1.3.0' ,:configurations => ['Debug']` 到你的Podfile里 。
> 2. 如果你想使用某一个模块，可是添加`pod 'NewLLDebugTool/{Component Name}' , '~> 1.3.0'`到你的Podfile里。目前支持的组件有
> ```
> pod 'NewLLDebugTool/AppInfo'
> pod 'NewLLDebugTool/Crash'
> pod 'NewLLDebugTool/Log'
> pod 'NewLLDebugTool/Network'
> pod 'NewLLDebugTool/Sandbox'
> pod 'NewLLDebugTool/Screenshot'
> ```
> 3. 终端输入`pod install`来进行集成。搜索不到`NewLLDebugTool`或者搜不到最新版本时，可先运行`pod repo update`，再执行`pod install`。
> 4. 在你需要使用NewLLDebugTool的文件里添加`#import "LLDebug.h"`，或者直接在pch文件中添加`#import "LLDebug.h"`。


## 如何使用

### 启动

你需要在"application:(UIApplication * )application didFinishLaunchingWithOptions:(NSDictionary * )launchOptions"中启动NewLLDebugTool，否则你可能会丢掉某些信息。

如果你想自定义一些参数，你需要在调用"startWorking"前配置这些参数。更详细的配置信息请看[LLConfig.h](https://github.com/didiaodanding/NewLLDebugTool/blob/master/NewLLDebugTool/Config/LLConfig.h)。

* `快速启动`

In Objective-C

```Objective-C
#import "AppDelegate.h"
#import "LLDebug.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // The default color configuration is green background and white text color. 

    // Start working.
    [[LLDebugTool sharedTool] startWorking];
    
    // Write your project code here.
    return YES;
}
```

* `使用自定义的配置启动`

In Objective-C

```Objective-C
#import "AppDelegate.h"
#import "LLDebug.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //####################### Color Style #######################//
    // Uncomment one of the following lines to change the color configuration.
    // [LLConfig sharedConfig].colorStyle = LLConfigColorStyleSystem;
    // [[LLConfig sharedConfig] configBackgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] statusBarStyle:UIStatusBarStyleDefault];
    
    //####################### User Identity #######################//
    // Use this line to tag user. More config please see "LLConfig.h".
    [LLConfig sharedConfig].userIdentity = @"Miss L";
    
    //####################### Window Style #######################//
    // Uncomment one of the following lines to change the window style.
    // [LLConfig sharedConfig].windowStyle = LLConfigWindowNetBar;

    //####################### Features #######################//
    // Uncomment this line to change the available features.
    // [LLConfig sharedConfig].availables = LLConfigAvailableNoneAppInfo;
    
    // ####################### Start LLDebugTool #######################//
    // Use this line to start working.
    [[LLDebugTool sharedTool] startWorking];
    
    return YES;
}
```

### 日志

打印和保存一个日志。

* `保存日志`

In Objective-C

```Objective-C
#import "LLDebug.h"

- (void)testNormalLog {
    // Insert an LLog where you want to print.
    NSLog(@"Message you want to save or print.");
}
```


### 网络请求

你不需要做任何操作，只需要调用了"startWorking"就可以监控大部分的网络请求，包括使用NSURLSession，NSURLConnection和AFNetworking。如果你发现某些情况下无法监控网络请求，请打开一个issue来告诉我。这一部分是和LLDebugTool一样的。注意：如果你想要监控私有网络，你需要在你的工程里添加swizzle方法来hook发送和接受函数

### 崩溃

这一部分是和LLDebugTool一样的。你不需要做任何操作，只需要调用"startWorking"就可以截获崩溃，保存崩溃信息、原因和堆栈信息，并且也会同时保存当次网络请求和日志信息。

### App信息

因为LLDebugTool获得的内存和Xcode不一致，所以NewLLDebugTool改变了内存的计算方式，从而达到和xcode获得的内存数据一致。其他功能和LLDebugTool一样，没有更改。会监控app的CPU和FPS，可以更便捷的查看app的各种信息。

### 沙盒

这一部分是和LLDebugTool一样的。NewLLDebugTool提供了一个快捷的方式来查看和操作沙盒文件，你可以更轻松的删除沙盒中的文件/文件夹，或者通过airdrop来分享文件/文件夹。只要是apple支持的文件格式，你可以直接通过NewLLDebugTool来预览。

### 弱网

如果你已经hook了工程的私有网络，你还需要添加延时和丢包函数来模拟弱网功能。

### 随身版monkey

你不需要做任何操作，只需要调用"startWorking"和打开monkey开关。随身版monkey就会每三秒钟触发一次点击事件，你将会看到app自动运行。

### 更多使用

* 你可以下载并运行[NewLLDebugToolDemo](https://github.com/didiaodanding/NewLLDebugTool/archive/master.zip)来发现NewLLDebugTool的更多使用方式。Demo是在XCode9.3，ios 11.3，cocoapods 1.5.0下运行的，如果有任何版本兼容问题，请告诉我。

## 要求

NewLLDebugTool的要求和LLDebugToo是一致的。NewLLDebugTool需要运行在ios8+，并且使用ARC模式。使用到的框架已经包含在大多数Xcode模板中:

* `UIKit`

* `Foundation`

* `SystemConfiguration`

* `Photos`

* `QuickLook`

## 结构

* `LLDebug.h` 公用头文件。

    >全局引用此文件即可。

* `DebugTool` 工具文件。

    >用于启动和停止LLDebugTool，你需要看一下"LLDebugTool.h"这个文件。

* `Config` 配置文件。

    >用于自定义颜色、大小、标识和其他信息。如果您想要配置任何东西，您需要关注这个文件。

* `Components` 组件文件。

    >如果你对功能的实现原理不感兴趣，那么可以忽略这个文件夹。
    >每个组件文件夹下分为 `Function` 和 `UserInterface`，`Function` 是具体功能实现，`UserInterface`是具体UI搭建。
  
  - `AppInfo` 用于监视应用程序的各种属性，依赖于`General`。
  - `Crash` 用于当App发生崩溃时，收集崩溃信息，依赖于`LLStorageManager`。
  - `Log` 快速打印和保存日志，依赖于`LLStorageManager`。
  - `Network` 用于监视网络请求，依赖于`LLStorageManager`。
  - `Sandbox` Sandbox Helper，用于查看和操作沙盒文件。依赖于`General`。
  - `Screenshot` 用于处理和展示截屏事件，依赖于`General`。
  - `LLStorageManager` Storage Helper。用于数据存储和读取，依赖于`General`。
  - `General` 其他组件的基础组件，依赖于`Config`。
 
## 联系

- **如果你需要帮助**，打开一个issue。
- **如果你想问一个普遍的问题**，打开一个issue。
- **如果你发现了一个bug**，_并能提供可靠的复制步骤_，打开一个issue。
- **如果你有一个功能请求**，打开一个issue。
- **如果你发现有什么不对或不喜欢的地方**，就打开一个issue。
- **如果你有一些好主意或者一些需求**，请发邮件[1404012659@qq.com](1404012659@qq.com)给我。
- **如果你想贡献**，提交一个pull request。

## 联系

- 可以发邮件到[1404012659@qq.com](1404012659@qq.com)

## 更新日志

### 2019-2-26

>1. 更改和优化了内存和log的实现方式
>2. hook私有网络、增加了延时和丢包函数来模拟弱网络
>3. 增加随身版monkey功能

## 许可

这段代码是根据 [MIT license](LICENSE) 的条款和条件发布的。
