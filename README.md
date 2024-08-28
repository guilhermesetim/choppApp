# ChoppApp

ChoppApp é um aplicativo Flutter que permite aos usuários escanear QR Codes para liberar chopp diretamente de um dispenser. O projeto utiliza a arquitetura MVC, com o backend gerenciado pelo Supabase, e a comunicação com o dispenser é feita via POST em um servidor Python que se comunica com o Arduino via serial.

## Alunos:
- Guilherme Setim
- Leonardo Pavan

## Funcionalidades

* **Login:** Autenticação de usuários utilizando Supabase.
* **Cadastro** Cadastro de usuário com confirmação por e-mail.
* **Consumo via QR Code:** Escaneie o QR Code na torneira do chopp para liberar a bebida.
* **Saldo e Compra:** Verifique o saldo disponível e compre créditos adicionais diretamente pelo app.
* **Histórico:** Consulte o histórico de consumo, incluindo detalhes de cada sessão.
* **Lista de Chopp’s:** Veja uma lista de chopps disponíveis para consumo.

## Arquitetura do aplicativo *mobile*

O projeto segue a arquitetura MVC:

* **Model:** Define as estruturas de dados e interage com o Supabase para operações de CRUD.
* **View:** Contém toda a lógica de interface com o usuário, exibindo as telas e recebendo interações.
* **Controller:** Intermedia a comunicação entre a View e a Model, processando as entradas do usuário e atualizando a interface conforme necessário.

## Tecnologias Utilizadas

* **Flutter:** Framework principal para o desenvolvimento do aplicativo.
* **Supabase:** Utilizado para autenticação, banco de dados e backend.
* **Arduino:** Controla o dispenser de chopp.
* **Python:** servidor que recebe uma requisição via POST do aplicativo para liberar a bebida após a leitura do QR Code.

## Estrutura do repositório

- **choppapp_arduino/**: Diretório do código-fonte do microcontrolador Arduino.
- **choppapp_flutter/**: Diretório do código-fonte do projeto do aplicativo *mobile*.
- **server_flutter/**: Diretório do código-fonte do servidor Python, que recebe uma requisição HTTP POST, e comunica via serial com o microcontrolador.
- **qrCodes.pdf**: QRcodes de exemplo e formatados para testar a aplicação.
- **README.md**: Arquivo de documentação do projeto.

## Executar o projeto:
`git clone https://github.com/guilhermesetim/choppApp.git`

Navegue até o diretório choppapp_flutter/ e execute o projeto flutter.
