# Vault

## Setting Up Vault for PKI

[Vault PKI Setup](https://learn.hashicorp.com/vault/secrets-management/sm-pki-engine)

```
# generate self signed root cert
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal \
        common_name="example.com" \
        ttl=87600h key_bits=4096 > /tmp/CA_cert.crt
vault write pki/config/urls \
        issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" \
        crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"

# generate intermediate cert authority
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int
vault write -format=json pki_int/intermediate/generate/internal \
        common_name="example.com Intermediate Authority" \
        | jq -r '.data.csr' > /tmp/pki_intermediate.csr
vault write -format=json pki/root/sign-intermediate csr=@/tmp/pki_intermediate.csr \
        format=pem_bundle ttl="43800h" \
        | jq -r '.data.certificate' > /tmp/intermediate.cert.pem
vault write pki_int/intermediate/set-signed certificate=@/tmp/intermediate.cert.pem

# create role
vault write pki_int/roles/example-dot-com \
        allowed_domains="example.com" \
        allow_subdomains=true \
        max_ttl="720h"

# get a cert
vault write pki_int/issue/example-dot-com common_name="test.example.com" ttl="24h"
```