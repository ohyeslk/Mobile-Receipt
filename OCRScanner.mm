

#import "OCRScanner.h"
#import "ImageProcessing.h"
#import <TesseractOCR/TesseractOCR.h>

@interface OCRScanner() <TesseractDelegate>

@end

@implementation OCRScanner

+ (instancetype)sharedRecognizer
{
    static OCRScanner *sharedRecognizer;
    
    if(!sharedRecognizer) {
        sharedRecognizer = [[self alloc] initPrivate];
    }
    
    return sharedRecognizer;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[OCRScanner sharedRecognizer]"];
    return nil;
}

- (void)recognizeTextWithImage:(UIImage*)image withParser:(PRTextParser*)parser
{
    // language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory; eng+ita will search for a eng.traineddata and ita.traineddata.
    
    //Like in the Template Framework Project:
    // Assumed that .traineddata files are in your "tessdata" folder and the folder is in the root of the project.
    // Assumed, that you added a folder references "tessdata" into your xCode project tree, with the ‘Create folder references for any added folders’ options set up in the «Add files to project» dialog.
    // Assumed that any .traineddata files is in the tessdata folder, like in the Template Framework Project
    
    //Create your tesseract using the initWithLanguage method:
    // Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];
    
    // set up the delegate to recieve tesseract's callback
    // self should respond to TesseractDelegate and implement shouldCancelImageRecognitionForTesseract: method
    // to have an ability to recieve callback and interrupt Tesseract before it finishes
        
    [self storeLanguageFile];
    Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];
    tesseract.delegate = self;
    //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
    [tesseract setVariableValue:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY‌​Z#/$:." forKey:@"tessedit_char_whitelist"];
    [tesseract setVariableValue:@";'" forKey:@"tessedit_char_blacklist"];
    
    CGSize newSize = CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ImageWrapper *greyScale=Image::createImage(resizedImage, resizedImage.size.width, resizedImage.size.height);
    ImageWrapper *edges = greyScale.image->autoLocalThreshold();
    
    [tesseract setImage:edges.image->toUIImage()];
    [tesseract recognize];
    
    [parser parseDataFromString:[tesseract recognizedText]];
    
    tesseract = nil; //deallocate and free all memory
}


- (BOOL)shouldCancelImageRecognitionForTesseract:(Tesseract*)tesseract
{
    NSLog(@"progress: %d", tesseract.progress);
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}

- (void)storeLanguageFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDirectory stringByAppendingPathComponent:@"/tessdata/eng.traineddata"];
    if(![fileManager fileExistsAtPath:path])
    {
        NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/tessdata/eng.traineddata"]];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:[docsDirectory stringByAppendingPathComponent:@"/tessdata"] withIntermediateDirectories:YES attributes:nil error:&error];
        [data writeToFile:path atomically:YES];
    }
}

@end
