<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Submitted Offer Requires Attention</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Offer__c.Status__c</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <description>If an offer has been sent, but no word from candidate in 2 days, have recruiter follow up.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Follow up on submitted offer</fullName>
        <assignedToType>owner</assignedToType>
        <description>Recruiting has not received a response to an offer submitted to a candidate. Please follow up with candidate</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <status>Not Started</status>
    </tasks>
</Workflow>
