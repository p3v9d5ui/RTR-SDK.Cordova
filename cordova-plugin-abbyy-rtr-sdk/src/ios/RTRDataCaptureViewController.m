/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTRDataCaptureViewController.h"
#import "RTRDataCaptureScenario.h"

@interface RTRDataCaptureViewController () <RTRDataCaptureServiceDelegate>

@end

@implementation RTRDataCaptureViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.settingsButton.userInteractionEnabled = NO;
	self.settingsButton.hidden = NO;

	self.descriptionLabel.text = [self.selectedScenario description];

	RTRExtendedSettings* extendedSettings = [[RTRExtendedSettings alloc] init];
	[extendedSettings setValue:self.extendedSettings forKey:@"properties"];
	if(self.profile.length != 0) {
		[self.settingsButton setTitle:self.profile forState:UIControlStateNormal];
		self.service = [self.rtrManager dataCaptureServiceWithProfile:self.profile delegate:self extendedSettings:extendedSettings];
	} else {
		[self.settingsButton setTitle:self.selectedScenario.name forState:UIControlStateNormal];
		self.service = [self.rtrManager customDataCaptureServiceWithScenario:self.selectedScenario delegate:self extendedSettings:extendedSettings];
	}
}

#pragma mark - RTRDataCaptureServiceDelegate

- (void)onBufferProcessedWithDataScheme:(RTRDataScheme*)dataScheme dataFields:(NSArray<RTRDataField*>*)dataFields
	resultStatus:(RTRResultStabilityStatus)resultStatus
{
	__weak RTRDataCaptureViewController* weakSelf = self;
	performBlockOnMainThread(0, ^{
		if(!weakSelf.isRunning) {
			return;
		}

		weakSelf.dataScheme = dataScheme;
		weakSelf.dataFields = dataFields;
		weakSelf.currentStabilityStatus = resultStatus;

		[weakSelf.progressIndicatorView setProgress:resultStatus color:[weakSelf progressColor:resultStatus]];

		if(dataScheme != nil && resultStatus == RTRResultStabilityStable && weakSelf.stopWhenStable) {
			weakSelf.running = NO;
			weakSelf.captureButton.selected = NO;
			weakSelf.whiteBackgroundView.hidden = NO;
			[weakSelf.service stopTasks];

			if(weakSelf.onSuccess != nil) {
				const BOOL AutomaticallyStopped = NO;
				weakSelf.onSuccess(AutomaticallyStopped);
			}
		}

		[weakSelf drawTextRegionsFromDataFields:dataFields progress:resultStatus];
	});
}

@end
