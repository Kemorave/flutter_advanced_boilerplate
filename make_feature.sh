#!/bin/bash

FEATURE="$1"

if [ -z "$FEATURE" ]; then
  echo "❌ Please provide a feature name. Example: ./make_feature.sh profile"
  exit 1
fi

# -------------------------------
# Convert feature name to CamelCase
# user-profile -> UserProfile
FEATURE_CAMEL=$(echo "$FEATURE" | awk -F'-' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print $0}' OFS='')

# Base folder
BASE_DIR="./lib/features/$FEATURE"

# -------------------------------
# Create folders
mkdir -p "$BASE_DIR/blocs"
mkdir -p "$BASE_DIR/networking"
mkdir -p "$BASE_DIR/presentation"

# -------------------------------
# blocs/${FEATURE}_cubit.dart
cat > "$BASE_DIR/blocs/${FEATURE}_cubit.dart" <<EOL
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart'; 
import 'package:flutter_advanced_boilerplate/features/$FEATURE/networking/${FEATURE}_repository.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';

part '${FEATURE}_cubit.freezed.dart';
part '${FEATURE}_state.dart';
 
class ${FEATURE_CAMEL}Cubit extends Cubit<${FEATURE_CAMEL}State> {
  ${FEATURE_CAMEL}Cubit(this._${FEATURE}Repository)
      : super(const ${FEATURE_CAMEL}State.loading());

  final ${FEATURE_CAMEL}Repository _${FEATURE}Repository;
}
EOL

# blocs/${FEATURE}_state.dart
cat > "$BASE_DIR/blocs/${FEATURE}_state.dart" <<EOL
part of '${FEATURE}_cubit.dart';

@freezed
class ${FEATURE_CAMEL}State with _\$${FEATURE_CAMEL}State {
  const factory ${FEATURE_CAMEL}State.loading() = _${FEATURE_CAMEL}LoadingState;
  const factory ${FEATURE_CAMEL}State.failed({required AlertModel alert}) = _${FEATURE_CAMEL}FailedState;
}
EOL

# networking/${FEATURE}_repository.dart
cat > "$BASE_DIR/networking/${FEATURE}_repository.dart" <<EOL 

class ${FEATURE_CAMEL}Repository {
  ${FEATURE_CAMEL}Repository( );
 
}
EOL

# presentation/${FEATURE}_screen.dart
cat > "$BASE_DIR/presentation/${FEATURE}_screen.dart" <<EOL
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_advanced_boilerplate/features/$FEATURE/blocs/${FEATURE}_cubit.dart';


class ${FEATURE_CAMEL}Screen extends StatelessWidget {
  const ${FEATURE_CAMEL}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<${FEATURE_CAMEL}Cubit>(),
      child: const _${FEATURE_CAMEL}ScreenContent(),
    );
  }
}

class _${FEATURE_CAMEL}ScreenContent extends StatelessWidget {
  const _${FEATURE_CAMEL}ScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('${FEATURE_CAMEL} Screen')),
    );
  }
}
EOL

echo "✅ Feature '$FEATURE' created at lib/features/$FEATURE"
