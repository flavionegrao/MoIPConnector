//
//  MoIPObject.h
//  MoIPConnector
//
//  Created by Flavio Negrão Torres on 17/07/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#ifndef MoIPConnector_MoIPObject_h
#define MoIPConnector_MoIPObject_h

@protocol MoIPObject <NSObject>

- (NSString*) restEntryPoint;
- (NSString*) objectId;

@end

#endif
