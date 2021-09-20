import 'package:flutter/material.dart';
import 'bank.dart';
class Player{
  final String name;
  int money;
  Player({required this.name,required this.money});
}
class Input extends StatefulWidget {
  @override
  _InputState createState() => _InputState();
}
class _InputState extends State<Input> {
  final messageTextController = TextEditingController();
  int onPass=2000,i=0;
  String name='';
  int balance=0;
  List<Player> list=[];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("On Pass: "),
                Flexible(
                  child: Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        onPass=int.parse(value);
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 50,),
            Text("Player ${i+1} info"),
            Row(
              children: [
                Text("Player Name: "),
                Flexible(
                  child: TextField(
                    controller: messageTextController,
                    keyboardType: TextInputType.name,
                    onChanged: (value){
                      name=value;
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text("Player Balance: "),
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value){
                      balance=int.parse(value);
                    },
                  ),
                )
              ],
            ),
            TextButton(onPressed: (){
              setState(() {
                messageTextController.clear();
                Player player=new Player(name: name,money: balance);
                list.insert(i, player);
                if(i<5)
                {
                  print(list[i].name);
                  i++;
                }
              });
            }, child: Text("Next")),
            TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Bank(list: list,onPass: onPass,);
                    }
                    ));
            }, child: Text("Ready to Play"))
          ],
        ),
      ),
    );
  }
}

