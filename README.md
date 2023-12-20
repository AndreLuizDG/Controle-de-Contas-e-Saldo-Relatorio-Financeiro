# Controle de Contas e Saldo - Relatório Financeiro

Este repositório contém um programa ABAP desenvolvido para o SAP ERP, criado com o objetivo de gerar um relatório financeiro detalhado sobre contas contábeis e seus saldos. O programa, denominado REPORT z_algj_37, utiliza tabelas essenciais do SAP, como BKPF, SKA1, SKB1, SKAT e GLT0, para extrair dados cruciais que são processados e apresentados de maneira organizada.

## Funcionalidades Principais

- **Seleção de Dados:**
  - O programa permite a seleção de dados com base em parâmetros como empresa (BUKRS), plano de contas (KTPL), número da conta (SAKNR) e exercício fiscal (RYEAR).

- **Processamento de Dados:**
  - Os dados selecionados são processados para calcular a soma dos valores em diferentes campos (TSL01 a TSL12) da tabela GLT0, proporcionando uma visão consolidada dos saldos.

- **Categorização Visual:**
  - O relatório categoriza visualmente as contas contábeis com cores distintas, facilitando a identificação rápida de diferentes faixas de valores. As cores indicam se o saldo é nulo, baixo, médio ou alto.

- **Exibição em ALV:**
  - Utilizando o Advanced List Viewer (ALV), o resultado é apresentado de forma tabular e interativa, permitindo uma análise eficiente.

## Utilização

1. Execute o programa ABAP REPORT z_algj_37 no ambiente SAP ERP.
2. Selecione os parâmetros desejados, como empresa, número da conta, e exercício fiscal.
3. O relatório será gerado e exibido no ALV com categorias de cores para facilitar a interpretação.

## Requisitos

- Ambiente SAP ERP.

## Contribuições

Contribuições são bem-vindas!

---

**Nota:** Este projeto é um exemplo fictício de um programa ABAP para fins educacionais.