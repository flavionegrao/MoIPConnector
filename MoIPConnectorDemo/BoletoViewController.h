//
//  BoletoViewController.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 14/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

@import UIKit;

@interface BoletoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *razao;
@property (weak, nonatomic) IBOutlet UITextField *valor;
@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *idPagador;
@property (weak, nonatomic) IBOutlet UITextField *logradouro;
@property (weak, nonatomic) IBOutlet UITextField *numero;
@property (weak, nonatomic) IBOutlet UITextField *bairro;
@property (weak, nonatomic) IBOutlet UITextField *estado;
@property (weak, nonatomic) IBOutlet UITextField *pais;
@property (weak, nonatomic) IBOutlet UITextField *cidade;
@property (weak, nonatomic) IBOutlet UITextField *cep;
@property (weak, nonatomic) IBOutlet UITextField *telefonefixo;

@end
