import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fl_nodes/fl_nodes.dart';

enum Operator { add, subtract, multiply, divide }

enum Comparator { equal, notEqual, greater, greaterEqual, less, lessEqual }

void registerNodes(BuildContext context, FlNodeEditorController controller) {
  controller.registerNodePrototype(
    NodePrototype(
      idName: 'operator',
      displayName: 'Operator',
      description: 'Applies a chosen operation to two numbers.',
      color: Colors.yellow,
      allowRecursion: false,
      ports: [
        InputPortPrototype(
          idName: 'a',
          displayName: 'A',
          dataType: double,
        ),
        InputPortPrototype(
          idName: 'b',
          displayName: 'B',
          dataType: double,
        ),
        OutputPortPrototype(
          idName: 'result',
          displayName: 'Result',
          dataType: double,
        ),
      ],
      fields: [
        FieldPrototype(
          idName: 'operation',
          displayName: 'Operation',
          dataType: Operator,
          defaultData: Operator.add,
          visualizerBuilder: (data) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              data.toString().split('.').last,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          editorBuilder: (context, removeOverlay, data, setData) =>
              SegmentedButton<Operator>(
            segments: const [
              ButtonSegment(value: Operator.add, label: Text('Add')),
              ButtonSegment(value: Operator.subtract, label: Text('Subtract')),
              ButtonSegment(value: Operator.multiply, label: Text('Multiply')),
              ButtonSegment(value: Operator.divide, label: Text('Divide')),
            ],
            selected: {data as Operator},
            onSelectionChanged: (newSelection) {
              setData(newSelection.first, eventType: FieldEventType.submit);
              removeOverlay();
            },
            direction: Axis.horizontal,
          ),
        ),
      ],
      onExecute: (ports, fields) async {
        final a = ports['a']! as double;
        final b = ports['b']! as double;
        final op = fields['operation']! as Operator;

        switch (op) {
          case Operator.add:
            return {'result': a + b};
          case Operator.subtract:
            return {'result': a - b};
          case Operator.multiply:
            return {'result': a * b};
          case Operator.divide:
            return {'result': b == 0 ? 0 : a / b};
        }
      },
    ),
  );

  controller.registerNodePrototype(
    NodePrototype(
      idName: 'random',
      displayName: 'Random',
      description: 'Outputs a random number between 0 and 1.',
      color: Colors.purple,
      allowRecursion: false,
      ports: [
        OutputPortPrototype(
          idName: 'value',
          displayName: 'Value',
          dataType: double,
        ),
      ],
      onExecute: (ports, fields) async {
        return {'value': Random().nextDouble()};
      },
    ),
  );

  controller.registerNodePrototype(
    NodePrototype(
      idName: 'if',
      displayName: 'If',
      description: 'Executes a branch based on a condition.',
      color: Colors.green,
      allowRecursion: false,
      ports: [
        InputPortPrototype(
          idName: 'condition',
          displayName: 'Condition',
          dataType: bool,
        ),
        OutputPortPrototype(
          idName: 'trueBranch',
          displayName: 'True',
          dataType: dynamic,
        ),
        OutputPortPrototype(
          idName: 'falseBranch',
          displayName: 'False',
          dataType: dynamic,
        ),
      ],
      onExecute: (ports, fields) async {
        final condition = ports['condition']! as bool;
        return condition ? {'trueBranch': null} : {'falseBranch': null};
      },
    ),
  );

  controller.registerNodePrototype(
    NodePrototype(
      idName: 'comparator',
      displayName: 'Comparator',
      description: 'Compares two numbers based on a chosen comparator.',
      color: Colors.cyan,
      allowRecursion: false,
      ports: [
        InputPortPrototype(
          idName: 'a',
          displayName: 'A',
          dataType: double,
        ),
        InputPortPrototype(
          idName: 'b',
          displayName: 'B',
          dataType: double,
        ),
        OutputPortPrototype(
          idName: 'result',
          displayName: 'Result',
          dataType: bool,
        ),
      ],
      fields: [
        FieldPrototype(
          idName: 'comparator',
          displayName: 'Comparator',
          dataType: Comparator,
          defaultData: Comparator.equal,
          visualizerBuilder: (data) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              data.toString().split('.').last,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          editorBuilder: (context, removeOverlay, data, setData) =>
              SegmentedButton<Comparator>(
            segments: const [
              ButtonSegment(value: Comparator.equal, label: Text('==')),
              ButtonSegment(value: Comparator.notEqual, label: Text('!=')),
              ButtonSegment(value: Comparator.greater, label: Text('>')),
              ButtonSegment(value: Comparator.greaterEqual, label: Text('>=')),
              ButtonSegment(value: Comparator.less, label: Text('<')),
              ButtonSegment(value: Comparator.lessEqual, label: Text('<=')),
            ],
            selected: {data as Comparator},
            onSelectionChanged: (newSelection) {
              setData(newSelection.first, eventType: FieldEventType.submit);
              removeOverlay();
            },
            direction: Axis.horizontal,
          ),
        ),
      ],
      onExecute: (ports, fields) async {
        final a = ports['a']! as double;
        final b = ports['b']! as double;
        final comp = fields['comparator']! as Comparator;

        switch (comp) {
          case Comparator.equal:
            return {'result': a == b};
          case Comparator.notEqual:
            return {'result': a != b};
          case Comparator.greater:
            return {'result': a > b};
          case Comparator.greaterEqual:
            return {'result': a >= b};
          case Comparator.less:
            return {'result': a < b};
          case Comparator.lessEqual:
            return {'result': a <= b};
        }
      },
    ),
  );

  controller.registerNodePrototype(
    NodePrototype(
      idName: 'value',
      displayName: 'Value',
      description: 'Holds a constant double value.',
      color: Colors.orange,
      allowRecursion: false,
      ports: [
        OutputPortPrototype(
          idName: 'value',
          displayName: 'Value',
          dataType: double,
        ),
      ],
      fields: [
        FieldPrototype(
          idName: 'value',
          displayName: 'Value',
          dataType: double,
          defaultData: 0.0,
          visualizerBuilder: (data) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              data.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          editorBuilder: (context, removeOverlay, data, setData) =>
              ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: TextFormField(
              initialValue: data.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setData(
                  double.tryParse(value) ?? 0.0,
                  eventType: FieldEventType.change,
                );
              },
              onFieldSubmitted: (value) {
                setData(
                  double.tryParse(value) ?? 0.0,
                  eventType: FieldEventType.submit,
                );
                removeOverlay();
              },
            ),
          ),
        ),
      ],
      onExecute: (ports, fields) async {
        return {'value': fields['value']!};
      },
    ),
  );

  controller.registerNodePrototype(
    NodePrototype(
      idName: 'output',
      displayName: 'Output',
      description: 'Outputs a value.',
      color: Colors.red,
      allowRecursion: false,
      ports: [
        InputPortPrototype(
          idName: 'value',
          displayName: 'Value',
          dataType: dynamic,
        ),
      ],
      onExecute: (ports, fields) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Output'),
              content: Text('Output: ${ports['value']}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return {};
      },
    ),
  );

  controller.registerNodePrototype(
    NodePrototype(
      idName: 'round',
      displayName: 'Round',
      description: 'Rounds a number to a specified number of decimals.',
      color: Colors.blue,
      allowRecursion: false,
      ports: [
        InputPortPrototype(
          idName: 'value',
          displayName: 'Value',
          dataType: double,
        ),
        OutputPortPrototype(
          idName: 'rounded',
          displayName: 'Rounded',
          dataType: int,
        ),
      ],
      fields: [
        FieldPrototype(
          idName: 'decimals',
          displayName: 'Decimals',
          dataType: int,
          defaultData: 2,
          visualizerBuilder: (data) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              data.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          editorBuilder: (context, removeOverlay, data, setData) =>
              ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: TextFormField(
              initialValue: data.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setData(
                  int.tryParse(value) ?? 0,
                  eventType: FieldEventType.change,
                );
              },
              onFieldSubmitted: (value) {
                setData(
                  int.tryParse(value) ?? 0,
                  eventType: FieldEventType.submit,
                );
                removeOverlay();
              },
            ),
          ),
        ),
      ],
      onExecute: (ports, fields) async {
        final double value = ports['value']! as double;
        final int decimals = fields['decimals']! as int;

        return {'rounded': double.parse(value.toStringAsFixed(decimals))};
      },
    ),
  );
}
