import json
import subprocess
from lib import echo

def lambda_handler(event, context):
    command(['ls','-la', '/opt'])
    command(['ls','-la', '/opt/extensions'])
    command(['ls','-la', '/opt/python'])

    echo('this is layer lib.')

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "hello world"
        }),
    }

def command(cmd):
    out = subprocess.run(cmd, stdout=subprocess.PIPE)
    print(out.stdout.decode())