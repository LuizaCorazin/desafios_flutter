# Desafios Flutter

Implementação de três desafios práticos focados em lógica, cálculos do dia a dia e armazenamento local no dispositivo.

---

##  Desafios

### 1. Caminhadas x Calorias (`flutter_desafio1`)
Aplicativo para registrar histórico de caminhadas e calcular a estimativa de gasto calórico médio.
* **Fórmula:** `Gasto Calórico = Peso (kg) × Distância (km) × 0.7`
* **Recursos:** Splash screen com tema escuro, listagem de registros, cadastro/edição via modal e persistência local.

<p align="center">
  <img src="images/academia/splash_branco.png" width="180" alt="Splash Caminhadas" />
  <img src="images/academia/home_branco.png" width="180" alt="Home Caminhadas" />
  <img src="images/academia/cadastro_branco.png" width="180" alt="Cadastro Caminhadas" />
  <img src="images/academia/dados_branco.png" width="180" alt="Dados Caminhadas" />
</p>

---

### 2. Consumo de Água (`flutter_desafio2`)
Controle de ingestão diária de água com meta diária calculada com base no peso do usuário.
* **Fórmula:** `Meta Diária (ml) = Peso (kg) × 35 ml`
* **Recursos:** Exibição em cards, porcentagem da meta atingida, gráfico de consumo e salvamento local.

<p align="center">
  <img src="images/agua/splash.png" width="180" alt="Splash Água" />
  <img src="images/agua/home.png" width="180" alt="Home Água" />
  <img src="images/agua/cadastro.png" width="180" alt="Cadastro Água" />
  <img src="images/agua/dados.png" width="180" alt="Dados Água" />
</p>

---

### 3. Abastecimento de Veículos (`flutter_desafio3`)
Histórico de combustível para acompanhamento do preço médio por litro e rendimento do veículo.
* **Cálculos:** Preço médio por litro (`Valor ÷ Litros`) e consumo médio (`km/L`) considerando o abastecimento anterior.
* **Recursos:** Cabeçalho com métricas médias, gráfico comparativo, modal de edição e armazenamento local.

<p align="center">
  <img src="images/gasolina/splash.png" width="180" alt="Splash Abastecimento" />
  <img src="images/gasolina/home.png" width="180" alt="Home Abastecimento" />
  <img src="images/gasolina/cadastro.png" width="180" alt="Cadastro Abastecimento" />
  <img src="images/gasolina/dados.png" width="180" alt="Dados Abastecimento" />
</p>

---

##  Tecnologias
- **Linguagem:** Dart
- **Framework:** Flutter
- **Persistência:** Armazenamento Local
- **UI:** Suporte a Tema Claro / Escuro

---

##  Como Executar

1. Clone o repositório:
   ```bash
   git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)
Entre na pasta do desafio que deseja testar:
cd flutter_desafio1

Instale as dependências:
 ```bash
flutter pub get
 ```
Execute a aplicação:
  ```bash
flutter run
```
1. Clone o repositório:
   ```bash
   git clone [https://github.com/seu-usuario/seu-repositorio.git](https://github.com/seu-usuario/seu-repositorio.git)
