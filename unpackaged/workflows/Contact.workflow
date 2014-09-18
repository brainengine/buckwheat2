<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Contact</fullName>
        <apiVersion>25.0</apiVersion>
        <endpointUrl>http://99.112.172.182:9090</endpointUrl>
        <fields>Birthdate</fields>
        <fields>Department</fields>
        <fields>FirstName</fields>
        <fields>Id</fields>
        <fields>LastName</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>feedback@brainengine.net</integrationUser>
        <name>Contact</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>New Contact</fullName>
        <actions>
            <name>Contact</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.FirstName</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
