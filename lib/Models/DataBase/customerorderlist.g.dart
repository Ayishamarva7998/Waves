// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customerorderlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerOrderListAdapter extends TypeAdapter<CustomerOrderList> {
  @override
  final int typeId = 0;

  @override
  CustomerOrderList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerOrderList(
      orderType: fields[0] as int?,
      shopName: fields[1] as String?,
      shopcode: fields[2] as String?,
      customerName: fields[3] as String?,
      customercode: fields[4] as String?,
      itemCode: fields[5] as String?,
      itemName: fields[6] as String?,
      itemQty: fields[7] as double?,
      itemRate: fields[8] as double?,
      amount: fields[9] as double?,
      longitude: fields[10] as String?,
      latitude: fields[11] as String?,
      salesPerson: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerOrderList obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.orderType)
      ..writeByte(1)
      ..write(obj.shopName)
      ..writeByte(2)
      ..write(obj.shopcode)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.customercode)
      ..writeByte(5)
      ..write(obj.itemCode)
      ..writeByte(6)
      ..write(obj.itemName)
      ..writeByte(7)
      ..write(obj.itemQty)
      ..writeByte(8)
      ..write(obj.itemRate)
      ..writeByte(9)
      ..write(obj.amount)
      ..writeByte(10)
      ..write(obj.longitude)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.salesPerson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerOrderListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
