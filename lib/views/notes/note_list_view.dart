import 'package:flutter/material.dart';

import '../../services/cloud/cloud_note.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/wallpapertip_black-pattern-wallpaper_118104.jpg'),
              fit: BoxFit.fill)),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes.elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  onTap: () {
                    onTap(note);
                  },
                  onLongPress: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(note);
                    }
                  },
                  title: Text(
                    note.text,
                    softWrap: true,
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8)),
    );
  }
}
