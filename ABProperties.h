/*
 * ABProperties.h
 * iPhoneContacts
 * 
 * Created by Jim Dovey on 6/6/2009.
 * 
 * Copyright (c) 2009 Jim Dovey
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import <AddressBook/AddressBook.h>

// macros to avoid copious type-casts when using ObjC wrappers

// Generic labels
#define ABWorkLabel     (NSString *) kABWorkLabel
#define ABHomeLabel     (NSString *) kABHomeLabel
#define ABOtherLabel    (NSString *) kABOtherLabel

// Addresses
#define ABPersonAddressStreetKey        (NSString *) kABPersonAddressStreetKey
#define ABPersonAddressCityKey          (NSString *) kABPersonAddressCityKey
#define ABPersonAddressStateKey         (NSString *) kABPersonAddressStateKey
#define ABPersonAddressZIPKey           (NSString *) kABPersonAddressZIPKey
#define ABPersonAddressCountryKey       (NSString *) kABPersonAddressCountryKey
#define ABPersonAddressCountryCodeKey   (NSString *) kABPersonAddressCountryCodeKey

// Dates
#define ABPersonAnniversaryLabel        (NSString *) kABPersonAnniversaryLabel

// Kind
#define ABPersonKindPerson              (NSNumber *) kABPersonKindPerson
#define ABPersonKindOrganization        (NSNumber *) kABPersonKindOrganization

// Phone Numbers
#define ABPersonPhoneMobileLabel        (NSString *) kABPersonPhoneMobileLabel
#define ABPersonPhoneIPhoneLabel        (NSString *) kABPersonPhoneIPhoneLabel
#define ABPersonPhoneMainLabel          (NSString *) kABPersonPhoneMainLabel
#define ABPersonPhoneHomeFAXLabel       (NSString *) kABPersonPhoneHomeFAXLabel
#define ABPersonPhoneWorkFAXLabel       (NSString *) kABPersonPhoneWorkFAXLabel
#define ABPersonPhonePagerLabel         (NSString *) kABPersonPhonePagerLabel

// IM
#define ABPersonInstantMessageServiceKey    (NSString *) kABPersonInstantMessageServiceKey
#define ABPersonInstantMessageServiceYahoo  (NSString *) kABPersonInstantMessageServiceYahoo
#define ABPersonInstantMessageServiceJabber (NSString *) kABPersonInstantMessageServiceJabber
#define ABPersonInstantMessageServiceMSN    (NSString *) kABPersonInstantMessageServiceMSN
#define ABPersonInstantMessageServiceICQ    (NSString *) kABPersonInstantMessageServiceICQ
#define ABPersonInstantMessageServiceAIM    (NSString *) kABPersonInstantMessageServiceAIM
#define ABPersonInstantMessageUsernameKey   (NSString *) kABPersonInstantMessageUsernameKey

// URLs
#define ABPersonHomePageLabel           (NSString *) kABPersonHomePageLabel

// Related Names
#define ABPersonFatherLabel             (NSString *) kABPersonFatherLabel
#define ABPersonMotherLabel             (NSString *) kABPersonMotherLabel
#define ABPersonParentLabel             (NSString *) kABPersonParentLabel
#define ABPersonBrotherLabel            (NSString *) kABPersonBrotherLabel
#define ABPersonSisterLabel             (NSString *) kABPersonSisterLabel
#define ABPersonChildLabel              (NSString *) kABPersonChildLabel
#define ABPersonFriendLabel             (NSString *) kABPersonFriendLabel
#define ABPersonSpouseLabel             (NSString *) kABPersonSpouseLabel
#define ABPersonPartnerLabel            (NSString *) kABPersonPartnerLabel
#define ABPersonAssistantLabel          (NSString *) kABPersonAssistantLabel
#define ABPersonManagerLabel            (NSString *) kABPersonManagerLabel
