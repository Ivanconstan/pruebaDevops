#!/bin/bash

# Navega a la carpeta de Terraform, inicializa y aplica la configuración
cd terraform
terraform init
terraform apply -auto-approve

# Obtén la IP pública generada por Terraform
INSTANCE_IP=$(terraform output -raw instance_ip)

# Crea el archivo hosts.ini con la IP pública obtenida
cat > ../ansible/hosts.ini <<EOL
[web]
${INSTANCE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/proyecto-clave
EOL

# Crea el archivo test_robotnginx.robot con la IP pública obtenida
cat > ../tests/test_robotnginx.robot <<EOL
*** Settings ***
Library    RequestsLibrary

*** Variables ***
${INSTANCE_IP}    ${INSTANCE_IP}
${EXPECTED_TEXT}  Bienvenido a mi servidor web Nginx

*** Test Cases ***
Check Nginx Server is Running and Serving Correct Page
    [Documentation]    Verifica que el servidor Nginx está corriendo y devuelve la página HTML esperada.
    Create Session    nginx    http://${INSTANCE_IP}
    ${response}=    Get Request    nginx    /
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    ${EXPECTED_TEXT}
EOL
