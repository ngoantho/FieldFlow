class CheckEntryModel{
  DateTime? checkInTime;
  DateTime? checkOutTime;

  void check_in(){
    checkInTime = DateTime.now();
  }

  void check_out(){
    checkOutTime = DateTime.now();
  }
}