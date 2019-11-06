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

-(instancetype) initWithImagePath: (NSString*) imagePath languages: (NSArray<NSString*>*)languages licenseName: (NSString*) licenseName {
    self = [super init];
    
    if (self) {
        RTREngine* engine = [self createEngineUsingLicenseName: licenseName];
        self.coreAPI = [engine createCoreAPI];
        self.image = [UIImage imageWithData: [NSData dataWithContentsOfFile: imagePath]];
        
        NSSet* set = [NSSet setWithArray: languages];
        // set languages
        [[self.coreAPI.dataCaptureSettings configureDataCaptureProfile] setRecognitionLanguages: set];
    }
    
    return self;
}

// MARK: - Appearance

-(void) captureDataOnSuccess: (nullable RTRDataFromImageSuccessResult) onSuccessCallback onError: (nullable RTRDataFromImageErrorResult) onErrorCallback {
    if (self.coreAPI == nil) {
        // lisense should be wrong
        NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey: NSLocalizedString(@"Wrong Lisense", nil),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Wrong Lisense", nil),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please check you license file or license file path?", nil)
        };
        
        NSError* error = [[NSError alloc] initWithDomain: NSCocoaErrorDomain code: -103 userInfo:userInfo];
        onErrorCallback(error);
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
                    onErrorCallback(error);
                } else {
                    onSuccessCallback([[RTRDataFieldConvertor new] convertToDictionary:result]);
                }
            });
        });
    };
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), actionBlock);
}

// MARK: - Private

-(RTREngine*) createEngineUsingLicenseName: (NSString*) licenseName {
    NSString* licensePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:licenseName];
    return [RTREngine sharedEngineWithLicenseData: [NSData dataWithContentsOfFile:licensePath]];
}

@end
