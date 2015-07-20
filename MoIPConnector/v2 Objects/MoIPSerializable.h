//
//  MoIPSerializable.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 18/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#ifndef MoIPConnector_MoIPSerializable_h
#define MoIPConnector_MoIPSerializable_h

@protocol MoIPSerializable <NSObject>

- (instancetype) initWithDictionary:(NSDictionary*) dictionary;
- (NSDictionary*) dictionaryRepresentation;
- (BOOL) validateValuesWithError:(NSError**) error;

@end

#endif
