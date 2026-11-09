#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  GtkWidget* header_bar;
  GdkScreen* titlebar_screen;
  GtkCssProvider* titlebar_css_provider;
  FlMethodChannel* theme_channel;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
}

static gboolean set_titlebar_dark_mode(MyApplication* self,
                                       gboolean is_dark,
                                       GError** error) {
  if (self->titlebar_css_provider == nullptr) {
    return TRUE;
  }

  const gchar* css = is_dark
                         ? "window.csd, window.csd decoration {"
                           " border: none;"
                           " box-shadow: none;"
                           "}"
                           "headerbar, headerbar.titlebar {"
                           " background-color: #000000;"
                           " background-image: none;"
                           " color: #ffffff;"
                           " border: none;"
                           " box-shadow: none;"
                           "}"
                           "headerbar .title, headerbar button {"
                           " color: #ffffff;"
                           "}"
                         : "window.csd, window.csd decoration {"
                           " border: none;"
                           " box-shadow: none;"
                           "}"
                           "headerbar, headerbar.titlebar {"
                           " background-color: #ff9800;"
                           " background-image: none;"
                           " color: #ffffff;"
                           " border: none;"
                           " box-shadow: none;"
                           "}"
                           "headerbar .title, headerbar button {"
                           " color: #ffffff;"
                           "}";

  if (!gtk_css_provider_load_from_data(self->titlebar_css_provider, css, -1,
                                       error)) {
    return FALSE;
  }

  gtk_style_context_reset_widgets(self->titlebar_screen);
  if (self->header_bar != nullptr) {
    gtk_widget_queue_draw(self->header_bar);
  }
  return TRUE;
}

static void theme_method_call_cb(FlMethodChannel* channel,
                                 FlMethodCall* method_call,
                                 gpointer user_data) {
  MyApplication* self = MY_APPLICATION(user_data);
  const gchar* method = fl_method_call_get_name(method_call);

  if (g_strcmp0(method, "setDarkMode") != 0) {
    fl_method_call_respond_not_implemented(method_call, nullptr);
    return;
  }

  FlValue* args = fl_method_call_get_args(method_call);
  if (args == nullptr || fl_value_get_type(args) != FL_VALUE_TYPE_BOOL) {
    fl_method_call_respond_error(method_call, "invalid_arguments",
                                 "Expected a boolean dark-mode value.", nullptr,
                                 nullptr);
    return;
  }

  g_autoptr(GError) error = nullptr;
  if (!set_titlebar_dark_mode(self, fl_value_get_bool(args), &error)) {
    g_warning("Failed to update GTK title bar theme: %s", error->message);
    fl_method_call_respond_error(method_call, "gtk_css_error", error->message,
                                 nullptr, nullptr);
    return;
  }

  fl_method_call_respond_success(method_call, nullptr, nullptr);
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "KSVH Exam Scholar");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    self->header_bar = GTK_WIDGET(header_bar);
    g_object_add_weak_pointer(G_OBJECT(header_bar),
                              reinterpret_cast<gpointer*>(&self->header_bar));
    self->titlebar_screen = GDK_SCREEN(
        g_object_ref(gtk_widget_get_screen(GTK_WIDGET(window))));
    self->titlebar_css_provider = gtk_css_provider_new();
    gtk_style_context_add_provider_for_screen(
        self->titlebar_screen, GTK_STYLE_PROVIDER(self->titlebar_css_provider),
        GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "KSVH Exam Scholar");
  }

  gtk_window_set_default_size(window, 1280, 720);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->theme_channel = fl_method_channel_new(
      fl_engine_get_binary_messenger(fl_view_get_engine(view)), "ksvh/theme",
      FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->theme_channel,
                                            theme_method_call_cb, self, nullptr);

  GdkRGBA background_color;
  // Background defaults to black, override it here if necessary, e.g. #00000000
  // for transparent.
  gdk_rgba_parse(&background_color, "#000000");
  fl_view_set_background_color(view, &background_color);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application,
                                                  gchar*** arguments,
                                                  int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  if (self->titlebar_screen != nullptr &&
      self->titlebar_css_provider != nullptr) {
    gtk_style_context_remove_provider_for_screen(
        self->titlebar_screen, GTK_STYLE_PROVIDER(self->titlebar_css_provider));
  }
  g_clear_object(&self->theme_channel);
  g_clear_object(&self->titlebar_css_provider);
  g_clear_object(&self->titlebar_screen);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line =
      my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID, "flags",
                                     G_APPLICATION_NON_UNIQUE, nullptr));
}
