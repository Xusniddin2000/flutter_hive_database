import 'package:flutter/material.dart';import '../db/db_service.dart';class HomePage extends StatefulWidget {  const HomePage({Key? key}) : super(key: key);  @override  State<HomePage> createState() => _HomePageState();}class _HomePageState extends State<HomePage> {  final TextEditingController _nameController = TextEditingController();  final TextEditingController _lastNameController = TextEditingController();  final  TextEditingController _updateController=TextEditingController();  GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();  @override  Widget build(BuildContext context) {    return Scaffold(      appBar: AppBar(        title: Text("Flutter"),      ),      body: Padding(        padding: const EdgeInsets.all(15.0),        child: Column(children: [          Expanded(            flex: 7,            child: SafeArea(child: Column(              children: [                TextFormField(                  showCursor: false,                  key: _key,                  autocorrect: true,                  autofocus: true,                  controller: _nameController,                  keyboardType: TextInputType.text,                  validator: (v) {                    if(v!.isEmpty){                      return "Iltimos bo'sh qoldirmang";                    }/*else if(!findIsFake(v)){                      return "Xaqiqiy email kiriting:";                    }else{                      return null;                    }*/                  },                  decoration: InputDecoration(                      border: OutlineInputBorder(),                      suffixIcon: Icon(Icons.email),                      hintText: "Enter Name", labelText: "Name"),                ),                SizedBox(                  height: 15,                ),                TextFormField(                  keyboardType: TextInputType.text,                  autofocus: true,                  validator: (v){                  },                  controller: _lastNameController,                  decoration: InputDecoration(                      border: OutlineInputBorder(),                      hintText: " Enter  LastName", labelText: "Last Name"),                ),              ],            )),          ),          SizedBox(height: 25,),          Text("DataBase ma'lumotlari ",style: TextStyle(color: Colors.black,fontSize: 25,),),          Expanded(            flex: 7,            child: FutureBuilder(                future: DBService().getDataMobile(),                builder: (context, AsyncSnapshot snapshot) {                  if (!snapshot.hasData) {                    return SizedBox.shrink();                  } else if (snapshot.data is String) {                    return Center(                      child: Text(snapshot.data),                    );                  } else {                    return SizedBox(                        height: 300,                        width: double.infinity,                        child: ListView.builder(                            itemBuilder: (context, index) {                              return ListTile(                                onLongPress: (){                                  showDialog(                                      context: context,                                      builder: (context)=>AlertDialog(                                        title: Text("${(snapshot.data as List)[index]} o'chirilsinmi? "),                                        actions: [                                          ElevatedButton(                                              onPressed: (){                                                Navigator.pop(context);                                              },                                              child: Text("Orqaga") ),                                          ElevatedButton(onPressed: () async{                                            await DBService().deleteItem(index);                                            setState(() {                                            });                                            Future.delayed(Duration.zero).then((value) => {                                              Navigator.pop(context)                                            });                                          },                                              child: const Text("O'chirish"))                                        ],                                      ));                                },                                onTap: (){                                  showDialog(                                      context: context,                                      builder: (context)=>AlertDialog(                                        title: Text("${(snapshot.data as List)[index]} o'zgartirilsinmi? "),                                        content: TextFormField(                                          controller: _updateController,                                          decoration: InputDecoration(                                            hintText: "O'zgartirish",                                          ),                                        ),                                        actions: [                                          ElevatedButton(                                              onPressed: (){                                                Navigator.pop(context);                                              },                                              child: Text("Orqaga") ),                                          ElevatedButton(onPressed: () async{                                            await DBService().updateItem(index, _updateController.text);                                            _updateController.clear();                                            setState(() {});                                            Future.delayed(Duration.zero).then((value) => {                                              Navigator.pop(context)                                            });                                          },                                              child: const Text("O'zgartirish"))                                        ],                                      ));                                },                                title: Container(                                  height: 65,                                  decoration: BoxDecoration(                                      shape: BoxShape.rectangle ,                                      border: Border.all(width: 2,color: Colors.blueAccent),                                      borderRadius: BorderRadius.circular(20)),                                  child:                                  Center(child:                                  Row(                                    children: [                                      Icon(Icons.email,size: 25,),                                      SizedBox(width: 60,),                                      Text(snapshot.data[index], style: TextStyle(color: Colors.blueAccent)),                                    ],                                  )),                                ),                              );                            },                            itemCount: (snapshot.data as List).length));                  }                }),          )        ]),      ),      floatingActionButton: FloatingActionButton.extended(          onPressed: () async {            if (_key.currentState!.validate()) {              await DBService().openBox();              await DBService().writeToDB(_nameController.text);              await DBService().writeToDB(_lastNameController.text);              _nameController.clear();              _lastNameController.clear();              setState(() {});            }          },          label: Text("Saqlash")),    );  }  bool  findIsFake( String v){    String result="";    bool isStarted=false;    bool isFakeStarted=false;    for( int  i=0;i<v.length;i++){      if( v[0]== "@"){        isFakeStarted=true;      }      if(v[i]=='@'){        isStarted=true;      }      if(isStarted==true){        result+=v[i];      }else{        continue;      }    }    return (result =="@gmail.com" && !isFakeStarted);  }}