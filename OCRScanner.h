

#import <Foundation/Foundation.h>
#import "PRTextParser.h"

@interface OCRScanner : NSObject
+ (instancetype)sharedRecognizer;
- (void)recognizeTextWithImage:(UIImage*)image withParser:(PRTextParser*)parser;
@end
