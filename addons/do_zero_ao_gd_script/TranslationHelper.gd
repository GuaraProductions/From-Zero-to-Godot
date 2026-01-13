@tool
class_name TranslationHelper
extends RefCounted

## Helper class for translating text in editor plugins
## Handles both editor and runtime translation

static func translate(text: String, locale: String = "") -> String:
	if locale.is_empty():
		locale = _get_current_locale()
	
	var localized_text: String = ""
	
	if Engine.is_editor_hint():
		# In editor, manually get translation object
		var translation: Translation = TranslationServer.get_translation_object(locale)
		if translation:
			localized_text = translation.get_message(text)
	else:
		# In game, use TranslationServer
		localized_text = TranslationServer.translate(text, locale)
	
	# Fallback to original text if translation not found
	if localized_text.is_empty():
		return text
	
	return localized_text

static func _get_current_locale() -> String:
	# Try to get editor locale
	if Engine.is_editor_hint():
		var editor_settings = EditorInterface.get_editor_settings() if EditorInterface else null
		if editor_settings:
			var editor_locale = editor_settings.get_setting("interface/editor/editor_language")
			if editor_locale and not editor_locale.is_empty():
				return editor_locale
	
	# Fallback to OS locale
	var os_locale = OS.get_locale()
	return os_locale if not os_locale.is_empty() else "en"
