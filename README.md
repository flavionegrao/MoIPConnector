# MoIPConnector

## How to use it
1- Add your MoIP credentials in the App Delegate:
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _myMoipToken = @"YOUR MOIP TOKEN";
    _myMoipAccessKey = @"YOUR MoIP ACCESS KEY";
    _myPublicKey = @"YOUR MOIP PUBLIC CERTIFICATE";
    
    NSAssert(_myMoipToken.length > 0 &&
             _myMoipAccessKey.length > 0 &&
             _myPublicKey,
             @"Config MoIP keys error");
    
    return YES;
}
```

2 - Create your order
```
    // Order
    
    MoIPItem* item = [MoIPItem new];
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @7350;
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = @"cliente_xyz";
    customer.fullname = @"João Silva";
    customer.email = @"joaosilva@email.com";
    
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = @"pedido_xyz";
    order.customer = customer;
    order.items = @[item];
```

3 - Create your payment method
```
// Payment
    
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = @"João Portador da Silva";
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = @"12345679891";
    holder.phone = MoIPPhoneMake(55, 11, 66778899);
    
    [MoipSDK importPublicKey:self.moipPublicKey];
    
    MoIPCreditCard* creditCard = [MoIPCreditCard new];
    creditCard.expirationMonth = @"05";
    creditCard.expirationYear = @"2018";
    creditCard.number = @"5555666677778884";
    creditCard.cvc = @"123";
    creditCard.holder = holder;
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodCreditCard;
    fundingInstrument.creditCard = creditCard;
    
    MoIPPayment* payment = [MoIPPayment new];
    payment.installmentCount = @2;
    payment.fundingInstrument = fundingInstrument;
  ```
    
4 - Create a `MoIPConnector` instance
```
MoipConnector* connector = [[MoipConnector alloc]
                          initWithEnviroment:MoIPEnvironmentSandBox
                          token:self.moipToken
                          accessKey:self.moipAccessKey
                          publicCertificate:self.moipPublicKey];
```

5 - Execute the order and wait for the `completionhandler`
```
 [connector executeOrder:order withPayment:payment completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
  NSLog(@"Too easy....");
 }];
 ```
 
 There is a demo app that ilustrates how to use is as well as few unit tests.
