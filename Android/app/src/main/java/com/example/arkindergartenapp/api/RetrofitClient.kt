package com.example.arkindergartenapp.api

import com.example.arkindergartenapp.supporting.Constants
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitClient {

    val cookieJar = AppCookieJar()

    private val loggingInterceptor = HttpLoggingInterceptor().apply {
        level = HttpLoggingInterceptor.Level.BODY
    }

    private val client = OkHttpClient.Builder()
        .addInterceptor { chain ->
            val request = chain.request()
            val newRequest = getJwtCookie()?.let { jwtToken ->
                request.newBuilder()
                    .addHeader("Authorization", "Bearer $jwtToken")
                    .build()
            } ?: request
            chain.proceed(newRequest)
        }
        .addInterceptor(loggingInterceptor)
        .cookieJar(cookieJar)
        .build()

    private val retrofit = Retrofit.Builder()
        .baseUrl(Constants.fullURL)
        .client(client)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    val apiService: ApiService by lazy {
        retrofit.create(ApiService::class.java)
    }

    private fun getJwtCookie(): String? = cookieJar.getJwtCookie()
    fun clearCookies() = cookieJar.clearCookies()
}
