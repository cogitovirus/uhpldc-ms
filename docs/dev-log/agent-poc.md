# Agent POC

./deploy.sh P@ssw0rd123!

- linked services has to be deployed via api

- solid deploy resource group setup/teardown
-- dynamic name
-- proper teardown
- make a pipeline in synapse - event based load a csv file
- make it fail and send an event to a lambda function
- lambda function should trigger a langchain RAG agent to troubleshoot
- two actions? restart or notify ?
