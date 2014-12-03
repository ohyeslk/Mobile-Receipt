

#import "PRTextParser.h"

@implementation PRTextParser

- (id)init
{
    self = [super init];
    
    if (self) {
        self.itemsArray = [[NSMutableArray alloc] init];
        self.subtotal = @"LOL";
        self.tax = nil;
        self.total = nil;
        self.paymentType = nil;
    }
    
    return self;
}

- (void)parseDataFromString:(NSString*)receiptString
{
    self.test = @"This is a Test";
    NSLog(@"%@", receiptString);
    
    NSString *sep = @" \n";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    NSArray *temp = [receiptString componentsSeparatedByCharactersInSet:set];

    // Get the subtotal
    NSArray *subTotalPossibilities = @[@"Sale", @"Amount", @"Balance", @"Total", @"Payment", @"Subtotai", @"Subtotat", @"Subtotal", @"BHLRNCE"];
    for (int i = 0; i < [temp count]; i++) {
        for (int j = 0; j < [subTotalPossibilities count]; j++) {
            NSString *temp1 = [temp objectAtIndex:i];
            NSString *temp2 = [subTotalPossibilities objectAtIndex:j];
            if ([temp1 isEqualToString:temp2]) {
                self.subtotal = temp[i + 1];
                i = [temp count];
                break;
            }
        }
        
    }
    
    
    // Get the salestax
    NSArray *taxPossibilities = @[@"Tax"];
    for (int i = 0; i < [temp count]; i++) {
        for (int j = 0; j < [taxPossibilities count]; j++) {
            NSString *temp1 = [temp objectAtIndex:i];
            NSString *temp2 = [taxPossibilities objectAtIndex:j];
            if ([temp1 isEqualToString:temp2]) {
                self.tax = temp[i + 1];
                i = [temp count];
                break;
            }
        }
        
    }

    
     // Get the PayType (Cash)
     NSArray *paymentTypeCashPossibilities = @[@"Cash", @"Casa", @"CHSH", @"C559", @"C591", @"Casn", @"Casi", @"casa", @"C880", @"Casw", @"C681", @"Cast", @"Iasn"];
     for (int i = 0; i < [temp count]; i++) {
         for (int j = 0; j < [paymentTypeCashPossibilities count]; j++) {
             NSString *temp1 = [temp objectAtIndex:i];
             NSString *temp2 = [paymentTypeCashPossibilities objectAtIndex:j];
             if ([temp1 isEqualToString:temp2]) {
                 self.paymentType = @"Cash";
                 NSLog(@"Got Cash!!!");
                 i = [temp count];
                 break;
             }
          }
                  
      }
    
    // Get the Items
    for (int i = 0; i < [temp count]; i++) {
        NSLog(@"%@", temp[i]);
        NSString *temp1 = [temp objectAtIndex:i];
        if ([temp1 rangeOfString:@"."].location == NSNotFound) {
        }
        else {
            NSString *stringWithoutDecimal = [temp1 stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            BOOL valid;
            NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:stringWithoutDecimal];
            valid = [alphaNums isSupersetOfSet:inStringSet];
            if (valid) {
                BOOL isUsed = NO;
                for (int j = 0; j < [subTotalPossibilities count]; j++) {
                    NSString *sub;
                    sub = temp[i-1];
                    NSString *temp1 = subTotalPossibilities[j];
                    if ([sub isEqualToString:temp1]) {
                        isUsed = YES;
                        i = [temp count];
                        break;
                    }
                }
                
                if (!isUsed){
                    NSLog(@"%@", stringWithoutDecimal);
                    NSMutableArray *itemString = [[NSMutableArray alloc] init];
                    for (int z = 0; z < i; z++) {
                        NSString *check = temp[i - z];
                        BOOL valid;
                        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:check];
                        valid = [alphaNums isSupersetOfSet:inStringSet];
                        if (!valid && [check isEqualToString:@"i"]) {
                            valid = YES;
                        }
                        if (!valid) {
                            NSLog(@"%@", check);
                            [itemString addObject:check];
                            [itemString addObject:@" "];
                        }
                        else {
                            [itemString addObject:check];
                            [itemString addObject:@" "];
                            [itemString addObject:temp1];
                            [self.itemsArray addObject:itemString];
                            break;
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
    // 
}


@end
