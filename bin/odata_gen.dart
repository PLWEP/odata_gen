import 'dart:io';
import 'package:args/command_runner.dart';
// import 'package:yaml/yaml.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('odata_gen', 'Odata client & service generator')
    ..addCommand(InitCommand())
    ..addCommand(GenCommand());

  runner.argParser
    ..addFlag(
      'init',
      abbr: 'i',
      negatable: false,
      help: 'Initialize the project',
    )
    ..addOption(
      'gen',
      abbr: 'g',
      help: 'Generate using config file',
    );

  try {
    if (arguments.contains('--init') || arguments.contains('-i')) {
      await InitCommand().run();
      return;
    }

    if (arguments.contains('--gen') || arguments.contains('-g')) {
      final index = arguments.indexOf('--gen') != -1
          ? arguments.indexOf('--gen')
          : arguments.indexOf('-g');
      final configFile =
          (index + 1 < arguments.length) ? arguments[index + 1] : 'config.yaml';
      await GenCommand().runWithFile(configFile);
      return;
    }

    await runner.run(arguments);
  } catch (e) {
    print('Error: $e');
    print('Use "dart run tools help" for usage.');
  }
}

class InitCommand extends Command {
  @override
  final name = 'init';
  @override
  final aliases = ['i'];
  @override
  final description = 'Initialize the project structure';

  @override
  Future<void> run() async {
    await runWithFile();
  }

  Future<void> runWithFile() async {
    print('Initializing project...');
    final file = File('config.yaml');
    if (!file.existsSync()) {
      file.writeAsStringSync('name: my_project\nversion: 1.0.0\n');
      print('config.yaml created.');
    } else {
      print('config.yaml already exists.');
    }
  }
}

class GenCommand extends Command {
  @override
  final name = 'gen';
  @override
  final aliases = ['g'];
  @override
  final description = 'Generate using config file (default: config.yaml)';

  @override
  Future<void> run() async {
    final configFile = argResults?.rest.isNotEmpty == true
        ? argResults!.rest.first
        : 'config.yaml';
    await runWithFile(configFile);
  }

  Future<void> runWithFile(String configFile) async {
    print('Generating using $configFile...');
    final file = File(configFile);
    if (!file.existsSync()) {
      print('Error: $configFile not found');
      exit(1);
    }
    final content = file.readAsStringSync();
    // final yaml = loadYaml(content);
    // print('Loaded config: $yaml');
    // Tambahkan proses sesuai YAML
  }
}
