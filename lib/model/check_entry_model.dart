class CheckEntryModel{
  DateTime? checkInTime;
  DateTime? checkOutTime;

  CheckEntryModel([this.checkInTime, this.checkOutTime]);

  void checkIn(){
    checkInTime = DateTime.now();
  }

  void checkOut(){
    checkOutTime = DateTime.now();
  }

  void reset() {
    checkInTime = null;
    checkOutTime = null;
  }
}