import os
import requests

class OpenAIGenerator:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.model = "dall-e-3"
        self.image_size = "1024x1024"
        self.image_quality = "standard"
        
    def generate_image(self):
        prompt_template = f"""
        Return any image.
        """
        url = "https://api.openai.com/v1/images/generations"
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_key}",
        }
        data = {
            "model": self.model,
            "prompt": prompt_template,
            "n": 1,
            "size": self.image_size,
        }
        
        response = requests.post(url, headers=headers, json=data)
        if response.status_code != 200:
            raise Exception(response.json())
        
        response = response.json()
        print("Image generated sucesfully successfully.")
        image_url = response["data"][0]["url"]
        return image_url