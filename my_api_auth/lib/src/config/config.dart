/// Configuration for this Angel instance.
library my_api_auth.src.config;

import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:file/file.dart';
import 'plugins/plugins.dart' as plugins;

/// This is a perfect place to include configuration and load plug-ins.
AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Load configuration from the `config/` directory.
    //
    // See: https://github.com/angel-dart/configuration
    await app.configure(configuration(fileSystem));


    // Apply another plug-ins, i.e. ones that *you* have written.
    //
    // Typically, the plugins in `lib/src/config/plugins/plugins.dart` are plug-ins
    // that add functionality specific to your application.
    //
    // If you write a plug-in that you plan to use again, or are
    // using one created by the community, include it in
    // `lib/src/config/config.dart`.
    await plugins.configureServer(app);
  };
}
