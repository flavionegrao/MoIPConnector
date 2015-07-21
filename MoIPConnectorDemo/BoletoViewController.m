//
//  BoletoViewController.m
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 14/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "BoletoViewController.h"
#import "AppDelegate.h"

#import "MoipConnector.h"
#import "MoipObjects.h"
#import "WebViewController.h"


@interface BoletoViewController ()
@property (nonatomic, strong) MoipConnector* moIPConnector;

@end


@implementation BoletoViewController

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
    item.product = @"Box de Seriado - Exterminate!";
    item.quantity = @1;
    item.detail = @"Box de seriado com 8 dvds";
    item.price = @([self.valor.text floatValue]);
    
    MoIPCustomer* customer = [MoIPCustomer new];
    customer.ownId = self.idPagador.text;
    customer.fullname = self.nome.text;
    customer.email = self.email.text;
    
    MoIPOrder* order = [MoIPOrder new];
    order.ownId = [NSString stringWithFormat:@"teste_boleto_%ld",(long) [NSDate timeIntervalSinceReferenceDate]];
    order.customer = customer;
    order.items = @[item];
    
    
    // Payment
    
    MoIPBoleto* boleto = [MoIPBoleto new];
    boleto.firstInstructionLine = @"Pagamento em qualquer agencia";
    boleto.secondInstructionLine = @"Válido até a data do vencimento";
    boleto.thirdInstructionLine = @"Obrigado por usar o MoIPConnector";
    boleto.expirationDate = [NSDate date];
    
    MoIPFundingInstrument* fundingInstrument = [MoIPFundingInstrument new];
    fundingInstrument.method = MoIPFundingInstrumentMethodBoleto;
    fundingInstrument.boleto = boleto;
    
    MoIPPayment* payment = [MoIPPayment new];
    payment.fundingInstrument = fundingInstrument;
    
    
    self.title = @"Executando Pagamento...";
    [self.moIPConnector executeOrder:order withPayment:payment completionhandler:^(MoIPOrder *orderAnswer, MoIPPayment *paymentAnwer, NSError *error) {
        
        self.title = @"Boleto";
        
        NSString* mensagem;
        if (!error) {
            mensagem = [NSString stringWithFormat:@"%@",paymentAnwer.status];
        } else {
            mensagem = [NSString stringWithFormat:@"Erro: %@",error.localizedDescription];
        }
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Status do Pagamento" message:mensagem preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        if (!error) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ver Boleto" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:@"webViewer" sender:paymentAnwer];
            }]];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}


- (IBAction)didTouchDemoInfo:(id)sender {
    self.nomeDoProduto.text = @"Box DVD Matrix";
    self.valor.text = @"99,00";
    self.nome.text = @"João da Silva";
    self.email.text = @"joao@example.com";
    self.idPagador.text = @"02470309967";
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController* vc = segue.destinationViewController;
    MoIPPayment* paymentAnwer = (MoIPPayment*) sender;
    NSDictionary* payBoleto = paymentAnwer.links[@"payBoleto"];
    vc.url = [NSURL URLWithString:payBoleto[@"redirectHref"]];
    vc.title = @"Boleto MoIP";
}

@end
