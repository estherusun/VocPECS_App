import '../models/pecs_model.dart';

class Module1Data {
  static const String path = "assets/images/basic_example/Module 1 Germination/";

  static List<PecsItem> items = [
    PecsItem(id: "m1_1", label: "Sedia Cawan", imagePath: "${path}cup.png", isAsset: true, instruction: "Sediakan cawan berisi air suam."),
    PecsItem(id: "m1_2", label: "Ambil Benih", imagePath: "${path}seed.png", isAsset: true, instruction: "Ambil biji benih edamame."),
    PecsItem(id: "m1_3", label: "Rendam Benih", imagePath: "${path}seeds_dish.png", isAsset: true, instruction: "Rendam benih di dalam air."),
    PecsItem(id: "m1_4", label: "Sedia Tanah", imagePath: "${path}soil.png", isAsset: true, instruction: "Sediakan tanah semaian."),
    PecsItem(id: "m1_5", label: "Sedia Tray", imagePath: "${path}seed_tray.png", isAsset: true, instruction: "Sediakan tray semaian kosong."),
    PecsItem(id: "m1_6", label: "Tanam Benih", imagePath: "${path}soil_tray.png", isAsset: true, instruction: "Isi tanah ke dalam tray dan masukkan benih."),
    PecsItem(id: "m1_7", label: "Siram Benih", imagePath: "${path}spray_bottle.png", isAsset: true, instruction: "Sembur air pada tray semaian."),
  ];
}