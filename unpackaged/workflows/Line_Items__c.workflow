<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Field_UPdate</fullName>
        <field>Price__c</field>
        <name>Field__UPdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Insert_Merchandise_Price</fullName>
        <field>Price__c</field>
        <formula>Merchandise__r.Price__c</formula>
        <name>Insert Merchandise Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stock_Inventory</fullName>
        <field>Inventory__c</field>
        <formula>IF ( 
 ISNEW(),
  Merchandise__r.Inventory__c -  Units__c ,
  Merchandise__r.Inventory__c - (Units__c - PRIORVALUE(Units__c))
)</formula>
        <name>Update Stock Inventory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Merchandise__c</targetObject>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Message</fullName>
        <apiVersion>28.0</apiVersion>
        <endpointUrl>http://next.brainengine.net</endpointUrl>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Id</fields>
        <fields>Invoice_Statement__c</fields>
        <fields>IsDeleted</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Merchandise__c</fields>
        <fields>Name</fields>
        <fields>Price__c</fields>
        <fields>SystemModstamp</fields>
        <fields>Units__c</fields>
        <fields>Value__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>feedback@brainengine.net</integrationUser>
        <name>Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Line Item Created</fullName>
        <actions>
            <name>Field_UPdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Insert_Merchandise_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Line Item Updated</fullName>
        <actions>
            <name>Update_Stock_Inventory</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Invoice_Statement__c.Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
