#!/usr/bin/env python3

from azure.identity import DefaultAzureCredential
from azure.synapse.artifacts import ArtifactsClient
from azure.synapse.artifacts.models import (
    PipelineResource, 
    CopyActivity, 
    DelimitedTextDataset,  # Adjusted import
    DatasetResource, 
    DataFlowResource, 
    DataFlowSource, 
    DataFlowSink,
    MappingDataFlow
)

# Configuration
WORKSPACE_NAME = "synapse-uhpldc-ms"
SUBSCRIPTION_ID = "28922351-f21e-4928-b185-ead075be0063"
RESOURCE_GROUP_NAME = "uhpldc-ms-demo-wz"
LINKED_SERVICE_NAME = "synapse-uhpldc-ms"
SOURCE_FOLDER_PATH = "input"
SOURCE_FILE_PATTERN = "*.csv"  # Pattern to match all CSV files
SINK_FOLDER_PATH = "output"
SINK_FILE_NAME = "result_{DateTime.Now}.csv"  # Dynamic file name with timestamp
SOURCE_DATASET_NAME = "SourceDataset"
SINK_DATASET_NAME = "SinkDataset"
DATA_FLOW_NAME = "SimpleDataFlow"
PIPELINE_NAME = "SimplePipeline"

# Set up authentication and client
credential = DefaultAzureCredential()
synapse_client = ArtifactsClient(
    endpoint=f"https://{WORKSPACE_NAME}.dev.azuresynapse.net",
    credential=credential
)

# Define source dataset with file pattern
source_dataset = DatasetResource(
    properties=DelimitedTextDataset(  # Adjusted class
        linked_service_name={"referenceName": LINKED_SERVICE_NAME, "type": "LinkedServiceReference"},
        folder_path=SOURCE_FOLDER_PATH,
        file_pattern=SOURCE_FILE_PATTERN,  # Use file pattern instead of specific file name
        format={"type": "TextFormat", "columnDelimiter": ",", "rowDelimiter": "\n", "firstRowAsHeader": True}
    )
)

# Define sink dataset with dynamic file name
sink_dataset = DatasetResource(
    properties=DelimitedTextDataset(  # Adjusted class
        linked_service_name={"referenceName": LINKED_SERVICE_NAME, "type": "LinkedServiceReference"},
        folder_path=SINK_FOLDER_PATH,
        file_name=SINK_FILE_NAME,  # Dynamic file name
        format={"type": "TextFormat", "columnDelimiter": ",", "rowDelimiter": "\n", "firstRowAsHeader": True}
    )
)

# Create datasets
source_dataset = synapse_client.dataset.create_or_update(
    RESOURCE_GROUP_NAME, WORKSPACE_NAME, SOURCE_DATASET_NAME, source_dataset
)
sink_dataset = synapse_client.dataset.create_or_update(
    RESOURCE_GROUP_NAME, WORKSPACE_NAME, SINK_DATASET_NAME, sink_dataset
)

# Define a simple data flow
data_flow = DataFlowResource(
    properties=MappingDataFlow(
        sources=[DataFlowSource(name="source1", dataset={"referenceName": SOURCE_DATASET_NAME, "type": "DatasetReference"})],
        sinks=[DataFlowSink(name="sink1", dataset={"referenceName": SINK_DATASET_NAME, "type": "DatasetReference"})],
        transformations=[]  # Add transformations here if needed
    )
)

# Create the data flow
data_flow = synapse_client.data_flow.create_or_update(
    RESOURCE_GROUP_NAME, WORKSPACE_NAME, DATA_FLOW_NAME, data_flow
)

# Define the pipeline
pipeline = PipelineResource(
    activities=[
        CopyActivity(
            name="CopyActivity",
            source={"type": "BlobSource"},
            sink={"type": "BlobSink"},
            inputs=[{"referenceName": SOURCE_DATASET_NAME, "type": "DatasetReference"}],
            outputs=[{"referenceName": SINK_DATASET_NAME, "type": "DatasetReference"}]
        )
    ]
)

# Create the pipeline
pipeline = synapse_client.pipeline.create_or_update(
    RESOURCE_GROUP_NAME, WORKSPACE_NAME, PIPELINE_NAME, pipeline
)

print(f"Pipeline '{pipeline.name}' created successfully.")

# Optionally, run the pipeline
run_response = synapse_client.pipeline.create_run(RESOURCE_GROUP_NAME, WORKSPACE_NAME, PIPELINE_NAME)
print(f"Pipeline run ID: {run_response.run_id}")