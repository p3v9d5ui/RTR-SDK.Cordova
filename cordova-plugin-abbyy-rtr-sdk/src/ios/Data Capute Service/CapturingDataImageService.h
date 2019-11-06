//
//  CapturingDataImageService.h
//  CoreAPI
//
//  Created by Ostap Kyselytsia on 04.11.2019.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AbbyyRtrSDK/AbbyyRtrSDK.h>
#import "RTRDataFieldConvertor.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RTRDataFromImageSuccessResult) (NSDictionary* _Nullable dictionary);
typedef void (^RTRDataFromImageErrorResult) (NSError* _Nullable error);

@interface CapturingDataImageService : NSObject

-(instancetype) initWithImagePath: (NSString*) imagePath languages: (NSArray<NSString*>*)languages licenseName: (NSString*) licenseName;
-(void) captureDataOnSuccess: (nullable RTRDataFromImageSuccessResult) onSuccessCallback onError: (nullable RTRDataFromImageErrorResult) onErrorCallback;

@end

NS_ASSUME_NONNULL_END
