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

typedef void (^RTRDataFromImageResult) (NSData* _Nullable jsonData, NSError* _Nullable error);

@interface CapturingDataImageService : NSObject

-(instancetype) initWithImagePath: (NSString*) imagePath languages: (NSSet<RTRLanguageName>*)languages licensePath: (NSString*) licencePath;
-(void) captureDataOnFinished: (RTRDataFromImageResult) onResult;

@end

NS_ASSUME_NONNULL_END
