import 'package:flutter/material.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Мои заметки')),
        body: NotesWidget(),
      ),
    );
  }
}

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> _notes = [];
  int _editingIndex = -1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveNote() {
    String inputValue = _controller.text;

    if (inputValue.isEmpty) return;

    setState(() {
      if (_editingIndex == -1) {
        _notes.add(inputValue);
      } else {
        _notes[_editingIndex] = inputValue;
        _editingIndex = -1;
      }
    });

    _controller.clear();
  }

  void _editNote(int index) {
    setState(() {
      _editingIndex = index;
      _controller.text = _notes[index];
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = -1;
        _controller.clear();
      } else if (_editingIndex > index) {
        _editingIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: "Введите текст заметки"),
        ),
        ElevatedButton(
          onPressed: _saveNote,
          child: Text(_editingIndex == -1 ? 'Сохранить' : 'Обновить'),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_notes[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editNote(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteNote(index),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}