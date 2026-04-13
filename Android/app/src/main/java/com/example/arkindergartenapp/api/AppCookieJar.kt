package com.example.arkindergartenapp.api

import okhttp3.Cookie
import okhttp3.CookieJar
import okhttp3.HttpUrl

class AppCookieJar : CookieJar {
    private val cookieStore: MutableMap<String, List<Cookie>> = mutableMapOf()

    override fun loadForRequest(url: HttpUrl): List<Cookie> {
        return cookieStore[url.host] ?: emptyList()
    }

    override fun saveFromResponse(url: HttpUrl, cookies: List<Cookie>) {
        cookieStore[url.host] = cookies
    }

    fun getJwtCookie(): String? {
        return cookieStore.values.flatten().find { it.name == "jwt" }?.toString()
    }

    fun clearCookies() {
        cookieStore.clear()
    }
}
