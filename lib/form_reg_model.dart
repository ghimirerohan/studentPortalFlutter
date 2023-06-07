class form_register {
  int? id;
  String? uid;
  ADClientID? aDClientID;
  ADClientID? aDOrgID;
  bool? isActive;
  String? created;
  ADClientID? createdBy;
  String? updated;
  ADClientID? updatedBy;
  String? value;
  String? name;
  int? salesVolume;
  int? numberEmployees;
  bool? isSummary;
  ADLanguage? aDLanguage;
  bool? isVendor;
  bool? isCustomer;
  bool? isProspect;
  String? sOCreditLimit;
  String? sOCreditUsed;
  String? acqusitionCost;
  String? potentialLifeTimeValue;
  ADClientID? cPaymentTermID;
  String? actualLifeTimeValue;
  int? shareOfCustomer;
  bool? isEmployee;
  bool? isSalesRep;
  ADClientID? mPriceListID;
  bool? isOneTime;
  bool? isTaxExempt;
  int? documentCopies;
  bool? isDiscountPrinted;
  ADClientID? salesRepID;
  ADClientID? cBPGroupID;
  bool? sendEMail;
  ADLanguage? sOCreditStatus;
  int? shelfLifeMinPct;
  String? flatDiscount;
  String? totalOpenBalance;
  bool? isPOTaxExempt;
  bool? isManufacturer;
  bool? is1099Vendor;
  bool? isStudent;
  String? eMail;
  String? phone;
  String? urollno;
  String? regrollno;
  String? entranceRollNo;
  String? dobAd;
  String? dobBs;
  ADLanguage? gender;
  String? fatherName;
  String? motherName;
  String? grandFatherName;
  String? grandMotherName;
  String? nameNepali;
  String? citizenNo;
  String? citizenIssueDistrict;
  String? castEthinicity;
  String? religion;
  String? nationality;
  String? maritialStatus;
  String? nationalIdNo;
  String? inclusionGroup;
  bool? isEntranceApplicant;
  String? regrollsn;
  String? regbvattachment;
  int? regamount;
  String? regbankbranch;
  bool? regrollstatus;
  String? modelName;

  form_register(
      {this.id,
        this.uid,
        this.aDClientID,
        this.aDOrgID,
        this.isActive,
        this.created,
        this.createdBy,
        this.updated,
        this.updatedBy,
        this.value,
        this.name,
        this.salesVolume,
        this.numberEmployees,
        this.isSummary,
        this.aDLanguage,
        this.isVendor,
        this.isCustomer,
        this.isProspect,
        this.sOCreditLimit,
        this.sOCreditUsed,
        this.acqusitionCost,
        this.potentialLifeTimeValue,
        this.cPaymentTermID,
        this.actualLifeTimeValue,
        this.shareOfCustomer,
        this.isEmployee,
        this.isSalesRep,
        this.mPriceListID,
        this.isOneTime,
        this.isTaxExempt,
        this.documentCopies,
        this.isDiscountPrinted,
        this.salesRepID,
        this.cBPGroupID,
        this.sendEMail,
        this.sOCreditStatus,
        this.shelfLifeMinPct,
        this.flatDiscount,
        this.totalOpenBalance,
        this.isPOTaxExempt,
        this.isManufacturer,
        this.is1099Vendor,
        this.isStudent,
        this.eMail,
        this.phone,
        this.urollno,
        this.regrollno,
        this.entranceRollNo,
        this.dobAd,
        this.dobBs,
        this.gender,
        this.fatherName,
        this.motherName,
        this.grandFatherName,
        this.grandMotherName,
        this.nameNepali,
        this.citizenNo,
        this.citizenIssueDistrict,
        this.castEthinicity,
        this.religion,
        this.nationality,
        this.maritialStatus,
        this.nationalIdNo,
        this.inclusionGroup,
        this.isEntranceApplicant,
        this.regrollsn,
        this.regbvattachment,
        this.regamount,
        this.regbankbranch,
        this.regrollstatus,
        this.modelName});

  form_register.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    aDClientID = json['AD_Client_ID'] != null
        ? new ADClientID.fromJson(json['AD_Client_ID'])
        : null;
    aDOrgID = json['AD_Org_ID'] != null
        ? new ADClientID.fromJson(json['AD_Org_ID'])
        : null;
    isActive = json['isActive'];
    created = json['created'];
    createdBy = json['createdBy'] != null
        ? new ADClientID.fromJson(json['createdBy'])
        : null;
    updated = json['updated'];
    updatedBy = json['updatedBy'] != null
        ? new ADClientID.fromJson(json['updatedBy'])
        : null;
    value = json['value'];
    name = json['name'];
    salesVolume = json['salesVolume'];
    numberEmployees = json['numberEmployees'];
    isSummary = json['isSummary'];
    aDLanguage = json['AD_Language'] != null
        ? new ADLanguage.fromJson(json['AD_Language'])
        : null;
    isVendor = json['isVendor'];
    isCustomer = json['isCustomer'];
    isProspect = json['isProspect'];
    sOCreditLimit = json['SO_CreditLimit'];
    sOCreditUsed = json['SO_CreditUsed'];
    acqusitionCost = json['acqusitionCost'];
    potentialLifeTimeValue = json['potentialLifeTimeValue'];
    cPaymentTermID = json['C_PaymentTerm_ID'] != null
        ? new ADClientID.fromJson(json['C_PaymentTerm_ID'])
        : null;
    actualLifeTimeValue = json['actualLifeTimeValue'];
    shareOfCustomer = json['shareOfCustomer'];
    isEmployee = json['isEmployee'];
    isSalesRep = json['isSalesRep'];
    mPriceListID = json['M_PriceList_ID'] != null
        ? new ADClientID.fromJson(json['M_PriceList_ID'])
        : null;
    isOneTime = json['isOneTime'];
    isTaxExempt = json['isTaxExempt'];
    documentCopies = json['documentCopies'];
    isDiscountPrinted = json['isDiscountPrinted'];
    salesRepID = json['SalesRep_ID'] != null
        ? new ADClientID.fromJson(json['SalesRep_ID'])
        : null;
    cBPGroupID = json['C_BP_Group_ID'] != null
        ? new ADClientID.fromJson(json['C_BP_Group_ID'])
        : null;
    sendEMail = json['sendEMail'];
    sOCreditStatus = json['sOCreditStatus'] != null
        ? new ADLanguage.fromJson(json['sOCreditStatus'])
        : null;
    shelfLifeMinPct = json['shelfLifeMinPct'];
    flatDiscount = json['flatDiscount'];
    totalOpenBalance = json['totalOpenBalance'];
    isPOTaxExempt = json['isPOTaxExempt'];
    isManufacturer = json['isManufacturer'];
    is1099Vendor = json['is1099Vendor'];
    isStudent = json['isStudent'];
    eMail = json['eMail'];
    phone = json['phone'];
    urollno = json['urollno'];
    regrollno = json['regrollno'];
    entranceRollNo = json['entrance_roll_no'];
    dobAd = json['dob_ad'];
    dobBs = json['dob_bs'];
    gender =
    json['gender'] != null ? new ADLanguage.fromJson(json['gender']) : null;
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    grandFatherName = json['grand_father_name'];
    grandMotherName = json['grand_mother_name'];
    nameNepali = json['name_nepali'];
    citizenNo = json['citizen_no'];
    citizenIssueDistrict = json['citizen_issue_district'];
    castEthinicity = json['cast_ethinicity'];
    religion = json['religion'];
    nationality = json['nationality'];
    maritialStatus = json['maritial_status'];
    nationalIdNo = json['national_id_no'];
    inclusionGroup = json['inclusion_group'];
    isEntranceApplicant = json['isEntranceApplicant'];
    regrollsn = json['regrollsn'];
    regbvattachment = json['regbvattachment'];
    regamount = json['regamount'];
    regbankbranch = json['regbankbranch'];
    regrollstatus = json['regrollstatus'];
    modelName = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    if (this.aDClientID != null) {
      data['AD_Client_ID'] = this.aDClientID!.toJson();
    }
    if (this.aDOrgID != null) {
      data['AD_Org_ID'] = this.aDOrgID!.toJson();
    }
    data['isActive'] = this.isActive;
    data['created'] = this.created;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['updated'] = this.updated;
    if (this.updatedBy != null) {
      data['updatedBy'] = this.updatedBy!.toJson();
    }
    data['value'] = this.value;
    data['name'] = this.name;
    data['salesVolume'] = this.salesVolume;
    data['numberEmployees'] = this.numberEmployees;
    data['isSummary'] = this.isSummary;
    if (this.aDLanguage != null) {
      data['AD_Language'] = this.aDLanguage!.toJson();
    }
    data['isVendor'] = this.isVendor;
    data['isCustomer'] = this.isCustomer;
    data['isProspect'] = this.isProspect;
    data['SO_CreditLimit'] = this.sOCreditLimit;
    data['SO_CreditUsed'] = this.sOCreditUsed;
    data['acqusitionCost'] = this.acqusitionCost;
    data['potentialLifeTimeValue'] = this.potentialLifeTimeValue;
    if (this.cPaymentTermID != null) {
      data['C_PaymentTerm_ID'] = this.cPaymentTermID!.toJson();
    }
    data['actualLifeTimeValue'] = this.actualLifeTimeValue;
    data['shareOfCustomer'] = this.shareOfCustomer;
    data['isEmployee'] = this.isEmployee;
    data['isSalesRep'] = this.isSalesRep;
    if (this.mPriceListID != null) {
      data['M_PriceList_ID'] = this.mPriceListID!.toJson();
    }
    data['isOneTime'] = this.isOneTime;
    data['isTaxExempt'] = this.isTaxExempt;
    data['documentCopies'] = this.documentCopies;
    data['isDiscountPrinted'] = this.isDiscountPrinted;
    if (this.salesRepID != null) {
      data['SalesRep_ID'] = this.salesRepID!.toJson();
    }
    if (this.cBPGroupID != null) {
      data['C_BP_Group_ID'] = this.cBPGroupID!.toJson();
    }
    data['sendEMail'] = this.sendEMail;
    if (this.sOCreditStatus != null) {
      data['sOCreditStatus'] = this.sOCreditStatus!.toJson();
    }
    data['shelfLifeMinPct'] = this.shelfLifeMinPct;
    data['flatDiscount'] = this.flatDiscount;
    data['totalOpenBalance'] = this.totalOpenBalance;
    data['isPOTaxExempt'] = this.isPOTaxExempt;
    data['isManufacturer'] = this.isManufacturer;
    data['is1099Vendor'] = this.is1099Vendor;
    data['isStudent'] = this.isStudent;
    data['eMail'] = this.eMail;
    data['phone'] = this.phone;
    data['urollno'] = this.urollno;
    data['regrollno'] = this.regrollno;
    data['entrance_roll_no'] = this.entranceRollNo;
    data['dob_ad'] = this.dobAd;
    data['dob_bs'] = this.dobBs;
    if (this.gender != null) {
      data['gender'] = this.gender!.toJson();
    }
    data['father_name'] = this.fatherName;
    data['mother_name'] = this.motherName;
    data['grand_father_name'] = this.grandFatherName;
    data['grand_mother_name'] = this.grandMotherName;
    data['name_nepali'] = this.nameNepali;
    data['citizen_no'] = this.citizenNo;
    data['citizen_issue_district'] = this.citizenIssueDistrict;
    data['cast_ethinicity'] = this.castEthinicity;
    data['religion'] = this.religion;
    data['nationality'] = this.nationality;
    data['maritial_status'] = this.maritialStatus;
    data['national_id_no'] = this.nationalIdNo;
    data['inclusion_group'] = this.inclusionGroup;
    data['isEntranceApplicant'] = this.isEntranceApplicant;
    data['regrollsn'] = this.regrollsn;
    data['regbvattachment'] = this.regbvattachment;
    data['regamount'] = this.regamount;
    data['regbankbranch'] = this.regbankbranch;
    data['regrollstatus'] = this.regrollstatus;
    data['model-name'] = this.modelName;
    return data;
  }
}

class ADClientID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelName;

  ADClientID({this.propertyLabel, this.id, this.identifier, this.modelName});

  ADClientID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelName = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['propertyLabel'] = this.propertyLabel;
    data['id'] = this.id;
    data['identifier'] = this.identifier;
    data['model-name'] = this.modelName;
    return data;
  }
}

class ADLanguage {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelName;

  ADLanguage({this.propertyLabel, this.id, this.identifier, this.modelName});

  ADLanguage.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'];
    id = json['id'];
    identifier = json['identifier'];
    modelName = json['model-name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['propertyLabel'] = this.propertyLabel;
    data['id'] = this.id;
    data['identifier'] = this.identifier;
    data['model-name'] = this.modelName;
    return data;
  }
}