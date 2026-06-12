import '../models/pecs_model.dart';

class Module4Data {
  static const String path = "assets/images/basic_example/Module 4 Harvest/";

  static List<PecsItem> items = [
    PecsItem(id: "m4_1", label: "Pakai Sarung", imagePath: "${path}gloves.png", isAsset: true, instruction: "Pakai sarung tangan sebelum menuai."),
    PecsItem(id: "m4_2", label: "Pilih Pokok", imagePath: "${path}plant_in_basket.png", isAsset: true, instruction: "Pilih pokok yang buahnya hijau dan gemuk."),
    PecsItem(id: "m4_3", label: "Gunting Buah", imagePath: "${path}scissor.png", isAsset: true, instruction: "Gunting buah edamame dengan berhati-hati."),
    PecsItem(id: "m4_4", label: "Kumpul Hasil", imagePath: "${path}edamame.png", isAsset: true, instruction: "Kumpulkan semua buah edamame."),
    PecsItem(id: "m4_5", label: "Timbang", imagePath: "${path}scaler.png", isAsset: true, instruction: "Timbang berat hasil jualan."),
    PecsItem(id: "m4_6", label: "Bungkus", imagePath: "${path}plastic_bag.png", isAsset: true, instruction: "Masukkan edamame ke dalam plastik."),
  ];
}