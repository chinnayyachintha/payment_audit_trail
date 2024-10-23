import json
import boto3
import os
import logging

# Initialize logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# Initialize clients for DynamoDB
dynamodb = boto3.client('dynamodb')

# Environment variables
DYNAMODB_TABLE = os.environ['DYNAMODB_TABLE']

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event, indent=2))
    
    # Process each record in the event
    for record in event['Records']:
        try:
            # Extract the message body from SQS
            message_body = json.loads(record['body'])
            logger.info("Processing message: %s", message_body)

            # Extract payment data from the message
            payment_data = message_body.get('paymentData')
            if payment_data:
                log_to_dynamodb(payment_data)
            else:
                logger.warning("No payment data found in the message: %s", message_body)

        except json.JSONDecodeError as e:
            logger.error("JSON decode error: %s", str(e))
        except Exception as e:
            logger.error("Error processing record: %s", str(e))

    return {
        'statusCode': 200,
        'body': json.dumps('Messages processed successfully')
    }

def log_to_dynamodb(payment_data):
    item = {
        'paymentId': {'S': payment_data['id']},  # Assuming payment data has 'id'
        'amount': {'N': str(payment_data['amount'])},  # Assuming payment data has 'amount'
        'timestamp': {'S': payment_data['timestamp']},  # Assuming payment data has 'timestamp'
        # Add additional fields from payment_data as needed
    }

    try:
        # Put the item into the DynamoDB table
        dynamodb.put_item(TableName=DYNAMODB_TABLE, Item=item)
        logger.info("Successfully logged payment data: %s", item)

    except Exception as e:
        logger.error("Error logging to DynamoDB: %s", str(e))
