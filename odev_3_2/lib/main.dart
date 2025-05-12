import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController tf = TextEditingController();
  List<String> kelimeler = [];
  Color seciliRenk = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: SizedBox(
                    width: 200,
                    height: 45,
                    child: TextField(
                      controller: tf,
                      decoration: InputDecoration(
                        labelText: "Kelime giriniz: ",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                DropdownButton<Color>(
                  items: [
                    DropdownMenuItem(
                      child: Text("Mavi"),
                      value: Colors.blue,
                    ),
                    DropdownMenuItem(
                      child: Text("Kırmızı"),
                      value: Colors.red,
                    ),
                    DropdownMenuItem(
                      child: Text("Yeşil"),
                      value: Colors.green,
                    ),
                    DropdownMenuItem(
                      child: Text("Sarı"),
                      value: Colors.yellow,
                    ),
                    DropdownMenuItem(
                      child: Text("Mor"),
                      value: Colors.purple,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      seciliRenk = value!;
                    });
                  },
                  hint: Text("Renkler"),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    kelimeler.add(tf.text);
                    tf.clear();
                  });
                },
                child: Text("TIKLA"),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: kelimeler.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(kelimeler[index]),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return Container(
                          color: seciliRenk,
                          margin: EdgeInsets.all(5),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
