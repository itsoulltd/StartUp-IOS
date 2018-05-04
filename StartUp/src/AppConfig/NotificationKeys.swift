//
//  Notifications.swift
//  StartUp
//
//  Created by Towhid Islam on 10/30/16.
//  Copyright © 2018 ITSoulLab (https://www.itsoullab.com). All rights reserved.
//

import Foundation

struct FormPropertyKeys {
    static let OTPName = NSLocalizedString("Enter your OTP", comment: "")
    static let FirstName = NSLocalizedString("First Name", comment: "")
    static let LastName = NSLocalizedString("Last Name", comment: "")
    static let DisplayName = NSLocalizedString("Display Name", comment: "")
    static let ContactNumber = NSLocalizedString("Contact Number", comment: "")
    static let UserName = NSLocalizedString("User Name", comment: "")
    static let EmailAddress = NSLocalizedString("E-mail", comment: "")
    static let PhoneNumber = NSLocalizedString("Phone Number", comment: "")
    static let CountryCode = NSLocalizedString("Country Code", comment: "")
    static let Password = NSLocalizedString("Password", comment: "")
    static let ConfirmPassword = NSLocalizedString("Confirm Password", comment: "")
    static let SignIn = NSLocalizedString("SIGN IN", comment: "")
    static let SignUp = NSLocalizedString("SIGN UP", comment: "")
    static let SignUpLinkActTitle = NSLocalizedString("SIGN UP?", comment: "")
    static let ForgotPassword = NSLocalizedString("FORGOT PASSWORD", comment: "")
    static let ForgotPasswordLinkActTitle = NSLocalizedString("Forgot Password?", comment: "")
    static let ForgotPassRemarks = NSLocalizedString("Don't Worry! Insert your email and click the button bellow.", comment: "")
    static let RememberMe = NSLocalizedString("Remember me", comment: "")
    static let DontHaveAccount = NSLocalizedString("Don't have account yet!", comment: "")
    
}

struct FormValidationConstants {
    static let MobileNumberMinLength = 10
    static let MobileNumberMaxLength = 20
    static let MobileNumberRegX = "^\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$" //"^\\+(?:[0-9] ?){6,14}[0-9]$"
    static let UserNameMinLength = 1
    static let PasswordMinLength = 5
    static let PasswordRegX = "((?=.*\\d)(?=.*[A-Za-z]).{6,20})"
    static let PasswordRegX2 = "^.*(?=.{8,})(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!*@#$%^&+=]).*$"
    static let EmailRegX = "[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}"
    static let EmailRegX2 = "\\A(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)\\Z"
    static let EmailMinLength = 7
}

struct FormValidationError {
    static let RequiredMessage = NSLocalizedString("is a required field", comment: "")
    static let PatternMessage = NSLocalizedString("is invalid", comment: "")
    static let EmailInvalidMessage = NSLocalizedString("is invalid", comment: "")
    static let LengthMessage = NSLocalizedString("input length at least", comment: "")
    static let PasswordInvalidMessage = NSLocalizedString("is invalid", comment: "")
    static let PasswordMinLengthMessage = NSLocalizedString("minimum length is", comment: "")
    static let PasswordMissmatchMessage = NSLocalizedString("mismatch", comment: "")
    static let MobileNumberInvalidMessage = NSLocalizedString("Invalid Number Format", comment: "")
}

struct NotificationKeys {
    static let UserSignOutNotification = Notification.Name("UserLogoutNotification")
}
