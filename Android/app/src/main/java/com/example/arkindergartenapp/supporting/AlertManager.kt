package com.example.arkindergartenapp.supporting

import android.content.Context
import androidx.appcompat.app.AlertDialog

class AlertManager {

    companion object {

        fun showBasicAlert(context: Context, title: String, message: String?) {
            AlertDialog.Builder(context).apply {
                setTitle(title)
                setMessage(message)
                setPositiveButton("Dismiss") { dialog, _ -> dialog.dismiss() }
                create().show()
            }
        }
    }
}

// MARK: - Show Validation Alerts
fun AlertManager.Companion.showInvalidEmailAlert(context: Context) {
    showBasicAlert(context, "Invalid Email", "Please enter a valid email.")
}

fun AlertManager.Companion.showInvalidPasswordAlert(context: Context) {
    showBasicAlert(context, "Invalid Password", "Please enter a valid password.")
}

fun AlertManager.Companion.showInvalidUsernameAlert(context: Context) {
    showBasicAlert(context, "Invalid Username", "Please enter a valid username.")
}

// MARK: - Registration Errors
fun AlertManager.Companion.showRegistrationErrorAlert(context: Context) {
    showBasicAlert(context, "Unknown Registration Error", null)
}

fun AlertManager.Companion.showRegistrationErrorAlert(context: Context, error: String) {
    showBasicAlert(context, "Unknown Registration Error", error)
}

// MARK: - Log In Errors
fun AlertManager.Companion.showSignInErrorAlert(context: Context) {
    showBasicAlert(context, "Unknown Error Signing In", null)
}

fun AlertManager.Companion.showSignInErrorAlert(context: Context, error: String) {
    showBasicAlert(context, "Error Signing In", error)
}

// MARK: - Logout Errors
fun AlertManager.Companion.showLogoutError(context: Context, error: Throwable) {
    showBasicAlert(context, "Log Out Error", error.localizedMessage)
}

// MARK: - Forgot Password
fun AlertManager.Companion.showPasswordResetSent(context: Context) {
    showBasicAlert(context, "Password Reset Sent", "Please check your email for the password reset link.")
}

fun AlertManager.Companion.showErrorSendingPasswordReset(context: Context, error: String) {
    showBasicAlert(context, "Error Sending Password Reset", error)
}

// MARK: - Fetching User Errors
fun AlertManager.Companion.showFetchingUserError(context: Context, error: Throwable) {
    showBasicAlert(context, "Error Fetching User", error.localizedMessage)
}

fun AlertManager.Companion.showUnknownFetchingUserError(context: Context) {
    showBasicAlert(context, "Unknown Error Fetching User", null)
}
