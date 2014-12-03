

#import "PRPayPalViewController.h"
#import "PayPalMobile.h"

@interface PRPayPalViewController () <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UITextFieldDelegate>
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;

// For use in Storyboards
@property (weak, nonatomic) IBOutlet UIButton *payWithPaypalButton;
@property (weak, nonatomic) IBOutlet UITextField *totalBillTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalTaxTextField;
@property (weak, nonatomic) IBOutlet UITextField *item1Price;
@property (weak, nonatomic) IBOutlet UITextField *item1Description;
@property (weak, nonatomic) IBOutlet UITextField *item2Price;
@property (weak, nonatomic) IBOutlet UITextField *item2Description;
@property (weak, nonatomic) IBOutlet UIButton *countItem1;
@property (weak, nonatomic) IBOutlet UIButton *countItem2;
@property (weak, nonatomic) IBOutlet UITextField *afterTaxButton;
@property (weak, nonatomic) IBOutlet UITextField *afterTotalButton;

@property (nonatomic) int count1;
@property (nonatomic) int count2;
@property (nonatomic) double finalCost;
@property (nonatomic) double finalTax;

@end

#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@implementation PRPayPalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setTitle:@"PayPal"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.totalBillTextField.delegate = self;
    self.totalTaxTextField.delegate = self;
    self.item1Price.delegate = self;
    self.item1Description.delegate = self;
    self.item2Price.delegate = self;
    self.item2Description.delegate = self;
    
    self.totalBillTextField.text = self.total;
    self.totalTaxTextField.text = self.tax;
    
    self.afterTotalButton.text = self.total;
    self.afterTaxButton.text = self.tax;
    
    self.finalCost = [self.total doubleValue];
    self.finalTax = [self.tax doubleValue];
    
    for (int i = 0; i < [self.itemsArray count]; i++) {
        NSMutableArray *item = [self.itemsArray objectAtIndex:i];
        
        NSString *itemPrice = item[[item count] - 1];
        
        NSString *count = item[[item count] - 3];
        
        NSMutableString *newItem = [[NSMutableString alloc] init];
        for (int j = [item count] - 4; j > 0; j--) {
            NSString *itemPart = item[j];
            [newItem appendString:itemPart];
        }
        
        
        if (i == 0) {
            self.item1Description.text = newItem;
            self.item1Price.text = itemPrice;
            self.count1 = [count intValue];
        }
        else {
            self.item2Description.text = newItem;
            self.item2Price.text = itemPrice;
            self.count2 = [count intValue];
        }
        
    }
    
    if (self.item1Price.text == nil) {
        [self.countItem1 setEnabled:NO];
    }
    if (self.item2Price.text == nil) {
        [self.countItem2 setEnabled:NO];
    }
    
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;

    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}

- (IBAction)payWithPaypal:(UIButton *)sender
{
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:self.afterTotalButton.text];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Hipster clothing";
    payment.items = nil;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = nil; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
}


#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}


#pragma mark - Authorize Future Payments


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}


#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
    
    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}

#pragma - mark TextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (IBAction)countItem2:(UIButton*)sender
{
    
    if ([sender.titleLabel.text intValue] == 1) {
        [sender.titleLabel setText:@"0"];
        
    }
    else {
        [sender.titleLabel setText:@"1"];
        
    }
    
    
}

- (IBAction)countItem1:(UIButton*)sender
{
    if ([sender.titleLabel.text intValue] == 1) {
        [sender.titleLabel setText:@"0"];
    }
    else {
        [sender.titleLabel setText:@"1"];
    }
}
@end
