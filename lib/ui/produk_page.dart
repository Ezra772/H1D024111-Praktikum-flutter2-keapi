import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/helper/api_exception.dart';
import 'package:tokokita/helper/user_info.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  bool _isLoading = false;
  String _message = "";
  List<Produk> _listProduk = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    setState(() {
      _isLoading = true;
      _message = "";
    });
    try {
      final produks = await ProdukBloc.getProduks();
      setState(() {
        _listProduk = produks;
        _message = "Tidak ada data produk";
      });
    } on ApiException catch (e) {
      setState(() {
        _message = e.message;
      });
    } catch (_) {
      setState(() {
        _message = "Gagal memuat produk, cek koneksi ke server";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('List Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                );
                _getData();
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await UserInfo().logout();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            )
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : _listProduk.isEmpty
              ? Center(
                  child: Text(_message),
                )
              : RefreshIndicator(
                  color: Colors.blue,
                  onRefresh: _getData,
                  child: ListView.builder(
                    itemCount: _listProduk.length,
                    itemBuilder: (context, index) {
                      final produk = _listProduk[index];
                      return ItemProduk(
                        produk: produk,
                        onRefresh: _getData,
                      );
                    },
                  ),
                ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback onRefresh;

  const ItemProduk({super.key, required this.produk, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(produk: produk),
          ),
        );
        onRefresh();
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        child: ListTile(
          title: Text(
            produk.namaProduk ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(produk.hargaProduk?.toString() ?? ''),
        ),
      ),
    );
  }
}
