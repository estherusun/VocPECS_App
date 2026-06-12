import 'pecs_model.dart';
import '../data/m1.dart';
import '../data/m2.dart';
import '../data/m3.dart';
import '../data/m4.dart';

class InitialData {
  static List<PecsTask> getSeedTasks() {
    return [
      PecsTask(id: "alb1", taskName: "Module 1: Germination", items: Module1Data.items),
      PecsTask(id: "alb2", taskName: "Module 2: Transfer Sapling", items: Module2Data.items),
      PecsTask(id: "alb3", taskName: "Module 3: Nursery", items: Module3Data.items),
      PecsTask(id: "alb4", taskName: "Module 4: Harvest", items: Module4Data.items),
    ];
  }
}