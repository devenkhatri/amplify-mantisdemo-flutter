/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Orders type in your schema. */
@immutable
class Orders extends Model {
  static const classType = const _OrdersModelType();
  final String id;
  final String? _TrackingNo;
  final String? _ProductName;
  final int? _Quantity;
  final Statuses? _Status;
  final double? _TotalAmount;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get TrackingNo {
    return _TrackingNo;
  }
  
  String? get ProductName {
    return _ProductName;
  }
  
  int? get Quantity {
    return _Quantity;
  }
  
  Statuses? get Status {
    return _Status;
  }
  
  double? get TotalAmount {
    return _TotalAmount;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Orders._internal({required this.id, TrackingNo, ProductName, Quantity, Status, TotalAmount, createdAt, updatedAt}): _TrackingNo = TrackingNo, _ProductName = ProductName, _Quantity = Quantity, _Status = Status, _TotalAmount = TotalAmount, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Orders({String? id, String? TrackingNo, String? ProductName, int? Quantity, Statuses? Status, double? TotalAmount}) {
    return Orders._internal(
      id: id == null ? UUID.getUUID() : id,
      TrackingNo: TrackingNo,
      ProductName: ProductName,
      Quantity: Quantity,
      Status: Status,
      TotalAmount: TotalAmount);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Orders &&
      id == other.id &&
      _TrackingNo == other._TrackingNo &&
      _ProductName == other._ProductName &&
      _Quantity == other._Quantity &&
      _Status == other._Status &&
      _TotalAmount == other._TotalAmount;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Orders {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("TrackingNo=" + "$_TrackingNo" + ", ");
    buffer.write("ProductName=" + "$_ProductName" + ", ");
    buffer.write("Quantity=" + (_Quantity != null ? _Quantity!.toString() : "null") + ", ");
    buffer.write("Status=" + (_Status != null ? enumToString(_Status)! : "null") + ", ");
    buffer.write("TotalAmount=" + (_TotalAmount != null ? _TotalAmount!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Orders copyWith({String? id, String? TrackingNo, String? ProductName, int? Quantity, Statuses? Status, double? TotalAmount}) {
    return Orders._internal(
      id: id ?? this.id,
      TrackingNo: TrackingNo ?? this.TrackingNo,
      ProductName: ProductName ?? this.ProductName,
      Quantity: Quantity ?? this.Quantity,
      Status: Status ?? this.Status,
      TotalAmount: TotalAmount ?? this.TotalAmount);
  }
  
  Orders.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _TrackingNo = json['TrackingNo'],
      _ProductName = json['ProductName'],
      _Quantity = (json['Quantity'] as num?)?.toInt(),
      _Status = enumFromString<Statuses>(json['Status'], Statuses.values),
      _TotalAmount = (json['TotalAmount'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'TrackingNo': _TrackingNo, 'ProductName': _ProductName, 'Quantity': _Quantity, 'Status': enumToString(_Status), 'TotalAmount': _TotalAmount, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "orders.id");
  static final QueryField TRACKINGNO = QueryField(fieldName: "TrackingNo");
  static final QueryField PRODUCTNAME = QueryField(fieldName: "ProductName");
  static final QueryField QUANTITY = QueryField(fieldName: "Quantity");
  static final QueryField STATUS = QueryField(fieldName: "Status");
  static final QueryField TOTALAMOUNT = QueryField(fieldName: "TotalAmount");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Orders";
    modelSchemaDefinition.pluralName = "Orders";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: const [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Orders.TRACKINGNO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Orders.PRODUCTNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Orders.QUANTITY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Orders.STATUS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Orders.TOTALAMOUNT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _OrdersModelType extends ModelType<Orders> {
  const _OrdersModelType();
  
  @override
  Orders fromJson(Map<String, dynamic> jsonData) {
    return Orders.fromJson(jsonData);
  }
}