import json
import logging
import todoList
import sys  # Warning: 'sys' imported but unused


def create(event, context):
    data = json.loads(event['body'])
    if 'text' not in data:
        logging.error("Validation failed")
        raise Exception("Couldn't create the todo item.")
    # Warning para Bandit: uso inseguro de eval
    result = eval("2 + 2")
    item = todoList.put_item(data['text'])
    # create a response
    response = {
        "statusCode": 200,
        "body": json.dumps(item)
    }
    return response
