# Upload de Arquivo XML (Nota Fiscal)

## Descrição
Este projeto é uma aplicação para upload e processamento de arquivos XML de notas fiscais. Ele permite que os usuários façam login, façam upload de arquivos XML, processem esses arquivos em segundo plano e gerem relatórios detalhados com base nas informações extraídas dos arquivos XML, podendo filtrar os relatórios para facilitar a busca, e também podendo exportar o relatório gerado. 

## Funcionalidades

- **Autenticação de Usuários:** Login utilizando a gem [Devise](https://github.com/heartcombo/devise) para controle de acesso à aplicação.
- **Upload de Arquivos:** Utiliza o [Active Storage](https://guides.rubyonrails.org/active_storage_overview.html) para fazer upload e armazenar arquivos XML.
- **Processamento em Segundo Plano:** Implementado com [Sidekiq](https://github.com/mperham/sidekiq) para processamento assíncrono dos arquivos XML.
- **Geração de Relatórios:** Após o processamento, gera relatórios detalhados com as seguintes informações extraídas do arquivo XML:

  ### Dados do Documento Fiscal
  - **Número de Série (serie)**
  - **Número da Nota Fiscal (nNF)**
  - **Data e Hora de Emissão (dhEmi)**
  - **Dados do Emitente (emit):**
    - Nome (xNome)
    - CNPJ
    - Telefone
    - Endereço
    - Cidade
    - Estado
    - CEP
    - País
    - Inscrição Estadual
  - **Dados do Destinatário (dest):**
    - Nome (xNome)
    - CNPJ
    - Endereço
    - Cidade
    - Estado
    - CEP
    - País
    - Inscrição Estadual

  ### Produtos Listados
  - **Nome (xProd)**
  - **NCM (NCM)**
  - **CFOP (CFOP)**
  - **Unidade Comercializada (uCom)**
  - **Quantidade Comercializada (qCom)**
  - **Valor Unitário (vUnCom)**

  ### Impostos Associados
  - **Valor do ICMS (vICMS)**
  - **Valor do IPI (vIPI)**
  - **Valor do PIS (vPIS)**
  - **Valor do COFINS (vCOFINS)**

  ### Totalizadores
  - **Resumo dos Valores Totais:**
    - Total dos Produtos
    - Total do ICMS
    - Total do IPI
    - Total do PIS
    - Total do COFINS

## Requisitos

- Ruby (versão especificada no `Gemfile`)
- Rails (versão especificada no `Gemfile`)
- [PostgreSQL](https://www.postgresql.org/) 
- [Redis](https://redis.io/) para o Sidekiq
- [Sidekiq](https://github.com/mperham/sidekiq) para processamento em segundo plano

## Instalação

1. Clone o repositório:
    ```bash
    git clone https://github.com/beto-machado/upload_xml.git
    cd upload_xml
    ```

2. Instale as dependências:
    ```bash
    bundle install
    ```

3. Configure o banco de dados:
    ```bash
    rails db:create
    rails db:migrate
    ```

4. Configure o Redis para o Sidekiq.

5. Inicie o servidor Rails:
    ```bash
    rails server
    ```

5. Em outro terminal, inicie o Redis:
    ```bash
    redis-server
    ```

6. Em outro terminal, inicie o Sidekiq:
    ```bash
    bundle exec sidekiq
    ```

## Uso

- **Login:** Acesse a página de login e entre com suas credenciais.
- **Upload de Arquivo:** Faça o upload do arquivo XML através da interface fornecida.
- **Processamento:** O arquivo será processado em segundo plano. Após o processamento, você poderá gerar relatórios detalhados.
- **Relatórios:** Visualize e exporte os relatórios gerados com base nas informações extraídas dos arquivos XML.


