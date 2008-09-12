<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email to Position Owner when there are no Interviewers</fullName>
        <recipients>
            <type>owner</type>
        </recipients>
        <template>Workflow_Email_Templates/Position with no Interviewers</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign New Position to Recruiter Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Recruiter Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date Opened to Today</fullName>
        <field>Date_Opened__c</field>
        <formula>NOW()</formula>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner to Recruiter Queue on Approval</fullName>
        <field>OwnerId</field>
        <lookupValue>Recruiter Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status to Closed on Not Approved</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status to Open on Approval</fullName>
        <field>Status__c</field>
        <literalValue>Open</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub-Status for Positions in Progress</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Pending</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub-Status to Approved on Approval</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Approved</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub-Status to Not Approved on Reject</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Not Approved</literalValue>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
    </fieldUpdates>
    <rules>
        <fullName>New Position Rule</fullName>
        <actions>
            <name>Assign New Position to Recruiter Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Position__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Position has no Interviewers</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Position__c.Number_of_Interviewers__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>If a position has no interviewers after 30 days, an email will be sent to the position owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
