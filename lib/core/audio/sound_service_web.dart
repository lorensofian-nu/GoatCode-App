import 'dart:js_interop';

@JS('playGoatCodeSound')
external void _jsPlaySound(JSString type);

/// Web audio synthesizer delegating to window.playGoatCodeSound.
void playPlatformSound(String type) {
  try {
    _jsPlaySound(type.toJS);
  } catch (_) {
    // Fails safely if audio context is blocked by browser policy prior to user interaction.
  }
}
