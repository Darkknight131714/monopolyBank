import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'input.dart';
import 'package:flutter/services.dart';
import 'transaction.dart';
List<Color> colors = [Colors.blue, Colors.red, Colors.orange, Colors.green,Colors.pink,Colors.purpleAccent];
int prev=-1;
int curr=-1;
List<Widget> transaction=[];
class Bank extends StatefulWidget {
  final List<Player> list;
  final int onPass;
  Bank({required this.list,required this.onPass});
  @override
  _BankState createState() => _BankState(list: list);
}

class _BankState extends State<Bank> {
  final List<Player> list;
  _BankState({required this.list});
  GlobalKey gridKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: GridView.count(
          physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
          children: List.generate(list.length, (index){
            return Boxes(name: list[index].name, color: colors[index], money: list[index].money,list: list,index: index,onPress: (){
                    setState(() {
                      list[index].money=list[index].money+widget.onPass;
                    });
                },
                onAdd: (int add){
                    setState(() {
                      list[index].money+=add;
                    });
                },
                transfer: (int trans){
                    setState(() {
                      list[prev].money-= trans;
                      list[curr].money+= trans;
                      curr=-1;
                      prev=-1;
                    });
                },
            );
          }),
        )
      ),
    );
  }
}
class Boxes extends StatefulWidget {
  final List<Player> list;
  final int index;
  final String name;
  final int money;
  final Color color;
  final Function onPress;
  final Function onAdd;
  final Function transfer;
  Boxes({required this.name,required this.transfer,required this.color,required this.money,required this.list,required this.index,required this.onPress,required this.onAdd});

  @override
  State<Boxes> createState() => _BoxesState();
}

class _BoxesState extends State<Boxes> {
  final messageTextController = TextEditingController();
  int add=0;
  int trans=0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onPanStart: (DragStartDetails details){
          prev=widget.index;
          HapticFeedback.vibrate();
          print("PRev");
          print(prev);
        },
        onPanUpdate: (DragUpdateDetails details){
          double x=details.globalPosition.dy;
          double y=details.globalPosition.dx;
          int rowInd=(x/200).floor();
          int colInd=(y/200).floor();
          curr=rowInd*2+colInd;
        },
        onDoubleTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return TransactionHistory(transaction: transaction,);
          }
          )
          );
        },
        onPanEnd: (DragEndDetails details){
          print("Curr");
          print(curr);
          if(curr>=widget.list.length||prev>=widget.list.length){
            prev=-1;
            curr=-1;
          }
          else{
            HapticFeedback.vibrate();
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${widget.list[prev].name} to ${widget.list[curr].name}"),
                      Text("--------------"),
                      SizedBox(height: 15,),
                      Text("Enter Money to Transfer"),
                      TextField(
                        controller: messageTextController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          trans=int.parse(value);
                        },
                      ),
                      TextButton(onPressed: (){
                        transaction.add(Text('${widget.list[prev].name} to ${widget.list[curr].name}: ${trans}'));
                        widget.transfer(trans);
                        trans=0;
                        messageTextController.clear();
                        Navigator.of(context).pop();
                      }, child: Text("Done"))
                    ],
                  ),
                ));
          }

        },
        onTap: (){
          HapticFeedback.vibrate();
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Enter Money to Add"),
                    TextField(
                      controller: messageTextController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        add=int.parse(value);
                      },
                    ),
                    TextButton(onPressed: (){
                      widget.onAdd(add);
                      if(add>=0){
                        transaction.add(Text('Added to ${widget.list[widget.index].name}: ${add}'));
                      }
                      else{
                        transaction.add(Text('Deducted from ${widget.list[widget.index].name}: ${-1*add}'));
                      }
                      messageTextController.clear();
                      Navigator.of(context).pop();
                    }, child: Text("Done"))
                  ],
                ),
                actions: <Widget>[
                  TextButton(onPressed: (){
                    widget.onPress();
                    transaction.add(Text('${widget.list[widget.index].name} Passed Go'));
                    Navigator.of(context).pop();
                    }
                  , child: Text("Pass Go"))
                ],
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.name),
              Text(widget.money.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
            ],
          ),
        ),
      ),
    );
  }
}

//Navigator.of(context).pop();