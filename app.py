from flask import Flask
import os
from azure.identity import ManagedIdentityCredential
from azure.keyvault.secrets import SecretClient

app = Flask(__name__)

@app.route("/")
def index():
    key_vault_url = os.environ.get("KEY_VAULT_URL")
    secret_name = os.environ.get("SECRET_NAME")

    credential = ManagedIdentityCredential()
    client = SecretClient(vault_url=key_vault_url, credential=credential)

    secret = client.get_secret(secret_name)

    return f"The secret is: {secret.value}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)

