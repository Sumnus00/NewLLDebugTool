NewLLDebugTool
===========

Fork from: <https://github.com/HDB-Li/LLDebugTool>

[![Version](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)](https://img.shields.io/badge/IOS-%3E%3D8.0-f07e48.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.2.2-blue.svg)](https://img.shields.io/badge/pod-v1.2.2-blue.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-91bc2b.svg)](https://img.shields.io/badge/license-MIT-91bc2b.svg)
[![Language](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)](https://img.shields.io/badge/Language-Objective--C%20%7C%20Swift-yellow.svg)

## Introduction

[点击查看中文简介](https://github.com/didiaodanding/NewLLDebugTool/blob/master/README-cn.md)

NewLLDebugTool is the extension of [LLDebugTool](https://github.com/HDB-Li/LLDebugTool]). It partly changes and optimized  of the software implementation , such as memory info and log info . at the same time , it also adds a lot of funcitonalities ,such as hook private network , add weak network and portable monkey features.

## Installation

[CocoaPods](http://cocoapods.org) is the recommended way to add `NewLLDebugTool` to your project.

#### Objective - C

> 1. Add a pod entry for NewLLDebugTool to your Podfile `pod 'NewLLDebugTool' , '~> 1.3.2'`, If only you want to use it in Debug mode, Add a pod entry for NewLLDebugTool to your Podfile `pod 'NewLLDebugTool' ,'~> 1.3.2' ,:configurations => ['Debug']`.
> 2. If you want to use a module, add a pod entry for NewLLDebugTool to your Podfile `pod 'NewLLDebugTool/{Component Name}', '1.3.2'`, Currently supported components are
> ```
> pod 'NewLLDebugTool/AppInfo'
> pod 'NewLLDebugTool/Crash'
> pod 'NewLLDebugTool/Log'
> pod 'NewLLDebugTool/Network'
> pod 'NewLLDebugTool/Sandbox'
> pod 'NewLLDebugTool/Screenshot'
> ```
> 3. Install the pod(s) by running `pod install`. If you can't search `NewLLDebugTool` or you can't find the newest release version, running `pod repo update` before `pod install`.
> 4. Include NewLLDebugTool wherever you need it with `#import "LLDebug.h"` or you can write `#import "LLDebug.h"` in your .pch file.

## Usage

### Get Started

You need to start NewLLDebugTool at "application:(UIApplication * )application didFinishLaunchingWithOptions:(NSDictionary * )launchOptions", Otherwise you will lose some information. 

If you want to configure some parameters, must configure before "startWorking". More config details see [LLConfig.h](https://github.com/didiaodanding/NewLLDebugTool/blob/master/NewLLDebugTool/Config/LLConfig.h).

* `Quick Start`

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

* `Start With Custom Config`

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


### Log

Print and save a log. 

* `Save Log`

In Objective-C

```Objective-C
#import "LLDebug.h"

- (void)testNormalLog {
    // Insert an LLog where you want to print.
    NSLog(@"Message you want to save or print.");
}
```

### Network Request

You don't need to do anything, just call the "startWorking" will monitoring most of network requests, including the use of NSURLSession, NSURLConnection and AFNetworking. If you find that you can't be monitored in some cases, please open an issue and tell me. no changes have been made to the above functions of LLDebugTool . notice , if you want to monitor private network , you need to add swizzle method to your project for hook send and receive function . 

### Crash

no changes have been made to the function of LLDebugTool . You don't need to do anything, just call the "startWorking" to intercept the crash, store crash information, cause and stack informations, and also store the network requests and log informations at the this time.

### AppInfo

Because the memory calculated by the LLDebugTool is inconsistent with xcode , NewLLDebugTool changes how memory is calculated .the other functions is same with LLDebugTool to monitors the app's CPU and FPS. At the same time, you can also quickly check the various information of the app.

### Sandbox

no changes have been made to the function of LLDebugTool . NewLLDebugTool provides a quick way to view and manipulate sandbox, you can easily delete the files/folders inside the sandbox, or you can share files/folders by airdrop elsewhere. As long as apple supports this file format, you can preview the files directly in NewLLDebugTool.

### Weak Network

if you hook the private network , you also need to add delay and packet loss functions to implement this module

### portable monkey

You don't need to do anything, just call the "startWorking" and open the monkey switch . protable monkey will rigger a click event every three seconds , you will see the app runs automatically .

### More Usage

* You can download and run the [LLDebugToolDemo](https://github.com/didiaodanding/NewLLDebugTool/archive/master.zip) to find more use with NewLLDebugTool. The demo is build under XCode9.3, ios 11.3 and cocoapods 1.5.0. If there is any version compatibility problem, please let me know.  

# Requirements

NewLLDebugTool requirements is same with LLDebugTool, it works on iOS 8+ and requires ARC to build. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* `UIKit`

* `Foundation`

* `SystemConfiguration`

* `Photos`

* `QuickLook`

## Architecture

* `LLDebug.h` Public header file.

    >You can refer it to the pch file.

* `DebugTool` Tool files.

    >To start and stop LLDebugTool, you need to look at the "LLDebugTool.h".

* `Config`  Configuration file.

    >For the custom color , size , identification and other information. If you want to configure anything, you need to focus on this file.

* `Components`  Components files.

    >If you're not interested in how the functionality works, you can ignore this folder.
    >Each component folder is divided into `Function`and `UserInterface`, `Function` is the specific function implementation, `UserInterface`is the specific UI build.
  
  - `AppInfo` Use to monitoring app's properties, depend on `General`.
  - `Crash` Used to collect crash information when an App crashes, depend on `LLStorageManager`.
  - `Log` Used to quick print and save log, depend on `LLStorageManager`.
  - `Network` Use to monitoring network request, depend on `LLStorageManager`.
  - `Sandbox` Used to view and operate sandbox files, depend on `General`.
  - `Screenshot` Used to process and display screenshots, depend on `General`.
  - `LLStorageManager`  Used to data storage and reading, depend on `General`.
  - `General` The basic component of other components, depend on `Config`.
  
## Communication

- If you **need help**, open an issue.
- If you'd like to **ask a general question**, open an issue.
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **find anything wrong or anything dislike**, open an issue.
- If you **have some good ideas or some requests**, send mail [1404012659@qq.com](1404012659@qq.com) to me.
- If you **want to contribute**, submit a pull request.

## Contact

- Send email to [1404012659@qq.com](1404012659@qq.com)


## Change-log

### 2019-7-3(tag:1.3.2)
>1. ios monkey add weighted qucik traversal algorithm and random traversal algorithm
>2. ios monkey add configuration interface : algorithm setting、blacklist and whitelist setting、execution time setting
>3. ios monkey add coverage display
>4. fix failed with kif error
>5. add log upload interface


### 2019-5-15(tag:1.3.1)
>1. add cocos monkey function
>2. fix screenshot compatible with horizontal and vertical screen
>3. change swift monkey paws to oc monkey paws
>4. ios monkey add element recognition function 


### 2019-4-09(tag:1.3.0)
>1. add share folder function
>2. add monkey paws
>3. compatible with horizontal and vertical screen


### 2019-2-26(tag:1.2.9)

> 1. changes and optimized  of memory and log
> 2. hook private network , add delay and packet loss functions for weak network
> 3. add portable monkey features  

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

