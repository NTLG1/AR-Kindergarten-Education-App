package com.example.arkindergartenapp.api

import com.example.arkindergartenapp.data.models.DataArray
import com.example.arkindergartenapp.data.models.ForgotPasswordRequest
import com.example.arkindergartenapp.data.models.SignInUserRequest
import com.example.arkindergartenapp.data.models.RegisterUserRequest
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.Response

interface ApiService {

    @POST("/auth/sign-in")
    suspend fun signIn(@Body request: SignInUserRequest): Response<Unit>

    @POST("/auth/create-account")
    suspend fun createAccount(@Body request: RegisterUserRequest): Response<Unit>

    @POST("/auth/forgot-password")
    suspend fun forgotPassword(@Body request: ForgotPasswordRequest): Response<Unit>

    @GET("/data/get-data")
    suspend fun getData(): Response<DataArray>
}
