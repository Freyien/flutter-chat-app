import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [];

  bool isWritting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Fe', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text('Fernando Luis', style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [

            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
              )
            ),

            Divider(height: 1),

            //TODO: TextBox
            Container(
              color: Colors.white,
              child: _inputChat(),
            )

          ],
        ),
      )
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String value) {
                  setState(() {
                    isWritting = (value.trim().length) > 0 ? true : false;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ),

            // Send Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS 
                ? CupertinoButton(
                  child: Text('Enviar'), 
                  onPressed: isWritting ? 
                    () => _handleSubmit(_textController.text.trim()) 
                    : null
                )
                : Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: IconTheme(
                    data: IconThemeData(
                      color: Colors.blue[400]
                    ),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.send), 
                      onPressed: isWritting ? 
                        () => _handleSubmit(_textController.text.trim()) 
                        : null
                    ),
                  ),
                ),
            )

          ],
        ),
      )
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0)
      return;

    print(text);
    _focusNode.requestFocus();
    _textController.clear();

    final _newMessage = new ChatMessage(
      uid: '123',
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
    );

    _messages.insert(0, _newMessage);

    _newMessage.animationController.forward();

    setState(() {
      isWritting = false;
    });
  }

  @override
  void dispose() {
    // TODO: Socket Off
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}