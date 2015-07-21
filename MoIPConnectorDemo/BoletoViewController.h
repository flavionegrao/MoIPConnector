//
//  BoletoViewController.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 14/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

@import UIKit;

@interface BoletoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nomeDoProduto;
@property (weak, nonatomic) IBOutlet UITextField *valor;
@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *idPagador;

@end
