trigger CloseOpportunity on FeedItem bulk (after insert) {

Set<Id> oppIds = new Set<Id>();
List<Task> tasks = new List<Task>();
List<Opportunity> opps2Update = new List<Opportunity>();
Map<Id, Id> oppId2PostCreator = new Map<Id, Id>();


// Get the key prefix for the Opportunity object
// using a describe call.
String oppKeyPrefix = Opportunity.sObjectType.getDescribe().
getKeyPrefix();
for (FeedItem f: trigger.new)
{
String parentId = f.parentId;
// Compare the start of the parentID field
// to the Opportunity key prefix. Use this to
// restrict the trigger to act only on posts made to the
// Opportunity object.
if (parentId.startsWith(oppKeyPrefix) &&
f.type == 'TextPost' &&
f.Body.startsWith('!close'))
{
oppIds.add(f.parentId);
oppId2PostCreator.put(f.parentId, f.CreatedById);
}
}

List<Opportunity> opps = [SELECT id, account.name, ownerId,
stageName, closeDate
FROM Opportunity
WHERE id IN :oppIds];
for (Opportunity o : opps)
{
//Compare the creator of the Chatter post
//to the opportunity owner to ensure
//that only authorized users can close the opportunity
//using the special code !close
if (oppId2PostCreator.get(o.Id) == o.ownerId)
{
o.StageName = 'Closed Won';
o.CloseDate = System.today();
Task t = new Task ( OwnerId = o.OwnerId,
WhatId = o.Id,
Priority = 'High',
Description = 'Check-in with '+account.name,
Subject = 'Follow-up',
ActivityDate = System.today().addDays(7));
tasks.add(t);
opps2Update.add(o);
}
}
update opps2Update;
insert tasks;
}