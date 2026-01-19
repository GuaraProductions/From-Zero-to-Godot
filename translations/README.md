# Translation Files

This folder contains translation files for the **From Zero to Godot** plugin.

## File Format

We use **PO (Portable Object)** files, which is the standard format for translations in many open-source projects. This format is supported by:

- 🌐 **[Weblate](https://weblate.org/)** - Free for open-source projects
- 🌐 **[Crowdin](https://crowdin.com/)** - Popular translation platform
- 🌐 **[POEditor](https://poeditor.com/)** - Simple and intuitive interface
- 🌐 **[Transifex](https://www.transifex.com/)** - Enterprise-grade translation management

## Files

- `template.pot` - Translation template (base for all translations)
- `pt_BR.po` - Brazilian Portuguese (original language)
- `en.po` - English translation
- `es.po` - Spanish translation (to be created)
- `fr.po` - French translation (to be created)
- `de.po` - German translation (to be created)
- `it.po` - Italian translation (to be created)
- `ja.po` - Japanese translation (to be created)
- `zh.po` - Chinese translation (to be created)
- `ru.po` - Russian translation (to be created)

## How to Use in Godot

### Option 1: Manual Import (Recommended for Godot 4.x)

1. Import the PO files into Godot (they will be converted to `.translation` files automatically)
2. Go to **Project > Project Settings > Localization > Translations**
3. Add the `.translation` files to the project
4. Set the locale remaps if needed

### Option 2: CSV (Alternative)

If you prefer CSV format for simpler editing, you can convert PO files to CSV using tools like `po2csv`.

## How to Contribute Translations

### Using Weblate (Recommended)

1. Access the project on Weblate
2. Select your language
3. Translate the strings
4. Submit your translations

### Manual Translation

1. Copy `template.pot` and rename it to your language code (e.g., `es.po` for Spanish)
2. Edit the file with a text editor or PO editor like [Poedit](https://poedit.net/)
3. Fill in the `msgstr` fields with your translations
4. Submit a pull request on GitHub

## Language Codes

- `pt_BR` - Portuguese (Brazil)
- `en` - English
- `es` - Spanish
- `fr` - French
- `de` - German
- `it` - Italian
- `ja` - Japanese
- `zh` - Chinese
- `ru` - Russian

## Tools for Editing PO Files

- **[Poedit](https://poedit.net/)** - Desktop application for Windows, Mac, and Linux
- **[Lokalize](https://userbase.kde.org/Lokalize)** - KDE translation tool
- **[Gtranslator](https://wiki.gnome.org/Apps/Gtranslator)** - GNOME translation tool
- **VS Code** with [Gettext extension](https://marketplace.visualstudio.com/items?itemName=mrorz.language-gettext)

## Notes

- The PO files contain all UI strings from the plugin
- Plugin name, author, and technical terms should remain in English
- Keep formatting markers (like `%s`, `%d`) in the same position
- Test your translations in Godot before submitting

---

Thank you for contributing to making **From Zero to Godot** accessible to more people! 🌍🚀
