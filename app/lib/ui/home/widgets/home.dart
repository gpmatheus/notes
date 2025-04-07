
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/model/note/note.dart';
import 'package:notes/ui/auth/profile/profile_viewmodel.dart';
import 'package:notes/ui/core/app_logo.dart';
import 'package:notes/ui/auth/profile/widgets/drawer.dart';
import 'package:notes/ui/home/home_viewmodel.dart';
import 'package:notes/ui/core/loading_screen.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {

  Home({
    super.key,
    required HomeViewmodel homeViewModel,
  }) :
    _homeViewModel = homeViewModel;

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');
  final HomeViewmodel _homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(), 
              icon: const Icon(Icons.menu_rounded),
            );
          }
        ),
        title: const AppLogo(),
        actions: [
          IconButton(
            onPressed: () { 
              _homeViewModel.navigateToNoteCreation(context);
            },
            icon: const Icon(Icons.add_rounded)
          )
        ],
      ),
      drawer: AppDrawer(
        viewmodel: ProfileViewmodel(
          userRepository: context.read(),
        ),
      ),
      body: ListenableBuilder(
        listenable: _homeViewModel,
        builder: (context, _) {
          return LoadingScreen(
            loading: _homeViewModel.loading,
            screen: (_homeViewModel.notes == null || _homeViewModel.notes!.isEmpty)
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No content',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _homeViewModel.navigateToNoteCreation(context);
                      }, 
                      child: const Text('Create a note')
                    )
                  ],
                ),
              )
              : GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(8.0),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    for (Note nt in _homeViewModel.notes!)
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