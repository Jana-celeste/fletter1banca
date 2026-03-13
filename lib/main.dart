import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const BancaApp());
}

class BancaApp extends StatelessWidget {
  const BancaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banca de Jornal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Produto {
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;

  Produto({
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
  });
}

class ItemCarrinho {
  final Produto produto;
  int quantidade;

  ItemCarrinho({
    required this.produto,
    this.quantidade = 1,
  });
}

List<ItemCarrinho> carrinho = [];

int totalItensCarrinho() {
  int total = 0;
  for (var item in carrinho) {
    total += item.quantidade;
  }
  return total;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String busca = "";

  final List<Produto> produtos = [
    Produto(nome: "Jornal Diário", descricao: "Notícias atualizadas do dia", preco: 5.00, imagem: "https://picsum.photos/400?1"),
    Produto(nome: "Revista Tecnologia", descricao: "Inovação e tecnologia", preco: 12.90, imagem: "https://picsum.photos/400?2"),
    Produto(nome: "Revista Esportes", descricao: "Tudo sobre esportes", preco: 10.50, imagem: "https://picsum.photos/400?3"),
    Produto(nome: "Revista Moda", descricao: "Tendências e estilo", preco: 11.90, imagem: "https://picsum.photos/400?4"),
    Produto(nome: "Revista Saúde", descricao: "Vida saudável", preco: 9.90, imagem: "https://picsum.photos/400?5"),
    Produto(nome: "Revista Carros", descricao: "Mundo automotivo", preco: 14.50, imagem: "https://picsum.photos/400?6"),
    Produto(nome: "Revista Games", descricao: "Lançamentos de jogos", preco: 13.90, imagem: "https://picsum.photos/400?7"),
    Produto(nome: "Revista Cinema", descricao: "Filmes e séries", preco: 10.90, imagem: "https://picsum.photos/400?8"),
    Produto(nome: "Revista Negócios", descricao: "Empreendedorismo", preco: 15.00, imagem: "https://picsum.photos/400?9"),
    Produto(nome: "Revista Educação", descricao: "Conteúdo educacional", preco: 8.50, imagem: "https://picsum.photos/400?10"),
    Produto(nome: "Revista Viagem", descricao: "Destinos incríveis", preco: 16.90, imagem: "https://picsum.photos/400?11"),
    Produto(nome: "Revista Culinária", descricao: "Receitas deliciosas", preco: 9.50, imagem: "https://picsum.photos/400?12"),
    Produto(nome: "Revista Ciência", descricao: "Descobertas científicas", preco: 12.00, imagem: "https://picsum.photos/400?13"),
    Produto(nome: "Revista HQ", descricao: "Histórias em quadrinhos", preco: 7.90, imagem: "https://picsum.photos/400?14"),
    Produto(nome: "Revista Infantil", descricao: "Diversão para crianças", preco: 6.90, imagem: "https://picsum.photos/400?15"),
    Produto(nome: "Revista Música", descricao: "Novidades musicais", preco: 11.50, imagem: "https://picsum.photos/400?16"),
    Produto(nome: "Revista Fotografia", descricao: "Técnicas e inspiração", preco: 13.00, imagem: "https://picsum.photos/400?17"),
    Produto(nome: "Revista Arquitetura", descricao: "Design moderno", preco: 17.90, imagem: "https://picsum.photos/400?18"),
  ];

  @override
  Widget build(BuildContext context) {

    final listaFiltrada = produtos.where((produto) {
      return produto.nome.toLowerCase().contains(busca.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Banca de Jornal"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart, size: 28),
                if (carrinho.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${totalItensCarrinho()}',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarrinhoPage()),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Buscar produto...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  busca = value;
                });
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: listaFiltrada.length,
              itemBuilder: (context, index) {

                final produto = listaFiltrada[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(produto.imagem, width: 60),
                    title: Text(produto.nome),
                    subtitle: Text("R\$ ${produto.preco.toStringAsFixed(2)}"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhePage(
                            produto: produto,
                            atualizarHome: (){
                              setState(() {});
                            },
                          ),
                        ),
                      );

                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetalhePage extends StatelessWidget {

  final Produto produto;
  final VoidCallback atualizarHome;

  const DetalhePage({
    super.key,
    required this.produto,
    required this.atualizarHome,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(produto.nome)),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                produto.imagem,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              produto.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(produto.descricao),

            const SizedBox(height: 20),

            Text(
              "Preço: R\$ ${produto.preco.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  final index = carrinho.indexWhere(
                    (item) => item.produto.nome == produto.nome,
                  );

                  if (index >= 0) {
                    carrinho[index].quantidade++;
                  } else {
                    carrinho.add(ItemCarrinho(produto: produto));
                  }

                  atualizarHome(); // atualiza contador imediatamente

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Produto adicionado ao carrinho"),
                    ),
                  );

                },
                child: const Text("Adicionar ao Carrinho"),
              ),
            )

          ],
        ),
      ),
    );
  }
}

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({super.key});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {

  double total() {
    double t = 0;
    for (var item in carrinho) {
      t += item.produto.preco * item.quantidade;
    }
    return t;
  }

  Future<void> enviarWhatsApp() async {

    String mensagem = "🛒 *Pedido*\n\n";

    for (var item in carrinho) {
      mensagem +=
          "${item.produto.nome} x${item.quantidade} - R\$ ${(item.produto.preco * item.quantidade).toStringAsFixed(2)}\n";
    }

    mensagem += "\n💰 Total: R\$ ${total().toStringAsFixed(2)}";

    final url = Uri.parse(
        "https://wa.me/5511959100708?text=${Uri.encodeComponent(mensagem)}");

    await launchUrl(url, mode: LaunchMode.externalApplication);

    carrinho.clear();

    Navigator.pop(context);
  }

  void resumoPedido() {

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(
          title: const Text("Resumo do Pedido"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              for (var item in carrinho)
                ListTile(
                  title: Text(item.produto.nome),
                  trailing: Text("x${item.quantidade}"),
                  subtitle: Text(
                      "R\$ ${(item.produto.preco * item.quantidade).toStringAsFixed(2)}"),
                ),

              const Divider(),

              Text(
                "Total: R\$ ${total().toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                enviarWhatsApp();
              },
              child: const Text("Enviar Pedido"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho")),

      body: carrinho.isEmpty
          ? const Center(child: Text("Carrinho vazio"))

          : Column(
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: carrinho.length,
                    itemBuilder: (_, index) {

                      final item = carrinho[index];

                      return ListTile(
                        leading: Image.network(item.produto.imagem, width: 50),

                        title: Text(item.produto.nome),

                        subtitle: Text(
                            "R\$ ${(item.produto.preco * item.quantidade).toStringAsFixed(2)}"),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (item.quantidade > 1) {
                                    item.quantidade--;
                                  } else {
                                    carrinho.removeAt(index);
                                  }
                                });
                              },
                            ),

                            Text("${item.quantidade}"),

                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  item.quantidade++;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [

                      Text(
                        "Total: R\$ ${total().toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: resumoPedido,
                          child: const Text("Finalizar Pedido no WhatsApp"),
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
    );
  }
}
