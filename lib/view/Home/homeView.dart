import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/data/cache.dart';
import 'package:money_search/data/internet.dart';
import 'package:money_search/data/string.dart';
import 'package:money_search/model/MoneyModel.dart';
import 'package:money_search/model/listPersonModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

/// instancia do modelo para receber as informações
List<ListPersonModel> model = [];

class _HomeViewState extends State<HomeView> {
  checkConnection() async {
    internet = await CheckInternet().checkConnection();
    if (internet == false) {
      readMemory();
      setState(() {

      });
    }
    setState(() {});
  }

  bool internet = true;

  @override
  initState() {
    checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de pessoas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          actions: [
            Visibility(
                visible: internet == false,
                child: Icon(Icons.network_cell_outlined))
          ],
        ),
        body: internet == false
            ? ListView.builder(
                itemCount: model.length,
                itemBuilder: (context, index) {
                  ListPersonModel item = model[index];
                  return ListTile(
                    leading: Image.network(
                        errorBuilder: (context, error, stackTrace) {
                      return Container();
                    }, item.avatar ?? ""),
                    title: Text(item.name ?? ""),
                    trailing: Text(item.id ?? ""),
                  );
                })
            : FutureBuilder<List<ListPersonModel>>(
                future: MoneyController().getListPerson(),
                builder: (context, snapshot) {
                  /// validação de carregamento da conexão
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// validação de erro
                  if (snapshot.error == true) {
                    return SizedBox(
                      height: 300,
                      child: Text("Vazio"),
                    );
                  }
                  //  List<ListPersonModel> model = [];
                  /// passando informações para o modelo criado
                  model = snapshot.data ?? model;

                  // model.removeWhere((pessoa) => pessoa.id == "64");
                  // model.add(ListPersonModel(
                  //   avatar:
                  //       "https://pbs.twimg.com/profile_images/420370594/IMG_3253_400x400.JPG",
                  //   id: "99",
                  //   name: "Arnaldo",
                  // ));
                  // model.sort(
                  //   (a, b) => a.name!.compareTo(b.name!),
                  // );
                  // model.forEach((pessoa) {
                  //   if (pessoa.id == "9") {
                  //     pessoa.avatar = null;
                  //   }
                  // });
                  verifyData(model);

                  return ListView.builder(
                      itemCount: model.length,
                      itemBuilder: (context, index) {
                        ListPersonModel item = model[index];
                        return ListTile(
                          leading: Image.network(
                              errorBuilder: (context, error, stackTrace) {
                            return Container();
                          }, item.avatar ?? ""),
                          title: Text(item.name ?? ""),
                          trailing: Text(item.id ?? ""),
                        );
                      });
                }));
  }

  verifyData(List<ListPersonModel> list) async {
    try {
      await SecureStorage()
          .writeSecureData(pessoas, json.encode(list));
    } catch (e) {
      print("erro ao salvar lista");
    }
  }

  readMemory() async {
    var result = await SecureStorage().readSecureData(pessoas);
    if (result == null) return;
    print(model.toList());
    List<ListPersonModel> lista = (json.decode(result) as List)
        .map((e) => ListPersonModel.fromJson(e))
        .toList();
    model.addAll(lista);
    setState(() {});
  }

  Future<Null> refresh() async {
    setState(() {});
  }
}
