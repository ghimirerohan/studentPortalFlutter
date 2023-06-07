// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';


String userModelToJson(List<AdUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdUser {
  AdUser({
    required this.id,
    required this.uid,
    required this.name,
    required this.description,
    required this.ADClientID,
    required this.ADOrgID,
    required this.isActive,
    required this.created,
    required this.createdBy,
    required this.updated,
    required this.updatedBy,
    required this.CBPartnerID,
    required this.notificationType,
    required this.isFullBPAccess,
    required this.value,
    required this.isInPayroll,
    required this.isSalesLead,
    required this.isLocked,
    required this.failedLoginCount,
    required this.datePasswordChanged,
    required this.dateLastLogin,
    required this.isExpired,
    required this.isAddMailTextAutomatically,
    required this.isSupportUser,
    required this.isShipTo,
    required this.isBillTo,
    required this.modelname,
  });
  late final int id;
  late final String uid;
  late final String name;
  late final String description;
  late final AdclientId ADClientID;
  late final AdorgId ADOrgID;
  late final bool isActive;
  late final String created;
  late final CreatedBy createdBy;
  late final String updated;
  late final UpdatedBy updatedBy;
  late final CbpartnerId CBPartnerID;
  late final NotificationType notificationType;
  late final bool isFullBPAccess;
  late final String value;
  late final bool isInPayroll;
  late final bool isSalesLead;
  late final bool isLocked;
  late final int failedLoginCount;
  late final String datePasswordChanged;
  late final String dateLastLogin;
  late final bool isExpired;
  late final bool isAddMailTextAutomatically;
  late final bool isSupportUser;
  late final bool isShipTo;
  late final bool isBillTo;
  late final String modelname;

  AdUser.fromJson(Map<String, dynamic> json){
    id = json['id'];
    uid = json['uid'];
    name = json['name'];
    description = json['description'];
    ADClientID = AdclientId.fromJson(json['AD_Client_ID']);
    ADOrgID = AdorgId.fromJson(json['AD_Org_ID']);
    isActive = json['isActive'];
    created = json['created'];
    createdBy = CreatedBy.fromJson(json['createdBy']);
    updated = json['updated'];
    updatedBy = UpdatedBy.fromJson(json['updatedBy']);
    CBPartnerID = CbpartnerId.fromJson(json['C_BPartner_ID']);
    notificationType = NotificationType.fromJson(json['notificationType']);
    isFullBPAccess = json['isFullBPAccess'];
    value = json['value'];
    isInPayroll = json['isInPayroll'];
    isSalesLead = json['isSalesLead'];
    isLocked = json['isLocked'];
    failedLoginCount = json['failedLoginCount'];
    datePasswordChanged = json['datePasswordChanged'];
    dateLastLogin = json['dateLastLogin'];
    isExpired = json['isExpired'];
    isAddMailTextAutomatically = json['isAddMailTextAutomatically'];
    isSupportUser = json['isSupportUser'];
    isShipTo = json['isShipTo'];
    isBillTo = json['isBillTo'];
    modelname = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uid'] = uid;
    _data['name'] = name;
    _data['description'] = description;
    _data['AD_Client_ID'] = ADClientID.toJson();
    _data['AD_Org_ID'] = ADOrgID.toJson();
    _data['isActive'] = isActive;
    _data['created'] = created;
    _data['createdBy'] = createdBy.toJson();
    _data['updated'] = updated;
    _data['updatedBy'] = updatedBy.toJson();
    _data['C_BPartner_ID'] = CBPartnerID.toJson();
    _data['notificationType'] = notificationType.toJson();
    _data['isFullBPAccess'] = isFullBPAccess;
    _data['value'] = value;
    _data['isInPayroll'] = isInPayroll;
    _data['isSalesLead'] = isSalesLead;
    _data['isLocked'] = isLocked;
    _data['failedLoginCount'] = failedLoginCount;
    _data['datePasswordChanged'] = datePasswordChanged;
    _data['dateLastLogin'] = dateLastLogin;
    _data['isExpired'] = isExpired;
    _data['isAddMailTextAutomatically'] = isAddMailTextAutomatically;
    _data['isSupportUser'] = isSupportUser;
    _data['isShipTo'] = isShipTo;
    _data['isBillTo'] = isBillTo;
    _data['model-name'] = modelname;
    return _data;
  }
}

class AdclientId {
  AdclientId({
    required this.propertyLabel,
    required this.id,
    required this.identifier,
    required this.modelname,
  });
  late final String propertyLabel;
  late final int id;
  late final String identifier;
  late final String modelname;

  AdclientId.fromJson(Map<String, dynamic> json){
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelname = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['propertyLabel'] = propertyLabel;
    _data['id'] = id;
    _data['identifier'] = identifier;
    _data['model-name'] = modelname;
    return _data;
  }
}

class AdorgId {
  AdorgId({
    required this.propertyLabel,
    required this.id,
    required this.identifier,
    required this.modelname,
  });
  late final String propertyLabel;
  late final int id;
  late final String identifier;
  late final String modelname;

  AdorgId.fromJson(Map<String, dynamic> json){
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelname = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['propertyLabel'] = propertyLabel;
    _data['id'] = id;
    _data['identifier'] = identifier;
    _data['model-name'] = modelname;
    return _data;
  }
}

class CreatedBy {
  CreatedBy({
    required this.propertyLabel,
    required this.id,
    required this.identifier,
    required this.modelname,
  });
  late final String propertyLabel;
  late final int id;
  late final String identifier;
  late final String modelname;

  CreatedBy.fromJson(Map<String, dynamic> json){
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelname = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['propertyLabel'] = propertyLabel;
    _data['id'] = id;
    _data['identifier'] = identifier;
    _data['model-name'] = modelname;
    return _data;
  }
}

class UpdatedBy {
  UpdatedBy({
    required this.propertyLabel,
    required this.id,
    required this.identifier,
    required this.modelname,
  });
  late final String propertyLabel;
  late final int id;
  late final String identifier;
  late final String modelname;

  UpdatedBy.fromJson(Map<String, dynamic> json){
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelname = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['propertyLabel'] = propertyLabel;
    _data['id'] = id;
    _data['identifier'] = identifier;
    _data['model-name'] = modelname;
    return _data;
  }
}

class CbpartnerId {
  CbpartnerId({
    required this.propertyLabel,
    required this.id,
    required this.identifier,
    required this.modelname,
  });
  late final String propertyLabel;
  late final int id;
  late final String identifier;
  late final String modelname;

  CbpartnerId.fromJson(Map<String, dynamic> json){
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelname = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['propertyLabel'] = propertyLabel;
    _data['id'] = id;
    _data['identifier'] = identifier;
    _data['model-name'] = modelname;
    return _data;
  }
}

class NotificationType {
  NotificationType({
    required this.propertyLabel,
    required this.id,
    required this.identifier,
    required this.modelname,
  });
  late final String propertyLabel;
  late final String id;
  late final String identifier;
  late final String modelname;

  NotificationType.fromJson(Map<String, dynamic> json){
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelname = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['propertyLabel'] = propertyLabel;
    _data['id'] = id;
    _data['identifier'] = identifier;
    _data['model-name'] = modelname;
    return _data;
  }
}