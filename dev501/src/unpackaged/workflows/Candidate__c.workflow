<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Assign New Candidate to Recruiter Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Recruiter Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
    </fieldUpdates>
    <rules>
        <fullName>New Candidate Notification</fullName>
        <actions>
            <name>Assign New Candidate to Recruiter Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Candidate__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
