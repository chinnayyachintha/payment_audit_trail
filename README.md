# Payment Audit Trail System

## Overview

The Payment Audit Trail System is designed to log and persist detailed audit information for access to payment transaction data. It records crucial information to help monitor, review, and ensure the integrity of payment data interactions.

## Objective

The goal is to capture and store audit logs for any access or interaction with payment transaction data. The system records essential details to facilitate compliance with regulatory standards, enhance data security, and support troubleshooting efforts.

## Key Requirements

### Audit Log Information
The system logs the following details for each access event:
1. **Who accessed** the payment transaction data (user or system identity).
2. **When it was accessed** (timestamp of the event).
3. **Which records** were accessed or queried (record identifiers or query details).
4. **What records** were included in the response (IDs of records returned).
5. **Result of the query** (e.g., successful, failed).

### Storage and Backup
- Store the audit trail in **DynamoDB**, as QLDB will be phased out soon.
- **Regularly back up** the DynamoDB data to Amazon S3 to ensure data safety and meet data retention requirements.

### Optional Integration
- Use **SQS FIFO messaging** to maintain the correct order of audit logs while increasing throughput for processing.

## Why It’s Needed

1. **Compliance and Security**: The audit trail helps satisfy regulatory requirements by keeping track of who accessed payment data and when.
2. **Troubleshooting**: Provides valuable information for diagnosing issues related to payment data access.
3. **Data Integrity and Accountability**: Ensures a complete and accurate history of interactions with payment data, which can be crucial for audits.

## Implementation Steps

1. **Set Up DynamoDB Table**
   - Create a DynamoDB table with a schema that includes:
     - `user_id` (who accessed)
     - `timestamp` (when accessed)
     - `query_record_id` (which records were queried)
     - `response_record_ids` (what records were included)
     - `query_result` (result of the query)

2. **Update Logging Mechanism**
   - Modify your application or Lambda functions to log relevant access events to the DynamoDB table.
   - Ensure all required fields are recorded for each interaction with the payment data.

3. **Implement Backups**
   - Configure automated or manual backups to S3 at regular intervals.
   - Use DynamoDB's built-in backup capabilities or create a Lambda function to periodically export data to S3.

4. **(Optional) SQS Integration**
   - Use Amazon SQS with FIFO queues for ordered log processing if the system requires high throughput or batch processing of audit logs.

## Example Schema for DynamoDB Table

| Attribute Name          | Type     | Description                                 |
|-------------------------|----------|---------------------------------------------|
| `user_id`               | String   | Identity of the user or system accessing the data |
| `timestamp`             | String   | The timestamp when the data was accessed    |
| `query_record_id`       | String   | Identifier of the records queried           |
| `response_record_ids`   | List     | List of identifiers for the records returned |
| `query_result`          | String   | Outcome of the query (e.g., success, failure)|

## Backup Strategy

- **S3 Backups**: Configure a regular backup schedule, such as daily or weekly.
- **DynamoDB Backups**: Use on-demand or continuous backups to ensure data is recoverable.

## Optional SQS FIFO Messaging Setup

1. **Create an SQS FIFO Queue**: Use a FIFO queue to maintain the correct order of messages.
2. **Integrate with Logging Mechanism**: Send messages to the queue before inserting them into DynamoDB.
3. **Process Messages**: Set up a consumer (e.g., Lambda function) to read from the queue and store the logs in DynamoDB.

## Testing

- **Functional Testing**: Ensure that each access event is correctly logged in the DynamoDB table.
- **Backup Validation**: Verify that backups are correctly stored in S3.
- **SQS Integration Testing**: If using SQS, confirm that messages are processed in the correct order.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.


--------------------------------------------------------------------------------
# Payment Processing Audit Trail

## Overview

This project implements a payment processing audit trail system using various AWS services. The primary goal is to asynchronously process payment messages and store relevant information in a DynamoDB table for future reporting and retrieval.

## AWS Resources

### 1. DynamoDB Table
- **Purpose**: To store payment audit trail data, including payment information.
- **Key Attributes**:
  - `paymentId` (Partition Key): Unique identifier for each payment.
  - `amount`: The amount of the payment.
  - `timestamp`: The time at which the payment was processed.

### 2. SQS Queue
- **Purpose**: To handle the asynchronous processing of payment messages.
- **Configuration**: The SQS queue is set up to trigger the AWS Lambda function whenever a new message is available.

### 3. AWS Lambda Function
- **Purpose**: To process incoming messages from the SQS queue and log the payment data into the DynamoDB table.
- **Configuration**:
  - **Runtime**: Python 3.9.
  - **Handler**: The main entry point for the Lambda function is defined in the script.
  - **Environment Variables**: The name of the DynamoDB table is passed as an environment variable.

### 4. IAM Role for Lambda Execution
- **Purpose**: To grant the Lambda function the necessary permissions to access AWS resources.
- **Permissions**:
  - `dynamodb:PutItem` on the DynamoDB table.
  - `sqs:ReceiveMessage`, `sqs:DeleteMessage`, and `sqs:GetQueueAttributes` on the SQS queue.
- **Trust Relationship**: The role trusts the Lambda service to assume it.

### 5. CloudWatch Logs
- **Purpose**: For logging and monitoring Lambda function executions. This enables tracking of successful operations and error handling.
- **Configuration**: CloudWatch logging is automatically enabled for Lambda functions. Ensure logging is implemented within the function to capture important events.

### 6. (Optional) S3 Bucket
- **Purpose**: To back up data or store relevant files if necessary.
- **Configuration**: Set up the S3 bucket for storing backup data or files and provide access permissions for the Lambda function.

## Resource Flow

1. **SQS Queue**: Receives payment messages.
2. **AWS Lambda**: Triggered by new messages in the SQS queue, processes the data, and logs it into the DynamoDB table.
3. **DynamoDB**: Stores the payment audit trails for future retrieval and reporting.

## Setup Instructions

### Prerequisites
- AWS Account
- AWS CLI configured with appropriate permissions
- Terraform installed (if using Terraform for resource management)

### Deployment Steps

1. **Create DynamoDB Table**:
   - Use the AWS Management Console or Terraform to create a table named `payment-audit-trail`.

2. **Create SQS Queue**:
   - Create an SQS queue named `audit-trail-queue` using the AWS Management Console or Terraform.

3. **Create IAM Role**:
   - Create an IAM role for Lambda execution with the necessary permissions to access DynamoDB and SQS.

4. **Deploy Lambda Function**:
   - Write the Lambda function code (as provided in the project) and package it into a ZIP file.
   - Create a Lambda function in AWS and link it to the SQS queue as a trigger.

5. **Set Up CloudWatch Logs**:
   - Ensure CloudWatch logging is enabled for the Lambda function.

6. **(Optional) Create S3 Bucket**:
   - If needed, create an S3 bucket to store backups or other relevant data.

## Testing
- Send a test message to the SQS queue with the expected payment data format.
- Monitor the Lambda function execution in CloudWatch logs to ensure successful processing.
- Check the DynamoDB table to verify that the payment data has been logged correctly.

## Conclusion
This project provides a scalable solution for processing payment audit trails using AWS services. Feel free to extend the functionality or modify the resources as per your requirements.
