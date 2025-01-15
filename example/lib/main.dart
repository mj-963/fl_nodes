import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fl_nodes/fl_nodes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    BrowserContextMenu.disableContextMenu();
  }

  runApp(const NodeEditorExampleApp());
}

class NodeEditorExampleApp extends StatelessWidget {
  const NodeEditorExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Editor Example',
      theme: ThemeData.dark(),
      home: const NodeEditorExampleScreen(),
      debugShowCheckedModeBanner: kDebugMode,
    );
  }
}

class NodeEditorExampleScreen extends StatefulWidget {
  const NodeEditorExampleScreen({super.key});

  @override
  State<NodeEditorExampleScreen> createState() =>
      NodeEditorExampleScreenState();
}

class NodeEditorExampleScreenState extends State<NodeEditorExampleScreen> {
  final FlNodeEditorController _nodeEditorController = FlNodeEditorController();

  @override
  void initState() {
    super.initState();

    _nodeEditorController.registerNodePrototype(
      NodePrototype(
        name: 'Add',
        description: 'Adds two numbers together.',
        color: Colors.amber,
        ports: [
          InputPortPrototype(name: 'A', dataType: double),
          InputPortPrototype(name: 'B', dataType: double),
          OutputPortPrototype(name: 'Result', dataType: double),
        ],
        onExecute: (inputs, fields, outputs) {},
      ),
    );

    _nodeEditorController.registerNodePrototype(
      NodePrototype(
        name: 'Input',
        description: 'Inputs a value.',
        color: Colors.red,
        ports: [
          OutputPortPrototype(name: 'Value', dataType: double),
        ],
        onExecute: (inputs, fields, outputs) {},
      ),
    );

    _nodeEditorController.registerNodePrototype(
      NodePrototype(
        name: 'Output',
        description: 'Outputs a value.',
        color: Colors.green,
        ports: [
          InputPortPrototype(
            name: 'Value',
            dataType: double,
          ),
        ],
        onExecute: (inputs, fields, outputs) {},
      ),
    );

    _nodeEditorController.registerNodePrototype(
      NodePrototype(
        name: 'Round',
        description: 'Rounds a number to a specified number of decimals.',
        color: Colors.blue,
        ports: [
          InputPortPrototype(name: 'Value', dataType: double),
          OutputPortPrototype(name: 'Rounded', dataType: int),
        ],
        fields: [
          FieldPrototype(
            name: 'Decimals',
            dataType: int,
            defaultData: 2,
            visualizerBuilder: (data) => Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                spacing: 4,
                children: [
                  Text(
                    data.toString(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
            editorBuilder: (context, removeOverlay, data, setData) => Container(
              constraints: const BoxConstraints(
                minHeight: 20,
                minWidth: 50,
                maxWidth: 200,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[800]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(128),
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                initialValue: data.toString(),
                onChanged: (value) => setData(int.tryParse(value) ?? 0),
                onFieldSubmitted: (value) {
                  setData(int.tryParse(value) ?? 0);
                  removeOverlay.call();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(4),
                ),
              ),
            ),
          ),
        ],
        onExecute: (input, fields, outputs) {},
      ),
    );
  }

  @override
  void dispose() {
    _nodeEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FlHierarchyWidget(
              controller: _nodeEditorController,
              style: const FlHierarchyStyle(),
            ),
            Expanded(
              child: FlNodeEditor(
                controller: _nodeEditorController,
                expandToParent: true,
                style: const FlNodeEditorStyle(
                  gridStyle: FlGridStyle(
                    lineWidth: 1,
                    intersectionRadius: 2,
                  ),
                ),
                overlay: () {
                  return [
                    FlOverlayData(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: FlSearchWidget(
                          controller: _nodeEditorController,
                          style: const FlSearchStyle(),
                        ),
                      ),
                    ),
                    FlOverlayData(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlOverlayData(
                      bottom: 0,
                      left: 0,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mouse Commands:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(' - Left Click: Select Node'),
                            Text(' - Right Click: Open Context Menu'),
                            Text(' - Scroll: Zoom In/Out'),
                            Text(' - Middle Click: Pan'),
                            SizedBox(height: 8),
                            Text(
                              'Keyboard Commands:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(' - Ctrl + C: Copy Node'),
                            Text(' - Ctrl + V: Paste Node'),
                            Text(' - Ctrl + X: Cut Node'),
                            Text(' - Delete | Backspace: Remove Node'),
                            Text(' - Ctrl + Z: Undo'),
                            Text(' - Ctrl + Y: Redo'),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
