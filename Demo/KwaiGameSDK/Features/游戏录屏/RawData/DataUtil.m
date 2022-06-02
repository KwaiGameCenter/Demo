//
//  DataUtil.m
//  GameRecorder
//
//  Created by 刘玮 on 2019/4/20.
//  Copyright © 2019 KwaiGame. All rights reserved.
//

#import "DataUtil.h"

@implementation DataUtil

+ (NSString *)testVideo {
    return [NSString stringWithFormat: @"%@%@", [[NSBundle mainBundle] resourcePath], @"/test1.mov"];
}

+ (NSString *)animationName {
    return @"animation";
}

+ (NSString *)testImage {
    return [NSString stringWithFormat: @"%@%@", [[NSBundle mainBundle] resourcePath], @"/test1.png"];
}

+ (NSString *)testSound {
    return [NSString stringWithFormat: @"%@%@", [[NSBundle mainBundle] resourcePath], @"/sounds1.mp3"];
}

@end
