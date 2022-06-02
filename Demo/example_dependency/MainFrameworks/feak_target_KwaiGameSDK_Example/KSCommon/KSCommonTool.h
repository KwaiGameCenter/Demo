//
//  KSCommonTool.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 14-8-20.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <KSCommon/KSLanguageConfig.h>


static inline NSString* KSCurrentLanguageSetting()
{
    NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
    [[KSLanguageConfig preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float q = 1.0f - (idx * 0.1f);
        [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
        *stop = q <= 0.5f;
    }];
    return [acceptLanguagesComponents componentsJoinedByString:@", "];
}

static inline NSString * KSBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

/**
 * 为避免分母为0引起NAN crash，所有除法运算都应该使用这个函数进行运算!!!!!
 */
static inline double KSSafeDivition(double numerator,double denominator)
{
    return numerator/(denominator + 0.000001);
}

/**
 *  两个整数相除并把结果向上取整
 *
 *  @param dividend 被除数
 *  @param divisor  除数
 *
 *  @return 两个整数相除并把结果向上取整的结果
 */
static inline NSInteger KSCeilOf2Integer(NSInteger dividend, NSInteger divisor)
{
    NSInteger result = dividend / divisor;
    if (dividend % divisor) {
        result++;
    }
    return result;
}

@interface KSCommonTool : NSObject

@property (nonatomic, assign) BOOL useTargetForward;

/**
 * 创建不会retain elements 的array。
 */
NSMutableArray* KSNonRetainingArray(void);

+ (instancetype)sharedTool;

- (NSDate*)dateFromString:(NSString*)string;

- (NSDate*)dateFromString:(NSString*)string formate:(NSString*)formate;

- (NSString *)stringFromDate:(NSDate*)date;

- (NSString *)stringFromDate:(NSDate*)date formate:(NSString*)formate;

+ (NSString*) obtainUUIDString;

/**
 * 获取对象的所有属性名称
 * 注意：不支持序序列化的属性也会被包含其中，所以需要注意将不支持序列化的属性排除！！see:KSFeed.m->encodeWithCoder。
 * 无法通过runtime，通过判断是否实现某个方法，或者NSCoding来判断是否可以序列化。只能手动~
 */
+ (NSArray *)propertyKeys:(id)object;

/**
 * 标记文件，不在icloud存储
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (BOOL)addSkipBackupAttributeToItemAtURLString:(NSString *)URLString;

+ (BOOL) hasSkipBackupAttributeToItemAtURL:(NSURL *)URL;

/**
 * 一个文件夹下的多有文件的大小
 */
+ (uint64_t)fileSizeUnderFolder:(NSURL*)folderURL;

/**
 * NSArray,NSDictionary转换为json stirng
 * @param object NSArray或者是NSDictionary，
 */
+ (NSString*)objectToJsonString:(id) object;


@end



static inline NSString* KSPrivateDocument(){
    
    NSString *privateDocument = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:privateDocument isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:privateDocument withIntermediateDirectories:YES attributes:nil error:NULL];
        [KSCommonTool addSkipBackupAttributeToItemAtURLString:privateDocument];
    }
    
    return privateDocument;
}
