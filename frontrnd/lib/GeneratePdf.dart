import 'package:pdf/widgets.dart' as pdfLib;
import 'package:printing/printing.dart';

Future<void> GeneratePdf(Map<String, dynamic> data) async {
  final netImage = await networkImage(data['image']);
  final pdfLib.Document pdf = pdfLib.Document();
  pdf.addPage(
    pdfLib.Page(
      build: (pdfLib.Context context) {
        return pdfLib.Center(
          child: pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: <pdfLib.Widget>[
              // Text rata kanan
              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Token ID:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    '${data['tokenId']}',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),

              pdfLib.Divider(),

              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Nama:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    '${data['name']}',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),
              pdfLib.Divider(),

              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Alamat:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    '${data['urlLocation']}',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),
              pdfLib.Divider(),

              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Deskripsi:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    '${data['description']}',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),
              pdfLib.Divider(),

              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Smart Contract:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    '0x3f6518844fb95cc0693bf05a0a0F144d7DEDA699',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),
              pdfLib.Divider(),

              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Dicetak Oleh:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    '${data['creator']}',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),
              pdfLib.Divider(),

              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Diterbitkan Tanggal:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    '${data['createdAt'].split('T')[0]}',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),

              pdfLib.Divider(),
              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: <pdfLib.Widget>[
                  pdfLib.Text(
                    'Blokchain Explorer:',
                    textAlign: pdfLib.TextAlign.left,
                  ),
                  pdfLib.Text(
                    'https://www.okx.com/web3/explorer/amoy',
                    textAlign: pdfLib.TextAlign.right,
                  ),
                ],
              ),

              pdfLib.Divider(),
              pdfLib.Text(
                'Denah Tanah:',
                textAlign: pdfLib.TextAlign.left,
              ),

              pdfLib.SizedBox(height: 20),
              pdfLib.Image(netImage, width: 200, height: 200),
              pdfLib.SizedBox(height: 40),
              pdfLib.Text(
                '**Gambar denah disimpan dalam InterPlanetary File System (IPFS) untuk memastikan aksesibilitas dan desentralisasi data. Sedangkan, metadata terkait gambar denah disimpan dalam Non-Fungible Token (NFT) di atas Blockchain Polygon Amoy Testnet untuk menjamin keaslian, kepemilikan, dan riwayat kepemilikan yang aman dan terverifikasi.**',
                textAlign: pdfLib.TextAlign.justify,
                style: pdfLib.TextStyle(
                  fontSize: 16.0,
                  fontWeight: pdfLib.FontWeight.bold,
                ),
              ),

              // Text lainnya
            ],
          ),
        );
      },
    ),
  );

  // Cetak dokumen PDF
  Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}
