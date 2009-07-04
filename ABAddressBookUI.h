/*
 * ABAddressBookUI.h
 * iPhoneContacts
 * 
 * Created by Jim Dovey on 4/7/2009.
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

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

#import "ABAddressBook.h"
#import "ABGroup.h"
#import "ABPerson.h"
#import "ABMultiValue.h"

@interface ABAddressBook (UserInterface)

- (ABPeoplePickerNavigationController *) peoplePicker;

// Sadly, calling this 'newPersonController' causes memory-contract problems when using Clang static analysis
- (ABNewPersonViewController *) viewControllerForNewPerson;

@end

@interface ABGroup (UserInterface)

- (ABNewPersonViewController *) viewControllerForNewPerson;

@end

@interface ABPerson (UserInterface)

// returns a multi-value containing strings, each of which is a localized address with optional country name
// addCountryName: always return an address containing a country name, regardless of whether it is specified
- (ABMultiValue *) localizedAddressStringsWithCountryName: (BOOL) addCountryName;
- (NSString *) localizedAddressStringForLabel: (NSString *) label addCountryName: (BOOL) addCountryName;

- (ABPersonViewController *) viewController;

@end
