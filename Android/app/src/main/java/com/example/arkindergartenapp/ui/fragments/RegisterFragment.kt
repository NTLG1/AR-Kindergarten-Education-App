package com.example.arkindergartenapp.ui.fragments

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.text.SpannableString
import android.text.Spanned
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.example.arkindergartenapp.api.AuthService
import com.example.arkindergartenapp.api.DataService
import com.example.arkindergartenapp.data.models.RegisterUserRequest
import com.example.arkindergartenapp.databinding.FragmentRegisterBinding
import com.example.arkindergartenapp.supporting.AlertManager
import com.example.arkindergartenapp.supporting.Validator
import com.example.arkindergartenapp.supporting.showInvalidEmailAlert
import com.example.arkindergartenapp.supporting.showInvalidPasswordAlert
import com.example.arkindergartenapp.supporting.showInvalidUsernameAlert
import com.google.android.material.snackbar.Snackbar
import kotlinx.coroutines.launch

class RegisterFragment : Fragment() {

    private var _binding: FragmentRegisterBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentRegisterBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.signUpButton.setOnClickListener {
            val username = binding.usernameField.text.toString()
            val email = binding.emailField.text.toString()
            val password = binding.passwordField.text.toString()

            // Validate input fields
            if (!Validator.isValidUsername(username)) {
                AlertManager.showInvalidUsernameAlert(requireContext())
                return@setOnClickListener
            }
            if (!Validator.isValidEmail(email)) {
                AlertManager.showInvalidEmailAlert(requireContext())
                return@setOnClickListener
            }

            if (!Validator.isPasswordValid(password)) {
                AlertManager.showInvalidPasswordAlert(requireContext())
                return@setOnClickListener
            }

            // Proceed with registration
            lifecycleScope.launch {
                val registerRequest = RegisterUserRequest(email, username, password)
                val registerResult = AuthService.createAccount(registerRequest)
                registerResult.fold(
                    onSuccess = { success ->
                        if (success) {
                            Toast.makeText(requireContext(), "Registration successful", Toast.LENGTH_LONG).show()
                            fetchData()
                        } else {
                            AlertManager.showBasicAlert(requireContext(), "Registration Failed", "Please try again.")
                        }
                    },
                    onFailure = { error ->
                        AlertManager.showBasicAlert(requireContext(), "Error", error.message ?: "Unknown error")
                    }
                )
            }
        }
        setupClickableTermsText()

        binding.signInButton.setOnClickListener {
            findNavController().navigateUp()
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

    private fun setupClickableTermsText() {
        val text = "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy."

        val spannableString = SpannableString(text)

        // ClickableSpan for Terms & Conditions
        val termsClickableSpan = object : ClickableSpan() {
            override fun onClick(widget: View) {
                openWebPage("https://policies.google.com/terms?hl=en")
            }
        }

        // ClickableSpan for Privacy Policy
        val privacyClickableSpan = object : ClickableSpan() {
            override fun onClick(widget: View) {
                openWebPage("https://policies.google.com/privacy?hl=en")
            }
        }

        val termsStart = text.indexOf("Terms & Conditions")
        val termsEnd = termsStart + "Terms & Conditions".length

        val privacyStart = text.indexOf("Privacy Policy")
        val privacyEnd = privacyStart + "Privacy Policy".length

        spannableString.setSpan(termsClickableSpan, termsStart, termsEnd, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        spannableString.setSpan(privacyClickableSpan, privacyStart, privacyEnd, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)

        binding.termsTextView.text = spannableString
        binding.termsTextView.movementMethod = LinkMovementMethod.getInstance()
    }

    private fun openWebPage(url: String) {
        val webIntent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        startActivity(webIntent)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
