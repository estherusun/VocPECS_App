import '../models/pecs_model.dart';

class Module3Data {
  static const String path = "assets/images/basic_example/Module 3 Nursery/";

  static List<PecsItem> items = [
    PecsItem(id: "m3_1", label: "Pakai Sarung", imagePath: "${path}gloves.png", isAsset: true, instruction: "Pakai sarung tangan untuk kebersihan."),
    PecsItem(id: "m3_2", label: "Siram Pokok", imagePath: "${path}watering_can.png", isAsset: true, instruction: "Siram pokok setiap pagi dan petang."),
    PecsItem(id: "m3_3", label: "Letak Baja", imagePath: "${path}npk_fertilizer.png", isAsset: true, instruction: "Tabur baja NPK keliling pokok."),
    PecsItem(id: "m3_4", label: "Gembur Tanah", imagePath: "${path}handheld_shovel.png", isAsset: true, instruction: "Gemburkan tanah supaya akar bernafas."),
    PecsItem(id: "m3_5", label: "Gunting Daun", imagePath: "${path}scissor.png", isAsset: true, instruction: "Buang daun yang rosak atau berpenyakit."),
    PecsItem(id: "m3_6", label: "Pantau", imagePath: "${path}plant_in_basket.png", isAsset: true, instruction: "Pastikan pokok membesar dengan sihat."),
  ];
}