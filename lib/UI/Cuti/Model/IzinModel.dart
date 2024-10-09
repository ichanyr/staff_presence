class IzinModel {
  final String key;
  final String string;
   bool isSelected;

  IzinModel(this.key, this.string, this.isSelected);
}

class ListIzin {
  final List<IzinModel> listIzinModel;

  ListIzin(this.listIzinModel);
}
