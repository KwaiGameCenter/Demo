//
//  NSObject+KCCoding.h
//  AFNetworking
//
//  Created by 小火神 on 2017/11/13.
//

#import <Foundation/Foundation.h>

@interface NSObject (KCCoding)

@property (nonatomic, readonly) NSDictionary<NSString *, Class> *kc_codableProperties;
@property (nonatomic, readonly) NSDictionary<NSString *, id> *kc_dictionaryRepresentation;

// convenient for NSCoping
- (id)kc_copy;
- (id)kc_mutableCopy;

// convenient for NSCoding
- (void)kc_encodeWithCoder:(NSCoder *)aCoder;
- (instancetype)kc_initWithCoder:(NSCoder *)aDecoder;

@end
