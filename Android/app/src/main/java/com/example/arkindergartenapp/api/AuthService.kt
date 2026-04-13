package com.example.arkindergartenapp.api

import android.util.Log
import com.example.arkindergartenapp.data.models.ForgotPasswordRequest
import com.example.arkindergartenapp.data.models.RegisterUserRequest
import com.example.arkindergartenapp.data.models.SignInUserRequest
import com.example.arkindergartenapp.supporting.Constants
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.Cookie
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull
import okhttp3.ResponseBody
import retrofit2.HttpException
import retrofit2.Retrofit

object AuthService {

    // Helper function to parse error body
    private fun parseError(responseBody: ResponseBody?): String {
        return responseBody?.string() ?: "Unknown error"
    }

    // Generic function to handle both sign-in and sign-up
    private suspend fun <T> authenticate(
        request: T,
        apiCall: suspend (T) -> retrofit2.Response<Unit>,
        successMessage: String,
        failureMessage: String
    ): Result<Boolean> {
        return withContext(Dispatchers.IO) {
            try {
                val response = apiCall(request)

                if (response.isSuccessful) {
                    // Handle cookies
                        val cookies = response.headers()["Set-Cookie"]
                        if (cookies != null) {
                            RetrofitClient.cookieJar.saveFromResponse(
                                Constants.fullURL.toHttpUrlOrNull()!!,
                                listOf(Cookie.parse(Constants.fullURL.toHttpUrlOrNull()!!, cookies)!!)
                            )
                        }
                        Result.success(true)
                } else {
                    val errorBody = parseError(response.errorBody())
                    Result.failure(Exception("$failureMessage: $errorBody"))
                }
            } catch (e: HttpException) {
                val errorBody = parseError(e.response()?.errorBody())
                Log.d("AuthService", "$failureMessage: $errorBody")
                Result.failure(Exception("$failureMessage: $errorBody"))
            } catch (e: Exception) {
                Log.d("AuthService", "$failureMessage: ${e.message}")
                Result.failure(e)
            }
        }
    }

    // Sign in functionality
    suspend fun signIn(email: String, password: String): Result<Boolean> {
        val signInRequest = SignInUserRequest(email, password)
        return authenticate(
            signInRequest,
            apiCall = { RetrofitClient.apiService.signIn(it) },
            successMessage = "Sign-in successful",
            failureMessage = "Sign-in failed"
        )
    }

    // Create account (sign up) functionality
    suspend fun createAccount(request: RegisterUserRequest): Result<Boolean> {
        return authenticate(
            request,
            apiCall = { RetrofitClient.apiService.createAccount(it) },
            successMessage = "Sign-up successful",
            failureMessage = "Sign-up failed"
        )
    }

    // Forgot password functionality
    suspend fun forgotPassword(email: String): Result<Boolean> {
        return withContext(Dispatchers.IO) {
            try {
                val forgotPasswordRequest = ForgotPasswordRequest(email)
                val response = RetrofitClient.apiService.forgotPassword(forgotPasswordRequest)

                if (response.isSuccessful) {
                    Result.success(true)
                } else {
                    val errorBody = parseError(response.errorBody())
                    Result.failure(Exception("Forgot password failed: $errorBody"))
                }
            } catch (e: HttpException) {
                val errorBody = parseError(e.response()?.errorBody())
                Log.d("AuthService", "Error during forgot password: $errorBody")
                Result.failure(Exception("Forgot password failed: $errorBody"))
            } catch (e: Exception) {
                Log.d("AuthService", "Error during forgot password: ${e.message}")
                Result.failure(e)
            }
        }
    }

    // Sign-out functionality
    suspend fun signOut() = withContext(Dispatchers.IO) {
        try {
            val url = Constants.fullURL.toHttpUrlOrNull()
            if (url != null) {
                val cookies: List<Cookie> = RetrofitClient.cookieJar.loadForRequest(url)

                if (cookies.isNotEmpty()) {
                    RetrofitClient.clearCookies()
                    Log.d("AuthService", "Sign-out successful, cookies cleared.")
                } else {
                    Log.d("AuthService", "No cookies found to clear.")
                }
            } else {
                Log.e("AuthService", "Invalid URL: $url")
            }
        } catch (e: Exception) {
            Log.d("AuthService", "Error during sign-out: ${e.message}")
        }
    }
}
