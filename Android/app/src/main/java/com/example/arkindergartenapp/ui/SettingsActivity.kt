//package com.example.arkindergartenapp.ui
//
//import android.app.Activity
//import android.content.Intent
//import android.os.Bundle
//import android.widget.*
//import androidx.appcompat.app.AppCompatActivity
//import com.example.arkindergartenapp.R
//
//class SettingsActivity : AppCompatActivity() {
//
//    private var username = "User"
//    private var soundEnabled = true
//    private var volume = 50
//    private var fontSize = 2
//    private var notificationsEnabled = true
//    private var profileImage = R.drawable.ic_person
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setContentView(R.layout.activity_settings)
//
//        val listView = findViewById<ListView>(R.id.settings_list)
//
//        val adapter = SettingsAdapter(this)
//        listView.adapter = adapter
//
//        listView.setOnItemClickListener { _, _, position, _ ->
//            when (position) {
//                0 -> {
//                    // Handle profile image tap
//                    val intent = Intent(Intent.ACTION_PICK).apply {
//                        type = "image/*"
//                    }
//                    startActivityForResult(intent, 1)
//                }
//                6 -> {
//                    // Handle reset to default settings
//                    resetToDefaultSettings()
//                }
//            }
//        }
//    }
//
//    private fun resetToDefaultSettings() {
//        username = "User"
//        soundEnabled = true
//        volume = 50
//        fontSize = 2
//        notificationsEnabled = true
//        profileImage = R.drawable.ic_person
//        (findViewById<ListView>(R.id.settings_list).adapter as SettingsAdapter).notifyDataSetChanged()
//    }
//
//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
//        if (requestCode == 1 && resultCode == Activity.RESULT_OK) {
//            data?.data?.let { uri ->
//                profileImage = uri // Handle the image URI
//            }
//            (findViewById<ListView>(R.id.settings_list).adapter as SettingsAdapter).notifyDataSetChanged()
//        }
//    }
//
//    inner class SettingsAdapter(private val context: Activity) : BaseAdapter() {
//        override fun getCount() = 7 // Number of settings
//
//        override fun getItem(position: Int): Any = position
//
//        override fun getItemId(position: Int): Long = position.toLong()
//
//        override fun getView(position: Int, convertView: android.view.View?, parent: android.view.ViewGroup?): android.view.View {
//            val view = convertView ?: layoutInflater.inflate(R.layout.settings_item, parent, false)
//
//            val textView = view.findViewById<TextView>(R.id.setting_title)
//            val imageView = view.findViewById<ImageView>(R.id.setting_image)
//
//            when (position) {
//                0 -> {
//                    textView.text = "Username: $username"
//                    imageView.setImageResource(profileImage)
//                }
//                1 -> {
//                    textView.text = "Enable Sound Effects"
//                    val toggle = Switch(context).apply {
//                        isChecked = soundEnabled
//                        setOnCheckedChangeListener { _, isChecked -> soundEnabled = isChecked }
//                    }
//                    view.findViewById<LinearLayout>(R.id.setting_container).addView(toggle)
//                }
//                2 -> {
//                    textView.text = "Volume: $volume"
//                    val slider = SeekBar(context).apply {
//                        progress = volume
//                        setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {
//                            override fun onProgressChanged(seekBar: SeekBar?, progress: Int, fromUser: Boolean) {
//                                volume = progress
//                                textView.text = "Volume: $volume"
//                            }
//                            override fun onStartTrackingTouch(seekBar: SeekBar?) {}
//                            override fun onStopTrackingTouch(seekBar: SeekBar?) {}
//                        })
//                    }
//                    view.findViewById<LinearLayout>(R.id.setting_container).addView(slider)
//                }
//                3 -> {
//                    textView.text = "Font Size"
//                    val segmentedControl = RadioGroup(context).apply {
//                        orientation = RadioGroup.HORIZONTAL
//                        listOf("Very Small", "Small", "Medium", "Big").forEachIndexed { index, s ->
//                            val radioButton = RadioButton(context).apply {
//                                text = s
//                                isChecked = fontSize - 1 == index
//                                setOnClickListener { fontSize = index + 1 }
//                            }
//                            addView(radioButton)
//                        }
//                    }
//                    view.findViewById<LinearLayout>(R.id.setting_container).addView(segmentedControl)
//                }
//                4 -> {
//                    textView.text = "Enable Notifications"
//                    val toggle = Switch(context).apply {
//                        isChecked = notificationsEnabled
//                        setOnCheckedChangeListener { _, isChecked -> notificationsEnabled = isChecked }
//                    }
//                    view.findViewById<LinearLayout>(R.id.setting_container).addView(toggle)
//                }
//                5 -> textView.text = "About the App"
//                6 -> {
//                    textView.text = "Reset to Default Settings"
//                    textView.setTextColor(resources.getColor(android.R.color.holo_red_dark, null))
//                }
//            }
//            return view
//        }
//    }
//}
