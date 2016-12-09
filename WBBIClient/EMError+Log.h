//
//  EMError+Log.h
//  EaseMob-IM
//
//  Created by 黃韜 on 3/12/2015.
//  Copyright © 2015 NextApps. All rights reserved.
//

#import "EMError.h"

@interface EMError (Log)

- (void)ToConsole;
- (NSError *)ToError;

@end
