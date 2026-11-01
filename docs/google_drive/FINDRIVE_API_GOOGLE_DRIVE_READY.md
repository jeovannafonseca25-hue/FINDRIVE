# FINDRIVE — ESPECIFICAÇÃO DE APIS E CONTRATOS (VERSÃO GOOGLE DRIVE & DOCS)
*Este documento foi estruturado para ser importado diretamente no Google Docs ou compartilhado via Google Drive sem quebra de formatação.*

---

## Instruções Rápidas para Importar no Google Drive:
1. Abra o **Google Drive** (drive.google.com).
2. Clique no botão **+ Novo** > **Upload de arquivo**.
3. Selecione este arquivo (`FINDRIVE_API_GOOGLE_DRIVE_READY.md`) ou abra-o em um editor de texto, copie todo o conteúdo (`Ctrl+A`, `Ctrl+C`).
4. Crie um novo **Documento Google** (Google Docs) e cole (`Ctrl+V`). A formatação de tabelas, títulos e blocos de código será preservada perfeitamente.

---

# 1. RESUMO EXECUTIVO DO FINDRIVE

| Parâmetro | Detalhe |
|---|---|
| **Nome da Aplicação** | FINDRIVE |
| **Público-Alvo** | Motoristas e Entregadores de Aplicativo (Uber, 99, iFood, Indrive) |
| **Proposta de Valor** | Gestão Financeira 360°, Meta Reversa Diária, Controle de Hora Líquida Real e Reserva Preventiva (CPK) |
| **Identidade Visual** | Amarelo 99 (#FFC700) + Design Minimalista Uber (Preto #121212, Geométrico, Alto Contraste) |
| **Padrão Arquitetural** | Clean Architecture + MVVM-C + Factory Pattern (Flutter / Dart) |

---

# 2. CONTRATOS DE API RESTful

### Resumo dos Principais Endpoints

| Método | Endpoint | Finalidade | Status Esperado |
|---|---|---|---|
| `POST` | `/api/v1/auth/login` | Login do motorista e emissão de JWT | 200 OK |
| `POST` | `/api/v1/vehicles` | Cadastro de Veículo (Alugado ou Próprio) e Break-Even | 201 Created |
| `GET` | `/api/v1/expenses/fixed-monthly` | Consolidação 360° de Custos (Casa + Carro) | 200 OK |
| `POST` | `/api/v1/goals/calculate-reverse` | Cálculo de Meta Reversa Diária e Modo Folga | 200 OK |
| `GET` | `/api/v1/goals/daily/today` | Status da Meta em Tempo Real (R$ e Horas Restantes) | 200 OK |
| `POST` | `/api/v1/shifts/start` | Início do Turno de Rodagem e Cronômetro | 201 Created |
| `POST` | `/api/v1/shifts/{id}/stop` | Encerramento do Turno e Apuração de Hora Líquida | 200 OK |
| `GET` | `/api/v1/maintenance/vault` | Saldo da Carteira de Manutenção e CPK | 200 OK |
| `POST` | `/api/v1/transactions/ocr-extract` | Leitura Inteligente de Nota de Combustível / Ganhos | 200 OK |
| `GET` | `/api/v1/intelligence/smart-shifts` | Mapa de Calor de Horários de Pico e Alta Rentabilidade | 200 OK |
| `GET` | `/api/v1/notifications/smart-alerts` | Alertas Contextualizados em Número de Corridas Médias | 200 OK |
| `GET` | `/api/v1/reports/fiscal-summary` | Demonstrativo Carnê-Leão e MEI para IRPF | 200 OK |

---

# 3. DETALHAMENTO DAS REQUISIÇÕES E RESPOSTAS

### 3.1 Login do Motorista (`POST /api/v1/auth/login`)
* **Headers:** `Content-Type: application/json`
* **Request Payload:**
```json
{
  "email": "carlos.motorista@email.com",
  "password": "SenhaSegura@2026"
}
```
* **Response Payload (200 OK):**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "driver": {
      "id": "drv_8849201",
      "name": "Carlos Eduardo da Silva",
      "email": "carlos.motorista@email.com",
      "activeVehicleId": "veh_0921"
    }
  }
}
```

---

### 3.2 Cadastro de Veículo Alugado & Break-Even (`POST /api/v1/vehicles`)
* **Headers:** `Authorization: Bearer <token>`, `Content-Type: application/json`
* **Request Payload:**
```json
{
  "type": "car",
  "model": "Chevrolet Onix 1.0",
  "plate": "BRA2E19",
  "regime": "rented",
  "rental": {
    "rentalCompany": "Localiza Meoo / Zarp",
    "periodicity": "weekly",
    "costAmount": 680.00,
    "paymentDueDayOfWeek": 3
  },
  "currentOdometerKm": 48250,
  "fuelEfficiencyKmPerLiter": 11.2
}
```
* **Response Payload (201 Created):**
```json
{
  "success": true,
  "data": {
    "vehicleId": "veh_0921",
    "regime": "rented",
    "breakEven": {
      "ridesNeededPerWeek": 28,
      "estimatedHoursToCover": 18.5,
      "breakEvenDayOfWeek": "Quarta-feira",
      "breakEvenStatusMessage": "A partir da 28ª corrida da semana, todo ganho é lucro líquido."
    }
  }
}
```

---

### 3.3 Meta Reversa Diária (`POST /api/v1/goals/calculate-reverse`)
* **Request Payload:**
```json
{
  "targetMonthlyNetIncome": 4500.00,
  "scheduledDaysOffPerWeek": [0, 1],
  "maintenanceRetentionPercentage": 10.0,
  "averageFuelExpensePercentage": 24.0,
  "platformAverageFeePercentage": 18.0
}
```
* **Response Payload (200 OK):**
```json
{
  "success": true,
  "data": {
    "summary": {
      "daysWorkedPerMonth": 22,
      "dailyNetIncomeTarget": 204.55,
      "dailyFixedCostsShare": 174.55,
      "dailyMaintenanceReserve": 44.34,
      "dailyGrossTarget": 443.40,
      "weeklyGrossTarget": 2217.00
    },
    "hourlyEstimates": {
      "estimatedHoursNeededPerDay": 7.8,
      "targetNetHourlyRate": 36.80
    },
    "guaranteedDaysOff": {
      "enabled": true,
      "daysOffCount": 8,
      "redistributionMessage": "Custos fixos redistribuídos nos dias úteis com sucesso."
    }
  }
}
```

---

### 3.4 Fechamento de Turno & Hora Líquida Real (`POST /api/v1/shifts/{id}/stop`)
* **Request Payload:**
```json
{
  "endOdometerKm": 48430,
  "grossEarnings": 380.00,
  "ridesCompletedCount": 14,
  "fuelRefillCost": 85.00
}
```
* **Response Payload (200 OK):**
```json
{
  "success": true,
  "data": {
    "shiftId": "shf_99410",
    "durationHours": 7.5,
    "totalKm": 180,
    "grossEarnings": 380.00,
    "fuelCost": 85.00,
    "cpkMaintenanceCost": 28.80,
    "fixedCostShare": 65.00,
    "netProfit": 201.20,
    "realNetRatePerHour": 26.83,
    "maintenanceTransferredToVault": 38.00
  }
}
```

---

### 3.5 Alerta Inteligente Baseado em Corridas (`GET /api/v1/notifications/smart-alerts`)
* **Response Payload (200 OK):**
```json
{
  "success": true,
  "data": [
    {
      "id": "notif_9102",
      "type": "bill_due_warning",
      "title": "Conta de Energia Vence Amanhã!",
      "message": "Sua conta de luz de R$ 180,00 vence amanhã. No seu ritmo atual, faltam apenas 2 corridas médias para cobrir.",
      "billAmount": 180.00,
      "ridesEquivalent": 2,
      "priority": "high",
      "dueDate": "2026-10-31"
    }
  ]
}
```
