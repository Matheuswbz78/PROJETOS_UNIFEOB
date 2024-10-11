import 'package:Malpa/data/models/cupons.dart';

class CupomRepository {
  static List<Cupom> tabela = [
    Cupom(
        icone: "cupom.png",
        nome: "Cupom 10%",
        sigla: "c10",
        preco: 600,
        descricao: "Um cupom de 10% que pode ser utilizada em lojas parceiras",
        validade: "24/08/2024"),
    Cupom(
        icone: "cupom.png",
        nome: "Cupom 20%",
        sigla: "C20",
        preco: 1200,
        descricao: "Um cupom de 20% que pode ser utilizada em lojas parceiras",
        validade: "24/08/2024"),
    Cupom(
        icone: "cupom.png",
        nome: "Cupom 50%",
        sigla: "C50",
        preco: 3600,
        descricao: "Um cupom de 50% que pode ser utilizada em lojas parceiras",
        validade: "24/08/2024"),
  ];
}
