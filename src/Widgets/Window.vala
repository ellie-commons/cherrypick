/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Adithyan K V <adithyankv@protonmail.com>
 */
namespace Picker {
    public class Window : Adw.ApplicationWindow {
        /* The main window for the application containing all the controls.
           Using libhandy so that we get rounded corners on the window. */

        private Gtk.Button pick_button;
        // public ColorPicker color_picker;

        public Window (Gtk.Application app) {
            Object (
                application: app
            );
        }

        construct {
            create_layout ();
            // load_css ();
            // load_state_from_gsettings ();

            // color_picker = new ColorPicker ();

            // pick_button.clicked.connect (() => {
            //     application.lookup_action (Application.ACTION_START_PICK).activate (null);
            // });
            //
            // delete_event.connect (() => {
            //     save_state_to_gsettings ();
            // });
        }

        private void create_layout () {
            var title = new Gtk.Label (_("Picker"));
            var headerbar = new Adw.HeaderBar () {
                hexpand = true,
                title_widget = title
            };
            headerbar.get_style_context ().add_class ("flat");

            // var color_preview = new Picker.ColorPreview ();
            pick_button = new Gtk.Button.with_label (_("Pick Color"));
            pick_button.get_style_context ().add_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);

            var format_label = new Gtk.Label (_("Format")) {
                xalign = 0
            };
            format_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            var format_area = new Picker.FormatArea ();

            var history_label = new Gtk.Label (_("History")) {
                xalign = 0
            };
            history_label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);

            // var history_buttons = new HistoryButtons ();

            var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 10) {
                hexpand = true,
                margin_start = 10,
                margin_end = 10,
                margin_bottom = 10,
            };
            vbox.append (format_label);
            vbox.append (format_area);
            vbox.append (history_label);
            // vbox.append (history_buttons);
            vbox.append (pick_button);

            /* The toasts coming up over the half with the controls looks nicer
               than coming up over the middle of the whole window */
            // var toast_overlay = ToastOverlay.get_instance ();
            // toast_overlay.add (vbox);

            /* We want the color preview area to span the entire height of the
               window, so using a custom grid layout for the entire window
               including the headerbar */
            var window_grid = new Gtk.Grid ();
            window_grid.attach (headerbar, 0, 0);
            window_grid.attach (vbox, 0, 1);
            // window_grid.attach (color_preview, 1, 0, 1, 2);

            /* As the headerbar spans only half the window, it would be
               more convenient to be able to move the window from anywhere */
            var window_handle = new Gtk.WindowHandle ();
            window_handle.child = window_grid;

            /* when the app is opened the user probably wants to pick the color
               straight away. So setting the pick button as focused default
               action so that pressing Return or Space starts the pick */
            // set_default (pick_button);
            // set_focus (pick_button);

            content = window_handle;
        }

        // private void load_state_from_gsettings () {
        //     var settings = Settings.get_instance ();
        //     int pos_x, pos_y;
        //     settings.get ("position", "(ii)", out pos_x, out pos_y);
        //     move (pos_x, pos_y);
        // }

        // private void save_state_to_gsettings () {
        //     var settings = Settings.get_instance ();
        //     int pos_x, pos_y;
        //     get_position (out pos_x, out pos_y);
        //     settings.set ("position", "(ii)", pos_x, pos_y);
        // }

        // private void load_css () {
        //     var css_provider = new Gtk.CssProvider ();
        //     css_provider.load_from_resource ("/com/github/phoneybadger/picker/application.css");
        //
        //     Gtk.StyleContext.add_provider_for_screen (
        //         Gdk.Screen.get_default (),
        //         css_provider,
        //         Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        //     );
        // }
    }
}
