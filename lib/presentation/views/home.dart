
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/presentation/viewmodels/home_viewmodel.dart';
import 'package:notes/presentation/widgets/loading_screen.dart';


class Home extends StatelessWidget {

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');
  final HomeViewmodel _homeViewModel = HomeViewmodel();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () { 
              _homeViewModel.navigateToNoteCreation(context);
            },
            icon: const Icon(Icons.add_rounded)
          )
        ],
      ),
      body: ValueListenableBuilder<HomeFields>(
        valueListenable: _homeViewModel.fields,
        builder: (context2, fields, child) {
          final bool loading = fields.loading;
          final List<Note>? notes = fields.notes;
          return LoadingScreen(
            loading: loading,
            screen: (notes == null || notes.isEmpty)
              ? const Center(
                  child: Text('No content'),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(8.0),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    for (Note nt in notes)
                      _getCard(context, nt)
                    ]
                )
          );
        }
      )
    );
  }

  Widget _getCard(BuildContext context, Note nt) {
    return GestureDetector(
      onTap: () { 
        _homeViewModel.navigateToNoteDetails(context, nt.id);
      },
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 80.0,
                child: Center(
                  child: Text(
                    nt.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(_dateFormat.format(nt.createdAt))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  
}