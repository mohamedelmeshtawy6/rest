import 'package:flutter/material.dart';

class ShowNote extends StatefulWidget {
    static const String routeName = 'noteshow page';

  final dynamic notedata;
  const ShowNote({super.key, this.notedata});

  @override
  State<ShowNote> createState() => _ShowNoteState();
}

class _ShowNoteState extends State<ShowNote> {
 late String title;
 late String content;
 @override
  void initState() {
  
    super.initState();
    title=widget.notedata['note_title'];
    content=widget.notedata['note_content'];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Colors.white,
      child: Column(
        children: [
         const SizedBox(height: 50,),
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              'images/backGroundLog.jpg',
              fit: BoxFit.fill,
            ),
          ),
          Text(title,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,)),
          Text(content, style: const TextStyle(
            color: Color.fromARGB(255, 31, 146, 79),
            fontSize: 30,
            ))
        ],
      ),
    ));
  }
}
