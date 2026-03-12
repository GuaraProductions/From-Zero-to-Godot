@tool
class_name TranslationHelper
extends RefCounted

## Helper class for translating text in editor plugins
## Handles both editor and runtime translation

static func translate(text: String, locale: String = "") -> String:
	if locale.is_empty():
		locale = _get_current_locale()
	
	var localized_text: String = ""
	var locale_candidates = _build_locale_candidates(locale)
	
	if Engine.is_editor_hint():
		# In editor, manually get translation object.
		# Try locale aliases because the plugin uses folder locales like pt-br
		# while Translation resources commonly register as pt_BR.
		for candidate in locale_candidates:
			var translation: Translation = TranslationServer.get_translation_object(candidate)
			if translation:
				localized_text = translation.get_message(text)
				if not localized_text.is_empty():
					break
	else:
		# In game, use TranslationServer with locale aliases.
		for candidate in locale_candidates:
			localized_text = TranslationServer.translate(text, candidate)
			if not localized_text.is_empty() and localized_text != text:
				break
	
	# Fallback to original text if translation not found
	if localized_text.is_empty():
		return text
	
	return localized_text

static func _build_locale_candidates(locale: String) -> Array[String]:
	var candidates: Array[String] = []
	var normalized = locale.strip_edges()
	if normalized.is_empty():
		return candidates

	_add_candidate(candidates, normalized)
	_add_candidate(candidates, normalized.to_lower())
	_add_candidate(candidates, normalized.replace("-", "_"))
	_add_candidate(candidates, normalized.replace("_", "-"))

	var with_underscore = normalized.replace("-", "_")
	var parts = with_underscore.split("_", false)
	if parts.size() >= 2:
		var language = parts[0].to_lower()
		var region = parts[1].to_upper()
		_add_candidate(candidates, "%s_%s" % [language, region])
		_add_candidate(candidates, "%s-%s" % [language, region.to_lower()])
		_add_candidate(candidates, language)
	else:
		_add_candidate(candidates, normalized.get_slice("-", 0).to_lower())

	return candidates

static func _add_candidate(candidates: Array[String], candidate: String) -> void:
	if candidate.is_empty():
		return
	if not candidates.has(candidate):
		candidates.append(candidate)

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
