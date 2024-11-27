import 'package:flutter/widgets.dart';

import 'text_processor/text_processor.dart';

class ListenableTextProcessorController
    extends ValueNotifier<TextProcessorState>
    implements TextProcessorController {
  ListenableTextProcessorController({TextProcessorState? initialState})
      : super(initialState ?? TextProcessorState.empty());
}
