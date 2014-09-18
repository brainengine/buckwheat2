//Generated by wsdl2apex

public class wwwRepsrvComServicebasetypes1 {
    public class ErrorType {
        public String errorCode;
        public String errorLevel;
        public String errorDescription;
        public String errorStackTrace;
        public wwwRepsrvComServicebasetypes1.ServiceInfoType serviceOccurred;
        private String[] errorCode_type_info = new String[]{'errorCode','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] errorLevel_type_info = new String[]{'errorLevel','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] errorDescription_type_info = new String[]{'errorDescription','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] errorStackTrace_type_info = new String[]{'errorStackTrace','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] serviceOccurred_type_info = new String[]{'serviceOccurred','http://www.repsrv.com/ServiceBaseTypes','ServiceInfoType','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.repsrv.com/ServiceBaseTypes','true','false'};
        private String[] field_order_type_info = new String[]{'errorCode','errorLevel','errorDescription','errorStackTrace','serviceOccurred'};
    }
    public class NVPairList {
        public wwwRepsrvComServicebasetypes1.NVPairType[] NVPitem;
        private String[] NVPitem_type_info = new String[]{'NVPitem','http://www.repsrv.com/ServiceBaseTypes','NVPairType','1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.repsrv.com/ServiceBaseTypes','true','false'};
        private String[] field_order_type_info = new String[]{'NVPitem'};
    }
    public class NVPairType {
        public String NVPname;
        public String NVPvalue;
        private String[] NVPname_type_info = new String[]{'NVPname','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] NVPvalue_type_info = new String[]{'NVPvalue','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.repsrv.com/ServiceBaseTypes','true','false'};
        private String[] field_order_type_info = new String[]{'NVPname','NVPvalue'};
    }
    public class ServiceInfoType {
        public String ServiceName;
        public String ServiceVersion;
        public String ServiceType;
        private String[] ServiceName_type_info = new String[]{'ServiceName','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
        private String[] ServiceVersion_type_info = new String[]{'ServiceVersion','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] ServiceType_type_info = new String[]{'ServiceType','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.repsrv.com/ServiceBaseTypes','true','false'};
        private String[] field_order_type_info = new String[]{'ServiceName','ServiceVersion','ServiceType'};
    }
    public class ErrorListType {
        public wwwRepsrvComServicebasetypes1.ErrorType[] errorItem;
        private String[] errorItem_type_info = new String[]{'errorItem','http://www.repsrv.com/ServiceBaseTypes','ErrorType','1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.repsrv.com/ServiceBaseTypes','true','false'};
        private String[] field_order_type_info = new String[]{'errorItem'};
    }
}