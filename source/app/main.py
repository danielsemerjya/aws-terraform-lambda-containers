import json
from os import environ
from utils import OpenAIGenerator as ImageGenerator


def handler(event, context):
    gen = ImageGenerator(api_key=environ.get("OPENAI_API_KEY"))

    url = gen.generate_image(what="Dog", style="Happy")

    resp = {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"url": url}),
    }

    return resp


if __name__ == "__main__":
    pass
