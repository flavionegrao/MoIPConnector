//
//  CartaoDeCreditoViewController.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 14/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartaoDeCreditoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *produto;
@property (weak, nonatomic) IBOutlet UITextField *valor;
@property (weak, nonatomic) IBOutlet UITextField *nomeDoComprador;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *cartaoNumero;
@property (weak, nonatomic) IBOutlet UITextField *cartaoCodigoDeSeguranca;
@property (weak, nonatomic) IBOutlet UITextField *cartaoMesDeExpiracao;
@property (weak, nonatomic) IBOutlet UITextField *cartaoAnoDeExpiracao;
@property (weak, nonatomic) IBOutlet UITextField *nomeNoCartao;
@property (weak, nonatomic) IBOutlet UITextField *cartaoDataDeNascimento;
@property (weak, nonatomic) IBOutlet UITextField *cartaoPhone;
@property (weak, nonatomic) IBOutlet UITextField *cartaoCPF;

@end
