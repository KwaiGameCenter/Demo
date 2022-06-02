# KwaiGameSDK iOS SDKs

目录下包含KwaiGameSDK相关的所有组件，并且都以framework和bundle的形式存放在对应的功能目录下，可以按照您的需求拷贝并引用到实际的工程下使用。

**组件结构**

"(~>)"表示依赖关系，需要确定组件所依赖的包都被正确依赖。

**组件包根目录**

output/MainFrameworks/

## KwaiGameSDK
> 包含登录，数据，实名认证，防沉迷等基础功能
- KwaiGameSDK/*
- KwaiGameSDK-AntiAddict/*
- MainFrameworks_dependency/*

> 三方库依赖: resolv.9, c++, Accelerate.framework, AssetsLibrary.framework, StoreKit.framework

## KwaiGameSDK-Pay(~>KwaiGameSDK)
> 支付
- KwaiGameSDK-Pay/*

## KwaiGameSDK-AD(~>KwaiGameSDK)
> 广告(穿山甲，快手，Mintegral， 腾讯广点通)
- KwaiGameSDK-AD/*
- KwaiGameSDK-AD-BUAdSDK/*
- KwaiGameSDK-AD-KSAdSDK/*
- KwaiGameSDK-AD-MintAdSDK/*
- KwaiGameSDK-AD-TXAdSDK/*

> 三方库依赖(BUAdSDK): c++, bz2, resolv.9

> 三方库依赖(KSAdSDK): MobileCoreServices.framework, CoreLocation.framework, Accelerate.framework, MediaPlay.framework, StoreKit.framework, CoreData.framework, AdSupport.framework, CoreTelephony.framework, SystemConfiguration.framework, Webkit.framework, sqlite3, c++, z, xml2, sqlite3

> 三方库依赖(TXAdSDK): xml2

## KwaiGameSDK-ADPath(~>KwaiGameSDK)
> 广告追踪(热云和HIO)
- KwaiGameSDK-ADPath-HIO/*
- KwaiGameSDK-ADPath-Reyun/*

> 三方库依赖(Reyun): z, sqlite3, resolv.9, iAd.framework, SystemConfiguration.framework, CoreMotion.framework, AVFoundation.framework, AdSupport.framework, CoreTelephony.framework, WebKit.framework

## KwaiGameSDK-WebView(~>KwaiGameSDK)
> 游戏内浏览器
- KwaiGameSDK-WebView/*

## KwaiGameSDK-Push(~>KwaiGameSDK)
> 推送
- KwaiGameSDK-Push/*

## KwaiGameSDK-IM(~>KwaiGameSDK)
> 文本聊天室
- KwaiGameSDK-IM/*

> 三方库依赖: resolve.9, c++, Accelerate.framework, StoreKit.framework

## KwaiGameSDK-Voip(~>KwaiGameSDK, ~>KwaiGameSDK-Media, ~>KwaiGameSDK-Audio)
> 语音聊天室
- KwaiGameSDK-Voip/*

## KwaiGameSDK-QuickLogin(~>KwaiGameSDK)
> 手机号一键登录(支持移动，联通，电信)
- KwaiGameSDK-QuickLogin/*

> 三方库依赖: c++

## KwaiGameSDK-Relation(~>KwaiGameSDK)
> 获取快手关系链
- KwaiGameSDK-Relation/*

## KwaiGameSDK-OpenPlatform(~>KwaiGameSDK)
> 分享到三方平台(微信，QQ，微博)
- KwaiGameSDK-OpenPlatform/*

## KwaiGameSDK-Record(~>KwaiGameSDK, ~>KwaiGameSDK-Media,~>KwaiGameSDK-Audio)
> 录屏分享
- KwaiGameSDK-GameRecord/*
- KwaiGameSDK-GameCapture/*
- KwaiGameSDK-VideoShare/*

## KwaiGameSDK-Live(~>KwaiGameSDK, ~>KwaiGameSDK-Media,~>KwaiGameSDK-Audio, ~>KwaiGameSDK-LiveRoom)
> 一键直播
- KwaiGameSDK-Live/*

> 三方库依赖: resolve.9, c++

## KwaiGameSDK-WWP(~>KwaiGameSDK, ~>KwaiGameSDK-Media,~>KwaiGameSDK-Audio, ~>KwaiGameSDK-LiveRoom, KwaiGameSDK-Video)
> 观看直播(边玩边看)
- KwaiGameSDK-WWP/*

## KwaiGameSDK-Withdraw(~>KwaiGameSDK)
> 提现活动
- KwaiGameSDK-Withdraw/*

> 三方库依赖: c++, Accelerate.framework, MobileCoreServices.framework

## KwaiGameSDK-Community(~>KwaiGameSDK)
> 游戏内社区
- KwaiGameSDK-Community/*

## KwaiGameSDK-Community-KT(~>KwaiGameSDK, KwaiGameSDK-Community)
> 游戏内社区(KTPlay)
- KwaiGameSDK-Community-KT/*

> 三方库依赖: resolve.9, c++, libUnityPatch.a(如果同您的环境冲突，请删除；位于third_party目录下)

## KwaiGameSDK-Audio(~>KwaiGameSDK, ~>KwaiGameSDK-Media)
> [基础组件]音频多媒体管理器
- KwaiGameSDK-Audio/*

> 三方库依赖: iconv, z, c++, resolve.9, GLKit.framework, CoreTelephony.framework, SystemConfiguration.framework, VideoToolbox.framework, Accelerate.framework, MetalPerformanceShaders.framework, AssetsLibrary.framework, StoreKit.framework

## KwaiGameSDK-Video(~>KwaiGameSDK, ~>KwaiGameSDK-Media)
> [基础组件]视频播放器
- output/KwaiGameSDK-Video/*

> 三方库依赖: iconv, c++, resolve.9, CoreTelephony.framework, Accelerate.framework

## KwaiGameSDK-Media(~>KwaiGameSDK)
> [基础组件]视频多媒体管理器
- KwaiGameSDK-Media/*

> 三方库依赖: resolve.9, iconv, z, c++, CoreMedia.framework, AVFoundation.framework, SystemConfiguration.framework, AudioToolbox.framework, VideoToolbox.framework, Accelerate.framework, AssetsLibrary.framework, StoreKit.framework

## KwaiGameSDK-LiveRoom(~>KwaiGameSDK)
> [基础组件]直播房间管理
- KwaiGameSDK-LiveRoom/*

您需要拷贝对应目录下的全部资源，并应用到工程中，并且在Build Settings -> Other Linker Flags 中的 -ObjC

# Example
Example中包含所有功能的示例代码，可以提供参考并直接使用，协助您完成快速接入。

# Doc
[快手游戏中台文档](https://http://doc.game.kuaishou.com/)
