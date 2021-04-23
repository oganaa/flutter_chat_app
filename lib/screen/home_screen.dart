import 'package:flutter/material.dart';
import 'package:gn_flutter/model/message.dart';
import 'package:gn_flutter/model/user.dart';
// import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Message> messages = [];
  List<User> users = [];
  User  me;
  IO.Socket socket;
  String msg='';
  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    connect();
    // TODO: implement initState
    super.initState();
  }
  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }
  void connect() async {
    // Configure socket transports must be sepecified
    socket = await IO.io('http://localhost:8000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    Map<String,dynamic> roomData = {
      "name":"Ganaa",
      "room":"test0423a",
      "typingStatus":false
    };
    Map<String,dynamic> user = {
      "name":"Ganaa",
      "room":"test0323a",
      "email":"gana@gmail.com"
    };
    String room = "test0429a";
    socket.connect();
    socket.onConnect((data) => print("Connected"));
     socket.emit('createUser',roomData);
     // socket.emit('joinRoom',roomData);
     socket.on('userInfo',(user)=>{

      setState(() {
        me = new User.fromJson(user);
        print(me);
        users.add(User.fromJson(user));

        socket.emit('joinRoom',me);
      }),

    });



    // socket.on('updateUsers')
     socket.on('newMessage',(message)=>{
      // parsed = jsonDecode(message).cast<Map<String, dynamic>>();
       print(message),

     setState(() {
     messages.add(Message.fromJson(message));
     }),


    });
// add this line



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, position) {
                return Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(users[position].name, style: TextStyle(fontSize: 22.0),),
                  ),
                );
              },
            ),
          ),
          Container( color: Colors.black12,

            height: 600,
          child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx,int i){
            return Container(

              decoration: BoxDecoration(

                border: Border(bottom: BorderSide(width: 1,color: Colors.grey)),
              ),
              child: ListTile(
                title: Text('${messages[i].name}'),
                subtitle: Text(messages[i].time),
                trailing: Text(messages[i].text),
              ),
            );
          }),),
          TextFormField(
            controller: _controller,
          ),
          FlatButton(
              color: Colors.black,
              onPressed:(){
            print(_controller.text);
            sendMessage(_controller.text);
            _controller.text='';
          }, child: Text("send",style: TextStyle(color: Colors.white),))
        ],
      ),


    );
  }
  void sendMessage(String text){
    Map<String,dynamic> mes = {
      "id":"${me.id}",
      "msg":"${text}"
    };
    socket.emit('createMessage',mes);

  }
}
