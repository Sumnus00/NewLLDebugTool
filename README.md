NewLLDebugTool
===========

源工程是<https://github.com/HDB-Li/LLDebugTool>，感谢作者开源。

[![Version](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.3.2-blue.svg)](https://img.shields.io/badge/pod-v1.2.2-blue.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)

## 开发背景

<!-- [Click here for an English introduction](https://github.com/didiaodanding/NewLLDebugTool) -->

1. 在实际的app自动化测试过程中，通常是ui自动化、逻辑自动化(白盒测试)、压力测试(monkey)、Fuzzy测试(mock)、性能测试。
但是我们通常只做单一自动化测试，关心单一自动化测试的效果，比如做性能的只关心cpu、内存、卡顿这些数据的上报，做monkey的只关心monkey能否遍历所有控件。很少相互结合从而产生1+1 > 2的效果。比如mock+逻辑自动化，monkey+性能测试，monkey+mock等等
都有可能产生神奇的化学反应，所以有必要需要一个SDK可以将这些各种各样的自动化方案就行集成。

2. 在实际的app开发过程中，无论是开发还是测试都会在app中加一些小工具，比如日志上传、环境切换等。这些小工具在每个app里的作用都是相似的，
所以也有必要需要一个SDK可以将这些通用的小工具集成在一起，进行沉底，从而可以快速复用。

## 效果演示
<div align="center">
<img src="https://github.com/didiaodanding/ImageRepository/blob/master/NewLLDebugTool/app.jpeg" width="33%"></img>
<img src="https://github.com/didiaodanding/ImageRepository/blob/master/NewLLDebugTool/monkey.jpeg" width="33%"> </img>
<img src="https://github.com/didiaodanding/ImageRepository/blob/master/NewLLDebugTool/tools.jpeg" width="33%"> </img>
</div>

## 功能模块
### 一、工具集：
1. **【网络查看】** 可以监控大部分的网络请求，包括使用NSURLSession，NSURLConnection和AFNetworking；
2. **【Crash查看】** 可以截获Crash，保存Crash信息、原因和堆栈信息；
3. **【app信息查看】** 可以监控app的内存、CPU和FPS，可以便捷的查看app的各种信息；
4. **【沙盒】** 提供了一个快捷的方式来查看和操作沙盒文件，你可以更轻松的删除沙盒中的文件/文件夹，或者通过airdrop来分享文件/文件夹。只要是apple支持的文件格式，你可以直接通过NewLLDebugTool来预览；
5. **【日志查看】** 可以方便的查看日志。

### 二、自动化：
1. **【iOS monkey】** 支持算法配置、黑白名单配置、运行时间设置，可以便捷的对app进行monkey测试（完成度100%）；
2. **【cocos monkey】** 支持算法配置、黑白名单配置、运行时间设置，可以便捷的对app进行monkey测试（完成度80%）；
3. **【逻辑自动化】** 支持对app进行逻辑自动化测试 （0%）；
4. **【ui自动化】** 支持对app进行ui自动化（0%）；
5. **【Fuzzy测试】** 已完成私有网络协议的mock(这一部分暂不开源，内部产品使用)，待完成http协议mock（完成度50%）；
6. **【性能测试】** 可以监控app的内存、cup和FPS，待完成内存泄漏的监控（完成度50%）；

## 安装

[CocoaPods](http://cocoapods.org) 集成`NewLLDebugTool`。

#### Objective - C

> 1. 添加 `pod 'NewLLDebugTool'` 到你的Podfile里。如果只想在Debug模式下使用，则添加`pod 'NewLLDebugTool' ,:configurations => ['Debug']` 到你的Podfile里 。
> 2. 终端输入`pod install`来进行集成。搜索不到`NewLLDebugTool`或者搜不到最新版本时，可先运行`pod repo update`，再执行`pod install`。
> 3. 在AppDelegate中添加头文件`#import "<NewLLDebugTool/LLDebug.h>"`。
> 4. 在`"application:(UIApplication * )application didFinishLaunchingWithOptions:(NSDictionary * )launchOptions"`中添加`[[LLDebugTool sharedTool] startWorking]` 如下所示：

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

### 更多使用

* 你可以下载并运行[NewLLDebugToolDemo](https://github.com/didiaodanding/NewLLDebugTool/archive/master.zip)来发现NewLLDebugTool的更多使用方式。Demo是在XCode9.3，ios 11.3，cocoapods 1.5.0下运行的，如果有任何版本兼容问题，请告诉我。

 
## 联系

- **如果你需要帮助**，打开一个issue。
- **如果你想问一个普遍的问题**，打开一个issue。
- **如果你发现了一个bug**，_并能提供可靠的复制步骤_，打开一个issue。
- **如果你有一个功能请求**，打开一个issue。
- **如果你发现有什么不对或不喜欢的地方**，就打开一个issue。
- **如果你有一些好主意或者一些需求**，请发邮件[1404012659@qq.com](1404012659@qq.com)给我。
- **如果你想贡献**，提交一个pull request，请发邮件[1404012659@qq.com](1404012659@qq.com)给我。

## 联系

- 可以发邮件到[1404012659@qq.com](1404012659@qq.com)

## 更新日志

### 2019-7-3(tag:1.3.2)
>1. ios monkey增加权重快速遍历算法和随机遍历算法
>2. ios monkey增加配置界面：算法设置、黑白名单设置、执行时间设置
>3. ios monkey增加覆盖率显示
>4. 修复KIF执行失败的错误
>5. 增加log上传接口

### 2019-5-15(tag:1.3.1)
>1. 增加cocos monkey功能
>2. 修复横竖屏截图兼容性问题
>3. 使用oc重写了swift monkey paws
>4. ios monkey 增加控件识别能力

### 2019-4-09(tag:1.3.0)
>1. 可以分享文件夹
>2. 增加monkey paws
>3. 兼容横竖屏


### 2019-2-26(tag:1.2.9)

>1. 更改和优化了内存和log的实现方式
>2. hook私有网络、增加了延时和丢包函数来模拟弱网络
>3. 增加随身版monkey功能

## 许可

这段代码是根据 [MIT license](LICENSE) 的条款和条件发布的。
