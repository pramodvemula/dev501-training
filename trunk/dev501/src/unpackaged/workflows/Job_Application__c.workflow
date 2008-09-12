<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Stage to Closed - Rejected</fullName>
        <field>Stage__c</field>
        <literalValue>Closed - Rejected</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage to Preparing Offer</fullName>
        <field>Stage__c</field>
        <literalValue>Preparing Offer</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status to Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status to Closed</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status to In Approval</fullName>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Approved Job App to HR System</fullName>
        <description>Send info re: candidate to internal HR system in anticipation of candidate accepting offer.</description>
        <endpointUrl>https://www.uc.com/internal-proc</endpointUrl>
        <fields>Average_Review_Score__c</fields>
        <fields>Candidate__c</fields>
        <fields>Email__c</fields>
        <fields>Id</fields>
        <fields>Name__c</fields>
        <fields>OwnerId</fields>
        <fields>Phone__c</fields>
        <fields>Position__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>admin@dev501.104.com.test</integrationUser>
    </outboundMessages>
    <tasks>
        <fullName>Notify candidate re%3A offer coming</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please inform the candidate via email/phone to expect an offer letter!</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <status>Not Started</status>
    </tasks>
</Workflow>
