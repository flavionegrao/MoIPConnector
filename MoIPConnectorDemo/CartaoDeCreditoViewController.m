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

@interface CartaoDeCreditoViewController ()
@property (nonatomic, strong) MoipConnector* moIPConnector;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CartaoDeCreditoViewController

- (MoipConnector*) moIPConnector {
    if (!_moIPConnector) {
        AppDelegate* appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        NSString* token = appDelegate.myMoipToken;
        NSString* accessKey = appDelegate.myMoipAccessKey;
        
        _moIPConnector = [[MoipConnector alloc]initWithEnviroment:MoIPEnvironmentSandBox token:token accessKey:accessKey];
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
    MoIPInfoDePagamento* info = [MoIPInfoDePagamento new];
    info.razao = self.razao.text;
    info.valor = @([self.valor.text floatValue]);
    info.idProprio = [[NSUUID UUID]UUIDString];
    info.nome = self.nome.text;
    info.email = self.email.text;
    info.idPagador = self.idPagador.text;
    info.logradouro = self.logradouro.text;
    info.numero = self.numero.text;
    info.complemento = nil;
    info.bairro = self.bairro.text;
    info.cidade = self.cidade.text;
    info.estado = self.estado.text;
    info.pais = self.pais.text;
    info.cep = self.cep.text;
    info.telefoneFixo = self.telefonefixo.text;
    
    MoIPMetodoDePagamento* metodo = [[MoIPMetodoDePagamento alloc]initWithFormaDePagamento:MoIPFormaDePagamentoBoletoBancario];
    
    self.title = @"Executando Pagamento...";
    [self.moIPConnector executePaymentWithPaymenInfo:info paymentMethod:metodo completion:^(MoIPStatusDoPagamento *paymentStatus, NSError *error) {
        self.title = @"Boleto";
        
        NSString* mensagem;
        if (!error) {
            mensagem = [NSString stringWithFormat:@"%@",paymentStatus];
        } else {
            mensagem = [NSString stringWithFormat:@"Erro: %@",error.localizedDescription];
        }
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Status do Pagamento" message:mensagem preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        if (!error) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ver Boleto" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self performSegueWithIdentifier:@"webViewer" sender:paymentStatus];
            }]];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}


- (IBAction)didTouchDemoInfo:(id)sender {
    self.razao.text = @"Pagamento Teste do SDK";
    self.valor.text = @"99,00";
    self.nome.text = @"João da Silva";
    self.email.text = @"joao@example.com";
    self.idPagador.text = @"02470309967";
    self.logradouro.text = @"Rua Padre Agostinho";
    self.numero.text = @"2619";
    self.bairro.text = @"Merces";
    self.cidade.text = @"Curitiba";
    self.estado.text = @"PR";
    self.pais.text = @"BRA";
    self.cep.text = @"80710-000";
    self.telefonefixo.text = @"4133332211";
}



@end
