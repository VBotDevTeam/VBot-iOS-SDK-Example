//
//  VBotUtils.h
//  Copyright © 2020 VPMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBotUtils : NSObject

/**
 *  This will configure the basic Endpoint to use with pjsip.
 *
 *  @param endpointConfiguration Instance of an endpoint configuration.
 *  @param error                 Pointer to NSError pointer. Will be set to a NSError instance if it can't configure the library.
 *
 *  @return success of configuration.
 */

/**
 *  This will clean the input phone number from characters that cannot be used when setting up a call.
 *
 *  @param phoneNumber Phone number that needs to be cleaned.
 *
 *  @return the cleaned phone number.
 */
+ (NSString *_Nullable)cleanPhoneNumber:(NSString *_Nonnull)phoneNumber;
+ (NSString *_Nullable)trimmingPhoneNumber:(NSString *_Nonnull)phoneNumber;

@end
