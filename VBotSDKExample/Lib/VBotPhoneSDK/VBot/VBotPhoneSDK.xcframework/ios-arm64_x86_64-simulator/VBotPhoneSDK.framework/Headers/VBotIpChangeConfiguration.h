//
//  VBotIpChangeConfiguration.h
//  Copyright © 2020 VPMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VBotPJSIP/pjsua.h>

typedef NS_ENUM(NSInteger, VBotIpChangeConfigurationIpChangeCalls) {
    /**
     * Use the ip change from pjsip.
     */
    VBotIpChangeConfigurationIpChangeCallsDefault,
    /**
     * Do the reinvite of the calls self instead of pjsip.
     */
    VBotIpChangeConfigurationIpChangeCallsReinvite,
    /**
     * Do an UPDATE sip message instead of a INVITE that is done by pjsip.
     */
    VBotIpChangeConfigurationIpChangeCallsUpdate
};
#define VBotEndpointIpChangeCallsString(VBotEndpointIpChangeCalls) [@[@"VBotIpChangeConfigurationIpChangeCallsDefault", @"VBotIpChangeConfigurationIpChangeCallsReinvite", @"VBotIpChangeConfigurationIpChangeCallsUpdate"] objectAtIndex:VBotEndpointIpChangeCalls]

typedef NS_ENUM(NSUInteger, VBotReinviteFlags) {
    /**
     * Deinitialize and recreate media, including media transport. This flag
     * is useful in IP address change situation, if the media transport
     * address (or address family) changes, for example during IPv4/IPv6
     * network handover.
     * This flag is only valid for #pjsua_call_reinvite()/reinvite2(), or
     * #pjsua_call_update()/update2().
     *
     * Warning: If the re-INVITE/UPDATE fails, the old media will not be
     * reverted.
     */
    VBotReinviteFlagsReinitMedia = PJSUA_CALL_REINIT_MEDIA,
    /**
     * Update the local invite session's contact with the contact URI from
     * the account. This flag is only valid for #pjsua_call_set_hold2(),
     * #pjsua_call_reinvite() and #pjsua_call_update(). This flag is useful
     * in IP address change situation, after the local account's Contact has
     * been updated (typically with re-registration) use this flag to update
     * the invite session with the new Contact and to inform this new Contact
     * to the remote peer with the outgoing re-INVITE or UPDATE.
     */
    VBotReinviteFlagsUpdateContact = PJSUA_CALL_UPDATE_CONTACT,
    /**
     * Update the local invite session's Via with the via address from
     * the account. This flag is only valid for #pjsua_call_set_hold2(),
     * #pjsua_call_reinvite() and #pjsua_call_update(). Similar to
     * the flag PJSUA_CALL_UPDATE_CONTACT above, this flag is useful
     * in IP address change situation, after the local account's Via has
     * been updated (typically with re-registration).
     */
    VBotReinviteFlagsUpdateVia = PJSUA_CALL_UPDATE_VIA
};
#define VBotReinviteFlagsString(VBotReinviteFlags) [@[@"VBotReinviteFlagsReinitMedia", @"VBotReinviteFlagsUpdateContact", @"VBotReinviteFlagsUpdateVia"] objectAtIndex:VBotReinviteFlags]

@interface VBotIpChangeConfiguration : NSObject

@property (nonatomic) VBotIpChangeConfigurationIpChangeCalls ipChangeCallsUpdate;

/**
 * Should the old transport be cleaned up.
 */
@property (nonatomic) BOOL ipAddressChangeShutdownTransport;

/**
 * Should all calls be ended when an ip address change has been detected.
 *
 * Default: NO
 */
@property (nonatomic) BOOL ipAddressChangeHangupAllCalls;

/**
 * When ipAddressChangeHangupAllCalls is set to NO, this property should be set.
 *
 * Default: VBotReinviteFlagsReinitMedia | VBotReinviteFlagsUpdateVia | VBotReinviteFlagsUpdateContact
 */
@property (nonatomic) VBotReinviteFlags ipAddressChangeReinviteFlags;

/**
 * Return the default reinvite flags
 */
+ (VBotReinviteFlags)defaultReinviteFlags;
@end
