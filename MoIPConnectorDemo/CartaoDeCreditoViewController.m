//
//  CartaoDeCreditoViewController.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 14/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "CartaoDeCreditoViewController.h"

#import "AppDelegate.h"
#import "MoipConnector.h"
#import "MoIPObjects.h"

@interface CartaoDeCreditoViewController ()
@property (nonatomic, strong) MoipConnector* moIPConnector;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CartaoDeCreditoViewController

- (MoipConnector*) moIPConnector {
    if (!_moIPConnector) {
        AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        _moIPConnector = [[MoipConnector alloc]
                          initWithEnviroment:MoIPEnvironmentSandBox
                          token: appDelegate.myMoipToken
                          accessKey: appDelegate.myMoipAccessKey
                          publicCertificate:appDelegate.myPublicKey];
    }
    return _moIPConnector;
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (IBAction)didTouchProcessar:(id)sender {
    
    MoIPItem* item = [MoIPItem new];
    item.product = self.produto.text;
    item.quantity = @1;
    item.detail = @"Detalher do Produto";
    item.price = @([self.valor.text floatValue]);
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId =[[NSUUID UUID]UUIDString];
    customer.fullname = self.nomeDoComprador.text;
    customer.email = self.email.text;
    
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = [NSString stringWithFormat:@"teste__moipconnector_cartao_%ld",(long) [NSDate timeIntervalSinceReferenceDate]];
    order.customer = customer;
    order.items = @[item];
    
    
    // Payment
    
    MoIPHolder* holder = [MoIPHolder new];
    holder.fullname = self.nomeNoCartao.text;
    holder.birthdate = [NSDate date];
    holder.taxDocument = [MoIPTaxDocument new];
    holder.taxDocument.type = MoIPTaxDocumentTypeCPF;
    holder.taxDocument.number = self.cartaoCPF.text;
    holder.phone = MoIPPhoneMake(55, 11, 66778899);
    
    [MoipSDK importPublicKey:self.moIPConnector.publicCertificate];
    
    MoIPCreditCard* creditCard = [MoIPCreditCard new];
    creditCard.expirationMonth = self.cartaoMesDeExpiracao.text;
    creditCard.expirationYear = self.cartaoAnoDeExpiracao.text;
    creditCard.number = self.cartaoNumero.text;
    creditCard.cvc = self.cartaoCodigoDeSeguranca.text;
    creditCard.holder = holder;
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodCreditCard;
    fundingInstrument.creditCard = creditCard;
    
    MoIPPayment* payment = [MoIPPayment new];
    payment.installmentCount = @1;
    payment.fundingInstrument = fundingInstrument;
    
    
    self.title = @"Executando Pagamento...";
    [self.moIPConnector executeOrder:order withPayment:payment completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
        
        self.title = @"Cartão de Crédito";
        
        NSString* mensagem;
        if (!error) {
            mensagem = [NSString stringWithFormat:@"%@\nOrdem:%@\nPagamento:%@",paymentAnwer.status,orderAnswer.objectId,paymentAnwer.objectId];
        } else {
            mensagem = [NSString stringWithFormat:@"Erro: %@",error.localizedDescription];
        }
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Status do Pagamento" message:mensagem preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}


- (IBAction)didTouchDemoInfo:(id)sender {
    self.produto.text = @"Box de DVD";
    self.nomeDoComprador.text = @"João da Silva";
    self.valor.text = @"45,90";
    self.email.text = @"joaodasilva@exemplo.com";
    self.nomeNoCartao.text = @"Joao DonoDoCartao Silva";
    self.cartaoNumero.text = @"5555666677778884";
    self.cartaoCPF.text = @"02470309965";
    self.cartaoPhone.text = @"554191012423";
    self.cartaoMesDeExpiracao.text = @"05";
    self.cartaoAnoDeExpiracao.text = @"2018";
    self.cartaoCodigoDeSeguranca.text = @"123";
    self.cartaoDataDeNascimento.text = @"1977-10-12";
}



@end
