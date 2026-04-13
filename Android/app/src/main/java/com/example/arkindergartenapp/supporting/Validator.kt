package com.example.arkindergartenapp.supporting

import android.util.Patterns

class Validator {

    companion object {

        fun isValidEmail(email: String): Boolean {
            val trimmedEmail = email.trim()
            val emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.{1}[A-Za-z]{2,64}"
            return trimmedEmail.matches(Regex(emailRegEx)) || Patterns.EMAIL_ADDRESS.matcher(trimmedEmail).matches()
        }

        fun isValidUsername(username: String): Boolean {
            val trimmedUsername = username.trim()
            val usernameRegEx = "\\w{4,24}"
            return trimmedUsername.matches(Regex(usernameRegEx))
        }

        fun isPasswordValid(password: String): Boolean {
            val trimmedPassword = password.trim()
            val passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,32}$"
            return trimmedPassword.matches(Regex(passwordRegEx))
        }
    }
}
