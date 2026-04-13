package com.example.arkindergartenapp.api

import com.example.arkindergartenapp.data.models.DataArray
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object DataService {

    suspend fun getData(): Result<DataArray> {
        return withContext(Dispatchers.IO) {
            try {
                val response = RetrofitClient.apiService.getData()
                if (response.isSuccessful) {
                    val dataArray = response.body()
                    if (dataArray != null) {
                        Result.success(dataArray)
                    } else {
                        Result.failure(Exception("Empty response body"))
                    }
                } else if (response.code() == 401) {
                    // Handle unauthorized (JWT token might be expired or invalid)
                    Result.failure(Exception("Unauthorized: Invalid or expired token"))
                } else {
                    Result.failure(Exception("Failed to fetch data: ${response.message()}"))
                }
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    }
}

