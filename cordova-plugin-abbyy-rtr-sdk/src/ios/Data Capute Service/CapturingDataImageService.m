//
//  CapturingDataImageService.m
//  CoreAPI
//
//  Created by Ostap Kyselytsia on 04.11.2019.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import "CapturingDataImageService.h"

@interface CapturingDataImageService()

@property (strong, nonatomic) id<RTRCoreAPI> coreAPI;
@property (strong, nonatomic) UIImage* image;

@end

@implementation CapturingDataImageService

// MARK: - Initialization

-(instancetype) initWithImagePath: (NSString*) imagePath languages: (NSSet<RTRLanguageName>*)languages licensePath: (NSString*) licensePath {
    self = [super init];
    
    if (self) {
        RTREngine* engine = [self createEngineUsingLicensePath: licensePath];
        self.coreAPI = [engine createCoreAPI];
        self.image = [UIImage imageWithData: [NSData dataWithContentsOfFile: imagePath]];
        
        // set languages
        [[self.coreAPI.dataCaptureSettings configureDataCaptureProfile] setRecognitionLanguages:languages];
    }
    
    return self;
}

// MARK: - Appearance

-(void) captureDataOnFinished: (RTRDataFromImageResult) onResult; {
    if (self.coreAPI == nil) {
        // lisense should be wrong
        return;
    }
    
    typeof(^{}) actionBlock = nil;
    
    actionBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError* error;
            NSArray<RTRDataField*>* result = [self.coreAPI
                                              extractDataFromImage: self.image
                                              onProgress:^BOOL(NSInteger percentage, RTRCallbackWarningCode warningCode) {
                return YES;
            } onTextOrientationDetected: nil error: &error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(result == nil) {
                    onResult(nil, error);
                } else {
                    onResult([[RTRDataFieldConvertor new] convertToJSOnObject:result], nil);
                }
            });
        });
    };
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), actionBlock);
}

// MARK: - Private

-(RTREngine*) createEngineUsingLicensePath: (NSString*) licensePath {
    return [RTREngine sharedEngineWithLicenseData: [NSData dataWithContentsOfFile:licensePath]];
}

@end
