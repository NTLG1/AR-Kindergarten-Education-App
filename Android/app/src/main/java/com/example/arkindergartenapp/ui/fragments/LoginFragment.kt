package com.example.arkindergartenapp.ui.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.example.arkindergartenapp.R
import com.example.arkindergartenapp.api.AuthService
import com.example.arkindergartenapp.api.DataService
import com.example.arkindergartenapp.databinding.FragmentLoginBinding
import com.example.arkindergartenapp.supporting.AlertManager
import com.example.arkindergartenapp.supporting.Validator
import com.example.arkindergartenapp.supporting.showInvalidEmailAlert
import com.example.arkindergartenapp.supporting.showInvalidPasswordAlert
import com.example.arkindergartenapp.supporting.showSignInErrorAlert
import kotlinx.coroutines.launch

class LoginFragment : Fragment() {

    private var _binding: FragmentLoginBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentLoginBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.signInButton.setOnClickListener {
            val email = binding.emailField.text.toString()
            val password = binding.passwordField.text.toString()

            // Input validation
            if (!Validator.isValidEmail(email)) {
                AlertManager.showInvalidEmailAlert(requireContext())
                return@setOnClickListener
            }

            if (!Validator.isPasswordValid(password)) {
                AlertManager.showInvalidPasswordAlert(requireContext())
                return@setOnClickListener
            }

            // Proceed to login
            lifecycleScope.launch {
                val signInResult = AuthService.signIn(email, password)
                signInResult.fold(
                    onSuccess = { signInSuccess ->
                        if (signInSuccess) {
                            Toast.makeText(requireContext(), "Sign-in successful", Toast.LENGTH_LONG).show()
                            fetchData()
                        } else {
                            AlertManager.showSignInErrorAlert(requireContext(), "Sign-in failed. Please check your credentials.")
                        }
                    },
                    onFailure = { error ->
                        AlertManager.showSignInErrorAlert(requireContext(), "Sign-in failed: ${error.message}")
                    }
                )
            }
        }

        binding.newUserButton.setOnClickListener {
            findNavController().navigate(R.id.action_loginFragment_to_registerFragment)
        }

        binding.forgotPasswordButton.setOnClickListener {
            findNavController().navigate(R.id.action_loginFragment_to_forgotPasswordFragment)
        }
    }

    private suspend fun fetchData() {
        try {
            val dataResult = DataService.getData()
            dataResult.fold(
                onSuccess = { dataArray ->
                    Toast.makeText(requireContext(), "Data fetched: ${dataArray.data}", Toast.LENGTH_LONG).show()
                    // Navigate to the next screen or handle the data as needed
                },
                onFailure = { error ->
                    AlertManager.showBasicAlert(requireContext(), "Error Fetching Data", error.message)
                }
            )
        } catch (e: Exception) {
            AlertManager.showBasicAlert(requireContext(), "Error", e.message)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
