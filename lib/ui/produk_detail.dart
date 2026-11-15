import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/helper/api_exception.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Produk produk;

  ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              "Kode : ${widget.produk.kodeProduk ?? ''}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk.namaProduk ?? ''}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk.hargaProduk?.toString() ?? ''}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit (Warna Hijau sesuai gambar modul)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.black87,
            elevation: 2,
            shape: const RoundedRectangleBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: widget.produk),
              ),
            );
            _getData();
          },
          child: const Text("EDIT"),
        ),
        const SizedBox(width: 4),
        // Tombol Hapus (Warna Merah sesuai gambar modul)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.black87,
            elevation: 2,
            shape: const RoundedRectangleBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          ),
          onPressed: () => confirmHapus(),
          child: const Text("DELETE"),
        ),
      ],
    );
  }

  Future _getData() async {
    try {
      final produk = await ProdukBloc.detailProduk(id: widget.produk.id!);
      setState(() {
        widget.produk = produk;
      });
    } on ApiException catch (_) {
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) Navigator.pop(context);
    }
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.white,
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () async {
            Navigator.pop(context);
            await _hapusProduk();
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }

  Future _hapusProduk() async {
    try {
      await ProdukBloc.deleteProduk(id: widget.produk.id!);
      if (!mounted) return;
      Navigator.pop(context);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError("Gagal menghapus produk, cek koneksi ke server");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
