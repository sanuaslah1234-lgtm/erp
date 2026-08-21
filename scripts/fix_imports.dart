import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = await entity.readAsString();
      bool modified = false;

      // Replace package imports
      if (content.contains('package:erp_software/backend/models/')) {
        content = content.replaceAll('package:erp_software/backend/models/', 'package:erp_software/core/models/');
        modified = true;
      }
      if (content.contains('package:erp_software/frontend/models/')) {
        content = content.replaceAll('package:erp_software/frontend/models/', 'package:erp_software/core/models/');
        modified = true;
      }

      // Replace relative imports (rough heuristic)
      if (content.contains('../models/')) {
        // Only if it was referring to backend/models or frontend/models, but safely we can check 
        // the file path to see how many '../' we need to reach core/models
        final depth = entity.path.split(Platform.pathSeparator).length - 2; // -lib -file
        // This is complex, better to use absolute package imports for models
        final relativeModelsRegex = RegExp(r"import\s+['""](\.\./)+models/([^'""]+)['""];");
        if (relativeModelsRegex.hasMatch(content)) {
          content = content.replaceAllMapped(relativeModelsRegex, (match) {
            return "import 'package:erp_software/core/models/${match.group(2)}';";
          });
          modified = true;
        }
      }

      if (modified) {
        await entity.writeAsString(content);
        print('Updated imports in ${entity.path}');
      }
    }
  }
}
