*** Settings ***
Library    RequestsLibrary

*** Variables ***
${INSTANCE_IP}    34.240.188.88    # IP pública de la máquina virtual
${EXPECTED_TEXT}  Bienvenido a mi servidor web Nginx

*** Test Cases ***
Check Nginx Server is Running and Serving Correct Page
    [Documentation]    Verifica que el servidor Nginx está corriendo y devuelve la página HTML esperada.
    Create Session    nginx    http://${INSTANCE_IP}
    ${response}=    Get Request    nginx    /
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    ${EXPECTED_TEXT}
