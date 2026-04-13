//package com.example.arkindergartenapp.ui
//
//import android.content.Intent
//import android.os.Bundle
//import android.widget.ImageView
//import android.widget.LinearLayout
//import android.widget.ScrollView
//import android.widget.TextView
//import androidx.appcompat.app.AppCompatActivity
//import com.example.arkindergartenapp.R
//
//class HomeActivity : AppCompatActivity() {
//
//    private val modes = arrayOf("Exploration Mode", "Learning Mode", "Creation Mode", "Settings", "Exit")
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setContentView(R.layout.activity_home)
//
//        val scrollView = findViewById<ScrollView>(R.id.scrollView)
//        val container = LinearLayout(this).apply {
//            orientation = LinearLayout.VERTICAL
//        }
//        scrollView.addView(container)
//
//        modes.forEachIndexed { index, mode ->
//            val modeView = createModeView(mode, index)
//            container.addView(modeView)
//        }
//    }
//
//    private fun createModeView(mode: String, index: Int): LinearLayout {
//        val containerView = LinearLayout(this).apply {
//            orientation = LinearLayout.VERTICAL
//            setPadding(0, 20, 0, 20)
//        }
//
//        val imageView = ImageView(this).apply {
//            setImageResource(when (mode) {
//                "Exploration Mode" -> R.drawable.exploration_mode
//                "Learning Mode" -> R.drawable.learning_mode
//                "Creation Mode" -> R.drawable.creation_mode
//                "Settings" -> R.drawable.settings_mode
//                "Exit" -> R.drawable.exit_mode
//                else -> R.drawable.default_image
//            })
//            scaleType = ImageView.ScaleType.CENTER_CROP
//            adjustViewBounds = true
//        }
//
//        val textView = TextView(this).apply {
//            text = mode
//            textSize = 20f
//            setPadding(0, 10, 0, 0)
//        }
//
//        containerView.addView(imageView)
//        containerView.addView(textView)
//
//        if (mode == "Settings") {
//            containerView.setOnClickListener {
//                startActivity(Intent(this, SettingsActivity::class.java))
//            }
//        }
//
//        return containerView
//    }
//}
