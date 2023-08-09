import 'package:chat_app/widgets/chats/messages_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration.zero).then((_) async {
          final user = await FirebaseAuth.instance.currentUser;
          return user;
        }),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = streamSnapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) => Container(
                    padding: const EdgeInsets.all(8),
                    child: MessagesBubble(
                      chatDocs[index]['text'],
                      chatDocs[index]['userId'] == futureSnapshot.data!.uid,
                      chatDocs[index]['username'],
                      chatDocs[index]['user_image'],
                      key: ValueKey(chatDocs[index].id),
                    ),
                  ),
                  itemCount: chatDocs.length,
                );
              });
        });
  }
}
