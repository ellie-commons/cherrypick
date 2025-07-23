/*
* Copyright (c) 2022 Adithyan K V <adithyankv@protonmail.com>
* Copyright (c) 2025 Stella, Charlie, (teamcons on GitHub) and the Ellie_Commons community
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or(at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

namespace Cherrypick {
    public class Application : Gtk.Application {
        private Window? window;
        private Xdp.Portal portal;

        private OptionEntry[] CMD_OPTION_ENTRIES = {
            {"immediately-pick", 'p', OptionFlags.NONE, OptionArg.NONE, null, _("Immediately pick a colour and copy it to clipboard"), null}
        };

        public Application () {
            Object (
                application_id: "io.github.ellie_commons.cherrypick",
                flags: ApplicationFlags.HANDLES_COMMAND_LINE
            );
        }

        construct {
            add_main_option_entries (CMD_OPTION_ENTRIES);

            var quit_action = new SimpleAction ("quit", null);
            add_action (quit_action);
            set_accels_for_action ("app.quit", {"<Control>q"});
            quit_action.activate.connect (quit);

            var pick_action = new SimpleAction ("pick", null);
            add_action (pick_action);
            set_accels_for_action ("app.pick", {"<Control>p"});
            pick_action.activate.connect (immediately_pick);
        }

        public override void startup () {
            Granite.init ();
            base.startup ();

            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
            Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
            Intl.textdomain (GETTEXT_PACKAGE);


            var granite_settings = Granite.Settings.get_default ();
            var gtk_settings = Gtk.Settings.get_default ();

            gtk_settings.gtk_application_prefer_dark_theme = (
                                                            granite_settings.prefers_color_scheme == DARK
            );

            granite_settings.notify["prefers-color-scheme"].connect (() => {
                gtk_settings.gtk_application_prefer_dark_theme = (
                                                                granite_settings.prefers_color_scheme == DARK
                );
            });

        }

        public override void activate () {
            /* Restricting to only one open instance of the application window.
               It doesn't make much sense to have multiple instances as there
               are no real valid use cases. And with the current architecture
               the state is global and would be shared between multiple
               instances anyway. */

            if (window == null) {
                window = new Cherrypick.Window (this);

                var provider = new Gtk.CssProvider ();
                provider.load_from_resource ("/io/github/ellie_commons/cherrypick/Application.css");
                    Gtk.StyleContext.add_provider_for_display (
                        Gdk.Display.get_default (),
                        provider,
                        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                    );
                    window.show ();

            } else {
                    window.present ();
            }
        }

        public override int command_line (ApplicationCommandLine command) {

            /* Opens and immediately starts picking color if the --immediately-pick
               flag is passed when launching from the command line. This could
               be helpful for the user to set up keybindings and stuff */
            var options = command.get_options_dict ();
            if (options.contains ("immediately-pick")) {
                immediately_pick ();

            }

            //FIXME: Prevent window from showing if we do an immediate pick
            //Quit or anything that makes Activate not do a window, end up in Picking failing
            activate ();
            return 0;
        }

        private void immediately_pick () {
            var notification = new Notification (_("Pick a color"));
            // TRANSLATORS: "%s%%" is replaced by a colour code 
            var body = _("Pick a colour on your screen and it will be copied to your clipboard");
            notification.set_body (body);
            notification.set_priority (GLib.NotificationPriority.NORMAL);
            this.send_notification ("notify.app", notification);

            portal = new Xdp.Portal ();
            portal.pick_color.begin (null, null, immediately_picked);
        }

        //FIXME: This is horrific and redundant and icky
        // Ideally it would be in ColorPicker but then you dont have Applications to send notifications to
        // Notifications need to be in the callback else it immediately fires up
        private void immediately_picked (Object? obj, AsyncResult result) {
                try {
                    var color = this.portal.pick_color.end (result);
                    double r, g, b;

                    VariantIter iter = color.iterator ();
                    iter.next ("d", out r);
                    iter.next ("d", out g);
                    iter.next ("d", out b);

                    var picked_color = new Color () {
                        red = (uint8) (r * 255),
                        green = (uint8) (g * 255),
                        blue = (uint8) (b * 255),
                        alpha = (double) 1.0
                    };

                    var color_controller = ColorController.get_instance ();
                    color_controller.last_picked_color = picked_color;
                    color_controller.color_history.append (picked_color);

                    var picked_formatted = picked_color.to_preferred_string ();
                    var clipboard = Gdk.Display.get_default ().get_clipboard ();
                    clipboard.set_text (picked_formatted);

                    var notification = new Notification (_("Copied to clipboard!"));
                    // TRANSLATORS: "%s%%" is replaced by a colour code 
                    var body = _("%s has been copied to your clipboard").printf (picked_formatted);
                    notification.set_body (body);
                    notification.set_priority (GLib.NotificationPriority.NORMAL);
                    this.send_notification ("notify.app", notification);

                } catch (Error e) {
                    critical (e.message);
                }
        }
    }
}
