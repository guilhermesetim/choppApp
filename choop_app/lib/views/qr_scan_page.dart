import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  Barcode? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leitura de QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MobileScanner(
              onDetect: (barcode, args) {
                setState(() {
                  result = barcode;
                });

                if (result != null) {
                  // Pausa o scanner após ler o código
                  _sendQRCodeToSupabase(result!.rawValue ?? '');
                }
              },
            ),
          ),
          Center(
            child: (result != null)
                ? Text('Código Lido: ${result!.rawValue}')
                : Text('Escaneie um código QR'),
          )
        ],
      ),
    );
  }

  Future<void> _sendQRCodeToSupabase(String qrCode) async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final supabase = Supabase.instance.client;

  try {
    // Obtém o ID da cerveja a partir do QR Code
    final cervejaId = int.tryParse(qrCode);

    if (cervejaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código QR inválido!')),
      );
      return;
    }

    // Obtém o preço da cerveja a partir do provider
    final precoCerveja = authProvider.getCervejaPreco(cervejaId);

    if (precoCerveja == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cerveja não encontrada!')),
      );
      return;
    }

    // Prepara os dados a serem enviados para o servidor
    final requestData = {
      'nome': authProvider.nome
    };

    // Envia os dados para o servidor Python
    await http.post(
      Uri.parse('http://192.168.0.126:5000/enviar_dados'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    double novoSaldo = authProvider.balance - precoCerveja;

    await supabase
        .from('usuarios')
        .update({'saldo': novoSaldo})
        .eq('id', authProvider.cod);

    authProvider.updateBalance(-precoCerveja);

    await supabase
        .from('consumo')
        .insert({
            'quantidade': 400, 
            'valor': precoCerveja,
            'id_user': authProvider.cod,
            'id_cerveja': cervejaId,
          });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Consumo realizado! Seu novo saldo é de $novoSaldo')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao enviar QR code: $e')),
    );
  }
}


  // Future<void> _sendQRCodeToSupabase(String qrCode) async {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final supabase = Supabase.instance.client;

  //   try {
  //     // Obtém o ID da cerveja a partir do QR Code
  //     final cervejaId = int.tryParse(qrCode);

  //     if (cervejaId == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Código QR inválido!')),
  //       );
  //       return;
  //     }

  //     // Obtém o preço da cerveja a partir do provider
  //     final precoCerveja = authProvider.getCervejaPreco(cervejaId);

  //     if (precoCerveja == 0.0) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Cerveja não encontrada!')),
  //       );
  //       return;
  //     }

  //     // Insere no banco de dados com os valores obtidos
  //     await supabase
  //         .from('consumo')
  //         .insert({
  //           'quantidade': 400, 
  //           'valor': precoCerveja,
  //           'id_user': authProvider.cod,
  //           'id_cerveja': cervejaId,
  //         });

  //     double novoSaldo = (authProvider.balance - precoCerveja);

  //     await supabase
  //         .from('usuarios')
  //         .update({'saldo': novoSaldo})
  //         .eq('id', authProvider.cod);
      
  //     authProvider.updateBalance( (precoCerveja * (-1)) );

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Consumo realizado! Seu novo saldo é de $novoSaldo')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Erro ao enviar QR code: $e')),
  //     );
  //   }
  // }
}
