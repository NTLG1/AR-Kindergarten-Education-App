package com.example.arkindergartenapp.ui.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.example.arkindergartenapp.api.AuthService
import com.example.arkindergartenapp.databinding.FragmentForgotPasswordBinding
import com.example.arkindergartenapp.supporting.AlertManager
import com.example.arkindergartenapp.supporting.Validator
import com.example.arkindergartenapp.supporting.showInvalidEmailAlert
import com.example.arkindergartenapp.supporting.showPasswordResetSent
import kotlinx.coroutines.launch

class ForgotPasswordFragment : Fragment() {

    private var _binding: FragmentForgotPasswordBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentForgotPasswordBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.resetPasswordButton.setOnClickListener {
            val email = binding.emailField.text.toString()

            // Validate email input
            if (!Validator.isValidEmail(email)) {
                AlertManager.showInvalidEmailAlert(requireContext())
                return@setOnClickListener
            }

            // Proceed with password reset
            lifecycleScope.launch {
                val resetResult = AuthService.forgotPassword(email)
                resetResult.fold(
                    onSuccess = { success ->
                        if (success) {
                            AlertManager.showPasswordResetSent(requireContext())
    //                            findNavController().navigateUp()
                        } else {
                            AlertManager.showBasicAlert(requireContext(), "Password Reset Failed", "Please try again.")
                        }
                    },
                    onFailure = { error ->
                        AlertManager.showBasicAlert(requireContext(), "Error", error.message ?: "Unknown error")
                    }
                )
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
