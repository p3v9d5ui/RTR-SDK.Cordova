//
//  RTRDataFieldConvertor.h
//  CoreAPI
//
//  Created by Ostap Kyselytsia on 04.11.2019.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AbbyyRtrSDK/AbbyyRtrSDK.h>


NS_ASSUME_NONNULL_BEGIN

@interface RTRDataFieldConvertor : NSObject

-(NSDictionary*) convertToDictionary: (NSArray<RTRDataField*>*)dataFields;
@end

NS_ASSUME_NONNULL_END
