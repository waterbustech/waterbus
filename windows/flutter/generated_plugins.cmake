#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  audioplayers_windows
  connectivity_plus
  file_saver
  file_selector_windows
  firebase_auth
  firebase_core
  flutter_webrtc_plus
  irondash_engine_context
  media_kit_libs_windows_video
  media_kit_video
  permission_handler_windows
  screen_brightness_windows
  share_plus
  super_native_extensions
  url_launcher_windows
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
  media_kit_native_event_loop
  rhttp
  simple_native_image_compress
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/windows plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
