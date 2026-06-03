import os
import pymupdf
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button
from kivy.uix.label import Label

class TrueRedactApp(App):
    def build(self):
        self.layout = BoxLayout(orientation='vertical', padding=30, spacing=15)
        self.label = Label(text="File path: /sdcard/Download/abc.pdf\nEnter words to scrub below:", halign="center")
        self.layout.add_widget(self.label)
        
        self.input_text = TextInput(hint_text="health records, CONFIDENTIAL", multiline=False, size_hint_y=None, height='50dp')
        self.layout.add_widget(self.input_text)
        
        self.btn = Button(text="PERMANENTLY REDACT", background_color=(0.1, 0.6, 0.4, 1), size_hint_y=None, height='60dp')
        self.btn.bind(on_press=self.execute_true_redaction)
        self.layout.add_widget(self.btn)
        return self.layout

    def execute_true_redaction(self, instance):
        input_path = "/sdcard/Download/abc.pdf"
        output_path = "/sdcard/Download/redacted.pdf"
        
        if not os.path.exists(input_path):
            self.label.text = "ERROR: 'abc.pdf' missing from Downloads!"
            return
            
        words = self.input_text.text
        target_phrases = [p.strip() for p in words.split(",") if p.strip()]
        
        if not target_phrases:
            self.label.text = "Please enter at least one word."
            return
            
        try:
            doc = pymupdf.open(input_path)
            redaction_applied = False
            for page in doc:
                for target in target_phrases:
                    text_instances = page.search_for(target, quads=True)
                    for quad in text_instances:
                        rect = quad.rect
                        rect.x0 += 0.5
                        rect.x1 -= 0.5
                        page.add_redact_annot(rect, fill=(0, 0, 0))
                        redaction_applied = True
                if redaction_applied:
                    page.apply_redactions()
                    
            doc.save(output_path, garbage=4, deflate=True)
            doc.close()
            self.label.text = "SUCCESS! Saved to Downloads folder."
        except Exception as e:
            self.label.text = f"Failure: {str(e)}"

if __name__ == "__main__":
    TrueRedactApp().run()
