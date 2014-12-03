
#import "PRCamPreviewView.h"
#import <AVFoundation/AVFoundation.h>


@implementation PRCamPreviewView

+ (Class)layerClass
{
	return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
	return [(AVCaptureVideoPreviewLayer *)[self layer] session];
}

- (void)setSession:(AVCaptureSession *)session
{
    ((AVPlayerLayer *)[self layer]).videoGravity = AVLayerVideoGravityResizeAspectFill;
    ((AVPlayerLayer *)[self layer]).bounds = ((AVPlayerLayer *)[self layer]).bounds;
    [(AVCaptureVideoPreviewLayer *)[self layer] setSession:session];
}

@end
