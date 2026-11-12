# Aplicativo de Previsão do Tempo (CPTEC/INPE)

Aplicativo desenvolvido em Flutter para consultar a previsão do tempo de cidades brasileiras, integrando os serviços e dados disponibilizados pelo CPTEC/INPE.

---

## 📋 Funcionalidades Implementadas
* **Pesquisa de Cidades:** Permite ao usuário digitar o nome de uma cidade para buscar as localidades correspondentes no serviço do CPTEC, exibindo o nome e a UF para seleção[cite: 203].
* **Previsão para 4 Dias:** Exibe a previsão detalhada da localidade selecionada contendo a data, temperaturas mínima e máxima em graus Celsius, descrição das condições do tempo, ícone representativo e índice ultravioleta (IUV)[cite: 203].
* **Atualização e Tratamento de Erros:** Opção de atualizar a previsão da cidade selecionada, indicador visual de carregamento e tratamento para casos de falhas de conexão ou cidades não encontradas[cite: 204].

---

## 🛠️ Bibliotecas Utilizadas
* **`http`**: Para realizar as requisições HTTP nas APIs públicas do CPTEC/INPE[cite: 203].
* **`xml`**: Para o tratamento e interpretação (parser) dos dados recebidos no formato XML[cite: 203, 204].
* **`sqflite` e `path`**: Para gerenciar a criação e manipulação do banco de dados relacional local[cite: 203].
* **`shared_preferences`**: Para armazenamento leve de preferências de estado e dados rápidos no dispositivo.

---

## 🚀 Instruções para Executar o Projeto

1. Certifique-se de ter o **Flutter SDK** e o **Dart** devidamente configurados na sua máquina.
2. Clone este repositório e abra a pasta do projeto no terminal:
   ```bash
   cd app_previsao_tempo
