import '../models/pecs_model.dart';

class Module2Data {
  static const String path = "assets/images/basic_example/Module 2 Transfer Sapling/";

  static List<PecsItem> items = [
    PecsItem(id: "m2_1", label: "Tanah Merah", imagePath: "${path}red_soil.png", isAsset: true, instruction: "Sediakan 2 bahagian tanah merah."),
    PecsItem(id: "m2_2", label: "Cocopeat", imagePath: "${path}cocopeat.png", isAsset: true, instruction: "Tambahkan 1 bahagian cocopeat."),
    PecsItem(id: "m2_3", label: "Kompos", imagePath: "${path}compost.png", isAsset: true, instruction: "Tambahkan 1 bahagian baja kompos."),
    PecsItem(id: "m2_4", label: "Sekam Padi", imagePath: "${path}rice_husk.png", isAsset: true, instruction: "Tambahkan 1 bahagian sekam padi."),
    PecsItem(id: "m2_5", label: "Gaul Tanah", imagePath: "${path}handheld_shovel.png", isAsset: true, instruction: "Gaul semua bahan menggunakan penyodok."),
    PecsItem(id: "m2_6", label: "Sedia Polibeg", imagePath: "${path}polybag.png", isAsset: true, instruction: "Buka polibeg kosong."),
    PecsItem(id: "m2_7", label: "Isi Tanah", imagePath: "${path}mix_soil.png", isAsset: true, instruction: "Masukkan tanah campuran ke dalam polibeg."),
    PecsItem(id: "m2_8", label: "Ambil Pokok", imagePath: "${path}sapling.png", isAsset: true, instruction: "Keluarkan anak pokok dari tray dengan cermat."),
    PecsItem(id: "m2_9", label: "Tanam Pokok", imagePath: "${path}plant_in_basket.png", isAsset: true, instruction: "Masukkan anak pokok ke dalam polibeg."),
    PecsItem(id: "m2_10", label: "Siram Pokok", imagePath: "${path}water_dipper.png", isAsset: true, instruction: "Siram pokok yang baru dipindah."),
  ];
}