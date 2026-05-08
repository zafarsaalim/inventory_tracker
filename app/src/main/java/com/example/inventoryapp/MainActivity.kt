package com.example.inventoryapp

import android.os.Bundle
import android.webkit.JavascriptInterface
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues
import android.database.Cursor
import android.util.Log

class MainActivity : AppCompatActivity() {

    lateinit var db: SQLiteDatabase

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val webView = WebView(this)
        webView.settings.javaScriptEnabled = true
        webView.webViewClient = WebViewClient()
        webView.loadUrl("file:///android_asset/index.html")

        val helper = DBHelper()
        db = helper.writableDatabase

        webView.addJavascriptInterface(JSBridge(), "Android")

        setContentView(webView)
    }

    inner class DBHelper : SQLiteOpenHelper(this@MainActivity, "inventory.db", null, 1) {
        override fun onCreate(db: SQLiteDatabase) {
            db.execSQL(
                "CREATE TABLE IF NOT EXISTS items(" +
                        "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                        "name TEXT, " +
                        "qty INTEGER)"
            )
        }
        override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {}
    }

    inner class JSBridge {

        @JavascriptInterface
        fun addItem(name: String, qty: Int) {
            try {
                val cv = ContentValues()
                cv.put("name", name)
                cv.put("qty", qty)
                db.insert("items", null, cv)
            } catch (e: Exception) {
                Log.e("JSBridge", "addItem error: ${e.message}")
            }
        }

        @JavascriptInterface
        fun getItems(): String {
            val cursor: Cursor = db.rawQuery("SELECT * FROM items", null)
            val list = mutableListOf<Map<String, Any>>()
            if (cursor.moveToFirst()) {
                do {
                    val item = mapOf(
                        "id" to cursor.getInt(cursor.getColumnIndexOrThrow("id")),
                        "name" to cursor.getString(cursor.getColumnIndexOrThrow("name")),
                        "qty" to cursor.getInt(cursor.getColumnIndexOrThrow("qty"))
                    )
                    list.add(item)
                } while (cursor.moveToNext())
            }
            cursor.close()
            return list.toString() // simple string, can parse in JS
        }

        @JavascriptInterface
        fun updateItem(id: Int, name: String, qty: Int) {
            val cv = ContentValues()
            cv.put("name", name)
            cv.put("qty", qty)
            db.update("items", cv, "id=?", arrayOf(id.toString()))
        }

        @JavascriptInterface
        fun deleteItem(id: Int) {
            db.delete("items", "id=?", arrayOf(id.toString()))
        }
    }
}
