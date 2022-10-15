import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:money_search/data/MoneyController.dart';
import 'package:money_search/data/cache.dart';
import 'package:money_search/data/internet.dart';
import 'package:money_search/data/internetProvider.dart';
import 'package:money_search/data/string.dart';
import 'package:money_search/model/listPersonModel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  /// instancia da lista para receber as informações
  List<ListPersonModel> listPessoas = [];
  bool internet = true;

  @override
  initState() {
    /// chamando a função de verifcação de internet
    checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// verificando internet atraves do package Connectivity utilizando o Provider prara a gerenca do estado da aplicação
    /// tornando a verificação de internet em tempo real
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;

    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de pessoas'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          actions: [
            Visibility(
                visible: isOnline == false,
                child: Icon(Icons.network_cell_outlined))
          ],
        ),
        body: isOnline == false
            ? construtorLista()
            : FutureBuilder<List<ListPersonModel>>(
                future: MoneyController().getListPerson(),
                builder: (context, snapshot) {
                  /// validação de carregamento da conexão
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /// validação de erro
                  if (snapshot.error == true) {
                    return const SizedBox(
                      height: 300,
                      child: Text("Vazio"),
                    );
                  }
                  //  List<ListPersonModel> model = [];
                  /// passando informações para o modelo criado
                  listPessoas = snapshot.data ?? listPessoas;
                  /// removendo a pessoa com id 64
                  // model.removeWhere((pessoa) => pessoa.id == "64");
                  /// adicionando um item de pessoa na lista
                  // model.add(ListPersonModel(
                  //   avatar:
                  //       "https://pbs.twimg.com/profile_images/420370594/IMG_3253_400x400.JPG",
                  //   id: "99",
                  //   name: "Arnaldo",
                  // ));
                  /// ordenando pessoas pelo nome
                  // model.sort(
                  //   (a, b) => a.name!.compareTo(b.name!),
                  // );
                  /// removendo avatar da pessoa 9
                  // model.forEach((pessoa) {
                  //   if (pessoa.id == "9") {
                  //     pessoa.avatar = null;
                  //   }
                  // });
                  /// salvando lista vinda da API no cache
                  salvarDados(listPessoas);
                  return construtorLista();
                }));
  }

  /// função que retorna a listagem na tela
  construtorLista() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
          itemCount: listPessoas.length,
          itemBuilder: (context, index) {
            ListPersonModel item = listPessoas[index];
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: item.avatar ?? "",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              // Image.network(
              //     errorBuilder: (context, error, stackTrace) {
              //   return Container();
              // }, item.avatar ?? ""),

              title: Text(item.name ?? ""),
              trailing: Text(item.id ?? ""),
            );
          }),
    );
  }

  salvarDados(List<ListPersonModel> list) async {
    try {
      /// salvando a lista na chave string "pessoas"
      await SecureStorage().writeSecureData(pessoas, json.encode(list));
    } catch (e) {
      print("erro ao salvar lista");
    }
  }

  verificaMemoria() async {
    /// recebe as informações do cache da chave string "pessoas"
    var result = await SecureStorage().readSecureData(pessoas);

    if (result == null) return;
    print(listPessoas.toList());
    /// montando a lista através das informações da String "pessoas"
    List<ListPersonModel> lista = (json.decode(result) as List)
        .map((e) => ListPersonModel.fromJson(e))
        .toList();
    /// adicionando lista vinda da memoria pra lista de exibição
    listPessoas.addAll(lista);
    /// atualizando a tela
    setState(() {});
  }

  /// função que atualiza a tela ao puxar para baixo
  Future<Null> refresh() async {
    listPessoas.clear();
    await checkConnection();
    setState(() {});
  }

  /// função para verificar a disponibilidade de internet
  checkConnection() async {
    internet = await CheckInternet().checkConnection();
    /// se não tem internet verificar os dados da memória
    if (internet == false) {
      verificaMemoria();
      setState(() {});
    }
    setState(() {});
  }
}
